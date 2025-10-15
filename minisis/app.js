'use strict';

(function () {
  // College GPA System (Philippine): 1.0 = Excellent, 5.0 = Failing
  // Honor threshold: 2.0 or better (Dean's List)
  const HONOR_THRESHOLD = 2.0;
  // Key for storing the student data in the browser's local storage
  const LOCAL_STORAGE_KEY = 'studentDataXML';

  /** @type {XMLDocument|null} */
  let xmlDoc = null;

  /** UI state */
  const state = {
    searchQuery: '',
    honorOnly: false,
    courseFilter: 'ALL',
    yearFilter: 'ALL',
    currentPage: 'dashboard'
  };

  /** Cached DOM elements */
  const els = {
    // Sidebar
    sidebar: document.getElementById('sidebar'),
    sidebarToggle: document.getElementById('sidebarToggle'),
    
    // Theme
    themeToggle: document.getElementById('themeToggle'),
    themeText: document.getElementById('themeText'),
    
    // Navigation
    navItems: document.querySelectorAll('.nav-item'),
    pages: document.querySelectorAll('.page'),
    
    // Search & Controls
    searchInput: document.getElementById('searchInput'),
    // Honor toggle button removed from dashboard
    honorFilter: document.getElementById('honorFilter'),
    courseFilter: document.getElementById('courseFilter'),
    yearFilter: document.getElementById('yearFilter'),
    reloadBtn: document.getElementById('reloadBtn'),
    exportBtn: document.getElementById('exportBtn'),
    exportPdfBtn: document.getElementById('exportPdfBtn'),
    
    // Dashboard
    currentDate: document.getElementById('currentDate'),
    totalStudents: document.getElementById('totalStudents'),
    honorStudents: document.getElementById('honorStudents'),
    totalCourses: document.getElementById('totalCourses'),
    
    // Table
    tableBody: document.getElementById('studentsTableBody'),
    
    // Forms
    addForm: document.getElementById('addForm'),
    addName: document.getElementById('addName'),
    addCourse: document.getElementById('addCourse'),
    addYear: document.getElementById('addYear'),
    addGrade: document.getElementById('addGrade'),
    editForm: document.getElementById('editForm'),
    editStudentSelect: document.getElementById('editStudentSelect'),
    editGrade: document.getElementById('editGrade'),
    
    // Modal
    profileModal: document.getElementById('profileModal'),
    profileModalClose: document.getElementById('profileModalClose'),
    profileModalBody: document.getElementById('profileModalBody'),
    
    // Edit Details Modal
    editDetailsModal: document.getElementById('editDetailsModal'),
    editDetailsModalClose: document.getElementById('editDetailsModalClose'),
    editDetailsForm: document.getElementById('editDetailsForm'),
    editDetailsOldId: document.getElementById('editDetailsOldId'),
    editDetailsId: document.getElementById('editDetailsId'),
    editDetailsName: document.getElementById('editDetailsName'),
    editDetailsCourse: document.getElementById('editDetailsCourse'),
    editDetailsYear: document.getElementById('editDetailsYear'),
    editDetailsGrade: document.getElementById('editDetailsGrade'),
    editDetailsCancelBtn: document.getElementById('editDetailsCancelBtn'),
    
    // XSLT
    xsltOutput: document.getElementById('xsltOutput'),

    // ==== NEW: Custom Notification Elements ====
    customNotification: document.getElementById('customNotification'),
    customNotificationMessage: document.getElementById('customNotificationMessage')
  };

  // ---------- Initialization ----------
  window.addEventListener('DOMContentLoaded', async () => {
    initTheme();
    initCurrentDate();
    wireHandlers();
    await loadXML();
  });

  function initTheme() {
    const savedTheme = localStorage.getItem('theme') || 'light';
    document.documentElement.setAttribute('data-theme', savedTheme);
    updateThemeUI(savedTheme);
  }

  function updateThemeUI(theme) {
    const sunIcon = els.themeToggle.querySelector('.sun-icon');
    const moonIcon = els.themeToggle.querySelector('.moon-icon');
    
    if (theme === 'dark') {
      sunIcon.style.display = 'none';
      moonIcon.style.display = 'block';
      els.themeText.textContent = 'Light Mode';
    } else {
      sunIcon.style.display = 'block';
      moonIcon.style.display = 'none';
      els.themeText.textContent = 'Dark Mode';
    }
  }

  function initCurrentDate() {
    const now = new Date();
    const options = { year: 'numeric', month: 'long', day: 'numeric' };
    els.currentDate.textContent = now.toLocaleDateString('en-US', options);
  }

  function wireHandlers() {
    // Theme Toggle
    els.themeToggle.addEventListener('click', () => {
      const currentTheme = document.documentElement.getAttribute('data-theme');
      const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
      document.documentElement.setAttribute('data-theme', newTheme);
      localStorage.setItem('theme', newTheme);
      updateThemeUI(newTheme);
    });

    // Sidebar Toggle
    els.sidebarToggle.addEventListener('click', () => {
      els.sidebar.classList.toggle('collapsed');
      const isCollapsed = els.sidebar.classList.contains('collapsed');
      localStorage.setItem('sidebarCollapsed', isCollapsed);
    });

    const savedCollapsed = localStorage.getItem('sidebarCollapsed');
    if (savedCollapsed === 'true') {
      els.sidebar.classList.add('collapsed');
    }

    // Navigation
    els.navItems.forEach((navItem) => {
      navItem.addEventListener('click', (e) => {
        e.preventDefault();
        const targetPage = navItem.getAttribute('data-page');
        if (targetPage) switchPage(targetPage);
      });
    });

    // Search
    els.searchInput.addEventListener('input', () => {
      state.searchQuery = els.searchInput.value.trim().toLowerCase();
      renderTable();
      if (state.searchQuery && state.currentPage === 'dashboard') {
        switchPage('students');
      }
    });

    // Honor toggle button removed from dashboard

    // Filter Controls - honor filter disconnected from dashboard
    els.honorFilter.addEventListener('change', () => {
      if (state.currentPage !== 'dashboard') {
        state.honorOnly = els.honorFilter.value === 'HONOR';
        renderTable();
      }
    });

    els.courseFilter.addEventListener('change', () => {
      state.courseFilter = els.courseFilter.value;
      renderTable();
      if (state.currentPage === 'dashboard') {
        switchPage('students');
      }
    });

    els.yearFilter.addEventListener('change', () => {
      state.yearFilter = els.yearFilter.value;
      renderTable();
      if (state.currentPage === 'dashboard') {
        switchPage('students');
      }
    });

    // Sort controls removed

    // Reset Data button
    els.reloadBtn.addEventListener('click', () => {
        if (confirm('Are you sure you want to reset all data? This will discard all your changes and restore the original student list.')) {
            loadXML(true); // Pass true to force a reset from the original file
        }
    });

    // Export CSV and PDF
    if (els.exportBtn) els.exportBtn.addEventListener('click', () => exportToCSV());
    if (els.exportPdfBtn) els.exportPdfBtn.addEventListener('click', () => exportToPDF());

    // Add student form
    els.addForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const name = els.addName.value.trim();
      const course = els.addCourse.value.trim();
      const year = Number(els.addYear.value);
      const grade = Number(els.addGrade.value);
      if (!name || !course || !year || Number.isNaN(grade)) return;
      addStudent(name, course, year, grade);
      els.addForm.reset();
      switchPage('students');
    });

    // Edit student form
    els.editForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const studentId = els.editStudentSelect.value;
      const grade = Number(els.editGrade.value);
      if (!studentId || Number.isNaN(grade)) return;
      updateStudentGrade(studentId, grade);
      els.editForm.reset();
      showToast('Success', 'Grade updated successfully!', 'success');
      switchPage('students');
    });

    // Table action event delegation
    els.tableBody.addEventListener('click', (e) => {
      const target = e.target.closest('button, .student-name-link');
      if (!target) return;
      
      const action = target.getAttribute('data-action');
      const studentId = target.getAttribute('data-id');
      
      if (action === 'delete' && studentId) {
        if (confirm('Are you sure you want to delete this student?')) {
          deleteStudent(studentId);
        }
      } else if (action === 'view' && studentId) {
        showStudentProfile(studentId);
      } else if (action === 'edit' && studentId) {
        showEditDetailsModal(studentId);
      }
    });
    
    // Modal close handlers
    const closeModals = () => {
        closeModal();
        closeEditDetailsModal();
    };
    els.profileModalClose?.addEventListener('click', closeModal);
    els.profileModal?.addEventListener('click', (e) => e.target === els.profileModal && closeModal());
    els.editDetailsModalClose?.addEventListener('click', closeModals);
    els.editDetailsCancelBtn?.addEventListener('click', closeModals);
    els.editDetailsModal?.addEventListener('click', (e) => e.target === els.editDetailsModal && closeModals());
    document.addEventListener('keydown', (e) => e.key === 'Escape' && closeModals());

    // Edit Details Form submit
    els.editDetailsForm?.addEventListener('submit', (e) => {
      e.preventDefault();
      updateStudentDetails();
    });
  }

  function updateHonorButtonText() {
    const icon = `<svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>`;
    const text = state.honorOnly ? 'Show All Students' : 'Show Dean\'s List (GPA ≤2.0)';
    els.honorToggleBtn.innerHTML = icon + text;
  }

  // ---------- Page Navigation ----------
  function switchPage(pageName) {
    state.currentPage = pageName;
    els.navItems.forEach(nav => nav.classList.toggle('active', nav.getAttribute('data-page') === pageName));
    els.pages.forEach(page => page.classList.toggle('active', page.id === `${pageName}Page`));
    if (pageName === 'xslt') renderXSLT();
  }

  // ---------- XML Data Handling with localStorage ----------
  async function loadXML(forceReset = false) {
    try {
      let xmlText;
      const savedXML = localStorage.getItem(LOCAL_STORAGE_KEY);

      if (savedXML && !forceReset) {
        console.log('Loading student data from localStorage.');
        xmlText = savedXML;
      } else {
        console.log(forceReset ? 'Resetting data from original students.xml.' : 'First visit: Loading initial data from students.xml.');
        const res = await fetch('students.xml', { cache: 'no-store' });
        if (!res.ok) throw new Error(`Failed to load students.xml (Status: ${res.status})`);
        xmlText = await res.text();
        
        // Only save to localStorage if this is the first load (not a force reset)
        if (!forceReset) {
            localStorage.setItem(LOCAL_STORAGE_KEY, xmlText);
        }
      }

      const parser = new DOMParser();
      const parsed = parser.parseFromString(xmlText, 'application/xml');
      const parserError = parsed.querySelector('parsererror');
      if (parserError) {
        console.error('XML Parser Error:', parserError.textContent);
        localStorage.removeItem(LOCAL_STORAGE_KEY); // Clear corrupted data
        throw new Error('Invalid XML format in localStorage. Data has been reset.');
      }
      xmlDoc = parsed;
      refreshUI();
      if(forceReset) {
        showToast('Data Reset', 'Successfully restored the original student list.', 'success');
      }
    } catch (err) {
      console.error(err);
      showToast('Error', err.message || 'Could not load student data.', 'error');
    }
  }

  async function saveXMLToFile() {
      if (!xmlDoc) return;
      try {
        const serializer = new XMLSerializer();
        const xmlString = serializer.serializeToString(xmlDoc);
        
        // Create a FormData object to send the XML data
        const formData = new FormData();
        formData.append('xmlData', xmlString);
        
        // Send the XML data to a new save_xml.php file
        const response = await fetch('save_xml.php', {
          method: 'POST',
          body: formData
        });
        
        if (!response.ok) {
          throw new Error('Failed to save XML file');
        }
        
        console.log('XML file saved successfully');
      } catch (err) {
        console.error('Failed to save XML file:', err);
        showToast('Save Error', 'Could not save changes to XML file.', 'error');
      }
  }

  function saveXMLToLocalStorage() {
      if (!xmlDoc) return;
      try {
        const serializer = new XMLSerializer();
        const xmlString = serializer.serializeToString(xmlDoc);
        localStorage.setItem(LOCAL_STORAGE_KEY, xmlString);
        // Verify the saved data
        const savedData = localStorage.getItem(LOCAL_STORAGE_KEY);
        if (!savedData) {
            throw new Error('Data not saved properly');
        }
        console.log('Student data saved to localStorage successfully.');
        
        // Also save to XML file
        saveXMLToFile();
      } catch (err) {
        console.error('Failed to save XML to localStorage:', err);
        showToast('Save Error', 'Could not save changes to local storage.', 'error');
      }
  }

  // ---------- Rendering ----------
  function updateCourseFilter() {
    if (!xmlDoc) return;
    
    const courses = new Set();
    getStudentElements().forEach(el => {
      const course = getText(el, 'course');
      if (course) courses.add(course);
    });
    
    const sortedCourses = Array.from(courses).sort();
    const options = ['<option value="ALL">All Programs</option>'];
    
    sortedCourses.forEach(course => {
      options.push(`<option value="${escapeAttr(course)}"${state.courseFilter === course ? ' selected' : ''}>${escapeHtml(course)}</option>`);
    });
    
    els.courseFilter.innerHTML = options.join('');
  }

  function refreshUI() {
    renderDashboardStats();
    renderEditStudentDropdown();
    updateCourseFilter();
    renderTable();
  }

  function renderDashboardStats() {
    const students = getStudentElements();
    const honorCount = students.filter((el) => Number(getText(el, 'grade')) <= HONOR_THRESHOLD).length;
    const courses = new Set(students.map(el => getText(el, 'course')));
    
    els.totalStudents.textContent = students.length;
    els.honorStudents.textContent = honorCount;
    els.totalCourses.textContent = courses.size;
  }

  function getStudentElements() {
    if (!xmlDoc) return [];
    return Array.from(xmlDoc.getElementsByTagName('student'));
  }

  function applyFilters(students) {
    return students.filter((el) => {
      const name = getText(el, 'name').toLowerCase();
      const grade = Number(getText(el, 'grade'));
      const course = getText(el, 'course');
      const year = getText(el, 'year');
      
      const searchMatch = !state.searchQuery || name.includes(state.searchQuery);
      // Only apply honor filter if not on dashboard
      const honorMatch = state.currentPage === 'dashboard' ? true : (!state.honorOnly || grade <= HONOR_THRESHOLD);
      const courseMatch = state.courseFilter === 'ALL' || course === state.courseFilter;
      const yearMatch = state.yearFilter === 'ALL' || year === state.yearFilter;
      
      return searchMatch && honorMatch && courseMatch && yearMatch;
    });
  }

  function sortStudents(students) {
    // Default sort by ID
    return [...students].sort((a, b) => {
      const aId = Number(a.getAttribute('id') || '0');
      const bId = Number(b.getAttribute('id') || '0');
      return aId - bId;
    });
  }

  function renderTable() {
    const students = getStudentElements();
    const filtered = applyFilters(students);
    const sorted = sortStudents(filtered);
    const rows = sorted.map((el) => {
      const id = el.getAttribute('id') || '';
      const name = getText(el, 'name');
      const course = getText(el, 'course');
      const year = getText(el, 'year');
      const grade = Number(getText(el, 'grade'));
      const yearSuffix = year === '1' ? 'st' : year === '2' ? 'nd' : year === '3' ? 'rd' : 'th';
      const isHonor = grade <= HONOR_THRESHOLD;
      
      const honorBadge = isHonor ? '<span style="display:inline-block;margin-left:8px;background:linear-gradient(135deg,#fbbf24,#f59e0b);color:white;padding:2px 8px;border-radius:10px;font-size:11px;font-weight:700;">⭐ Dean\'s List</span>' : '';
      
      return `
        <tr>
          <td><input type="checkbox" class="select-checkbox" data-id="${escapeAttr(id)}"></td>
          <td>${escapeHtml(id)}</td>
          <td><span class="student-name-link" data-action="view" data-id="${escapeAttr(id)}" style="cursor:pointer;color:var(--blue-300);font-weight:500;">${escapeHtml(name)}</span></td>
          <td>${escapeHtml(course)}</td>
          <td>${escapeHtml(year)}${yearSuffix} Year</td>
          <td>${grade.toFixed(2)}${honorBadge}</td>
          <td style="display:flex;gap:8px;">
            <button class="action-btn secondary" data-action="edit" data-id="${escapeAttr(id)}" style="padding: 6px 10px;">Edit</button>
            <button class="action-btn danger" data-action="delete" data-id="${escapeAttr(id)}" style="padding: 6px 10px;">Delete</button>
          </td>
        </tr>
      `;
    });
    els.tableBody.innerHTML = rows.length > 0 ? rows.join('') : '<tr><td colspan="7" style="text-align:center;color:var(--text-secondary);padding:32px;">No students found matching your criteria.</td></tr>';
  }

  // Filter functions removed

  function renderEditStudentDropdown() {
    const options = getStudentElements().map(el => {
      const id = el.getAttribute('id') || '';
      return `<option value="${escapeAttr(id)}">${escapeHtml(getText(el, 'name'))} (ID: ${escapeHtml(id)})</option>`;
    });
    els.editStudentSelect.innerHTML = options.join('');
  }

  // ---------- Modify XML (in-memory) and Save ----------
  function showPopupNotification(message) {
    const popup = document.getElementById('popupNotification');
    const messageEl = popup.querySelector('.message');
    messageEl.textContent = message;
    
    popup.classList.add('show');
    
    // Hide the notification after 3 seconds
    setTimeout(() => {
      popup.classList.remove('show');
    }, 3000);
  }

  function addStudent(name, course, year, grade) {
    if (!xmlDoc) return;
    const studentsRoot = xmlDoc.getElementsByTagName('students')[0];
    const newId = getNextStudentId();
    const studentEl = xmlDoc.createElement('student');
    studentEl.setAttribute('id', newId);

    const nameEl = xmlDoc.createElement('name'); nameEl.textContent = name;
    const courseEl = xmlDoc.createElement('course'); courseEl.textContent = course;
    const yearEl = xmlDoc.createElement('year'); yearEl.textContent = String(year);
    const gradeEl = xmlDoc.createElement('grade'); gradeEl.textContent = String(grade);

    studentEl.append(nameEl, courseEl, yearEl, gradeEl);
    studentsRoot.appendChild(studentEl);
    saveXMLToLocalStorage();
    refreshUI();
    
    // Show the new popup notification
    showPopupNotification(`Student ${name} has been added successfully!`);
  }

  function updateStudentGrade(studentId, grade) {
    const student = findStudentById(studentId);
    if (student) {
      setText(student, 'grade', String(grade));
      saveXMLToLocalStorage();
      refreshUI();
    }
  }

  function deleteStudent(studentId) {
    const student = findStudentById(studentId);
    if (student?.parentNode) {
      student.parentNode.removeChild(student);
      saveXMLToLocalStorage();
      refreshUI();
      showToast('Success', 'Student record deleted.', 'success');
    }
  }

  function updateStudentDetails() {
    const oldStudentId = els.editDetailsOldId.value;
    const newStudentId = els.editDetailsId.value.trim();
    const newName = els.editDetailsName.value.trim();
    const newCourse = els.editDetailsCourse.value.trim();
    const newYear = els.editDetailsYear.value;
    const newGrade = els.editDetailsGrade.value;

    if (!/^\d{6}$/.test(newStudentId)) {
        showToast('Invalid ID', 'Student ID must be exactly 6 digits.', 'error');
        return;
    }

    const student = findStudentById(oldStudentId);
    if (!student) {
        showToast('Error', 'Original student record not found!', 'error');
        return;
    }

    if (oldStudentId !== newStudentId && findStudentById(newStudentId)) {
        showToast('Duplicate ID', `Student ID ${newStudentId} already exists!`, 'error');
        return;
    }

    student.setAttribute('id', newStudentId);
    setText(student, 'name', newName);
    setText(student, 'course', newCourse);
    setText(student, 'year', newYear);
    setText(student, 'grade', newGrade);

    saveXMLToLocalStorage();
    refreshUI();
    closeEditDetailsModal();
    showToast('Success', 'Student details updated successfully!', 'success');
  }

  // ---------- XML Helpers ----------
  function findStudentById(studentId) {
    return xmlDoc?.querySelector(`student[id="${studentId}"]`) || null;
  }

  function getText(parent, tag) {
    const el = parent.querySelector(tag);
    return el?.textContent?.trim() || '';
  }

  function setText(parent, tag, value) {
    const el = parent.querySelector(tag);
    if (el) el.textContent = value;
  }

  // ---------- XSLT ----------
  async function renderXSLT() {
    try {
        if (!xmlDoc) await loadXML(); // Ensure XML is loaded
        const xslRes = await fetch('students.xsl', { cache: 'no-store' });
        const xslText = await xslRes.text();
        
        const parser = new DOMParser();
        const xsl = parser.parseFromString(xslText, 'application/xml');
        
        const processor = new XSLTProcessor();
        processor.importStylesheet(xsl);
        
        // Use the current, in-memory xmlDoc that includes all changes
        const fragment = processor.transformToFragment(xmlDoc, document);
        
        els.xsltOutput.innerHTML = '';
        els.xsltOutput.appendChild(fragment);
    } catch (err) {
      console.error('XSLT transform error', err);
      els.xsltOutput.textContent = 'Failed to render XSLT view.';
    }
  }

  // ---------- Export Functions ----------
  function exportToCSV() {
    const sorted = sortStudents(applyFilters(getStudentElements()));
    if (sorted.length === 0) {
        showToast('Info', 'No students to export with current filters.', 'info');
        return;
    }
    const headers = ['ID', 'Name', 'Course', 'Year', 'Grade'];
    const csvRows = [headers.join(','), ...sorted.map(el => [
        el.getAttribute('id') || '',
        getText(el, 'name'),
        getText(el, 'course'),
        getText(el, 'year'),
        getText(el, 'grade')
    ].map(escapeCSV).join(','))];
    
    const blob = new Blob([csvRows.join('\n')], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = `students_${new Date().toISOString().split('T')[0]}.csv`;
    link.click();
    URL.revokeObjectURL(link.href);
    showToast('Success', `Exported ${sorted.length} students to CSV.`, 'success');
  }

  function exportToPDF() {
    if (applyFilters(getStudentElements()).length === 0) {
        showToast('Info', 'No students to print with current filters.', 'info');
        return;
    }
    const printAndRestore = () => {
        window.print();
    };
    if (state.currentPage !== 'students') {
        switchPage('students');
        setTimeout(printAndRestore, 500); // Wait for page to render
    } else {
        printAndRestore();
    }
  }

  function escapeCSV(value) {
    const str = String(value);
    return str.includes(',') || str.includes('"') || str.includes('\n') ? `"${str.replace(/"/g, '""')}"` : str;
  }
  
  // ---------- Student Profile Modal ----------
  function showStudentProfile(studentId) {
    const student = findStudentById(studentId);
    if (!student) return;

    const [id, name, course, year] = [student.getAttribute('id') || '', getText(student, 'name'), getText(student, 'course'), getText(student, 'year')];
    const grade = Number(getText(student, 'grade'));

    let gradeCategory, gradeCategoryColor, letterGrade;
    if (grade <= 1.25) { gradeCategory = 'Excellent'; gradeCategoryColor = 'var(--grade-excellent)'; letterGrade = 'A'; }
    else if (grade <= 1.75) { gradeCategory = 'Very Good'; gradeCategoryColor = 'var(--grade-good)'; letterGrade = 'B+'; }
    else if (grade <= 2.25) { gradeCategory = 'Good'; gradeCategoryColor = 'var(--grade-good)'; letterGrade = 'B'; }
    else if (grade <= 2.75) { gradeCategory = 'Fair'; gradeCategoryColor = 'var(--grade-average)'; letterGrade = 'C+'; }
    else if (grade <= 3.0) { gradeCategory = 'Passing'; gradeCategoryColor = 'var(--grade-average)'; letterGrade = 'C'; }
    else { gradeCategory = 'Failing'; gradeCategoryColor = 'var(--grade-poor)'; letterGrade = 'F'; }

    const isHonor = grade <= HONOR_THRESHOLD;
    const progressPercent = Math.max(0, ((5.0 - grade) / 4.0) * 100);

    els.profileModalBody.innerHTML = `
      <div style="text-align: center; margin-bottom: 24px;">
        <div style="width: 80px; height: 80px; margin: 0 auto 16px; border-radius: 50%; background: linear-gradient(135deg, var(--blue-300), var(--blue-100)); display: flex; align-items: center; justify-content: center; font-size: 32px; font-weight: 700; color: white;">
          ${escapeHtml(name.split(' ').map(n => n[0]).join(''))}
        </div>
        <h3 style="font-size: 24px; font-weight: 700; margin-bottom: 4px;">${escapeHtml(name)}</h3>
        <p style="color: var(--text-secondary); font-size: 14px;">ID: ${escapeHtml(id)}</p>
        ${isHonor ? '<span style="display: inline-block; background: linear-gradient(135deg, #fbbf24, #f59e0b); color: white; padding: 4px 12px; border-radius: 12px; font-size: 12px; font-weight: 700; margin-top: 8px;">⭐ Dean\'s List</span>' : ''}
      </div>
      <div class="profile-detail"><span>Course</span><span>${escapeHtml(course)}</span></div>
      <div class="profile-detail"><span>Year Level</span><span>${escapeHtml(year)}</span></div>
      <div class="profile-detail"><span>GPA / Letter</span><span style="color: ${gradeCategoryColor}; font-weight: 700;">${grade.toFixed(2)} / ${letterGrade}</span></div>
      <div class="profile-detail"><span>Performance</span><span style="color: ${gradeCategoryColor};">${gradeCategory}</span></div>
      <div style="margin-top: 16px;">
        <div class="progress-bar" style="height: 12px;"><div class="progress-fill" style="width: ${progressPercent}%; background-color: ${gradeCategoryColor};"></div></div>
      </div>
    `;
    els.profileModal.classList.add('active');
  }

  function closeModal() {
    els.profileModal?.classList.remove('active');
  }

  // ---------- Edit Student Details Modal ----------
  function showEditDetailsModal(studentId) {
    const student = findStudentById(studentId);
    if (!student) return;

    populateEditCourseDropdown();
    els.editDetailsOldId.value = studentId;
    els.editDetailsId.value = studentId;
    els.editDetailsName.value = getText(student, 'name');
    els.editDetailsCourse.value = getText(student, 'course');
    els.editDetailsYear.value = getText(student, 'year');
    els.editDetailsGrade.value = getText(student, 'grade');
    els.editDetailsModal.classList.add('active');
  }

  function populateEditCourseDropdown() {
    const courses = new Set(getStudentElements().map(el => getText(el, 'course')).filter(Boolean));
    const sortedCourses = Array.from(courses).sort();
    els.editDetailsCourse.innerHTML = '<option value="">Select Course</option>' + sortedCourses.map(c => `<option value="${escapeAttr(c)}">${escapeHtml(c)}</option>`).join('');
  }

  function closeEditDetailsModal() {
    els.editDetailsModal?.classList.remove('active');
    els.editDetailsForm?.reset();
  }

  // ---------- Utilities ----------
  function getNextStudentId() {
    const maxId = getStudentElements().reduce((max, el) => Math.max(max, parseInt(el.getAttribute('id') || '0', 10)), 0);
    return String(maxId + 1).padStart(6, '0');
  }
  
  // Corner toast notification
  function showToast(title, message, type = 'info') {
      const container = document.getElementById('toastContainer');
      if (!container) return;
      const toast = document.createElement('div');
      toast.className = `toast ${type}`;
      const icons = { success: '✓', error: '✖', info: 'ℹ️' };
      toast.innerHTML = `
        <div class="toast-icon" style="font-weight:bold;">${icons[type] || ''}</div>
        <div class="toast-content">
          <div class="toast-title">${escapeHtml(title)}</div>
          <div class="toast-message">${escapeHtml(message)}</div>
        </div>
        <button class="toast-close" onclick="this.parentElement.remove()">&times;</button>`;
      container.appendChild(toast);
      setTimeout(() => toast.remove(), 5000);
  }

  // ==== NEW: Centered Notification Popup Function ====
  function showCustomNotification(message) {
    if (!els.customNotification || !els.customNotificationMessage) return;

    // Set the message and show the notification
    els.customNotificationMessage.textContent = message;
    els.customNotification.classList.add('show');

    // Automatically hide the notification after 3 seconds
    setTimeout(() => {
      els.customNotification.classList.remove('show');
    }, 3000);
  }

  function escapeHtml(str) {
    return String(str).replace(/[&<>"']/g, m => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' })[m]);
  }
  function escapeAttr(str) {
    return escapeHtml(str);
  }
})();