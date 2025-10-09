'use strict';

(function () {
  // College GPA System (Philippine): 1.0 = Excellent, 5.0 = Failing
  // Honor threshold: 2.0 or better (Dean's List)
  const HONOR_THRESHOLD = 2.0;

  /** @type {XMLDocument|null} */
  let xmlDoc = null;

  /** UI state */
  const state = {
    searchQuery: '',
    honorOnly: false,
    courseFilter: 'ALL',
    yearFilter: 'ALL',
    sortBy: 'id',
    sortOrder: 'asc',
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
    
    // Search & Filters
    searchInput: document.getElementById('searchInput'),
    honorToggleBtn: document.getElementById('honorToggleBtn'),
    courseSelect: document.getElementById('courseSelect'),
    yearSelect: document.getElementById('yearSelect'),
    sortSelect: document.getElementById('sortSelect'),
    sortOrderBtn: document.getElementById('sortOrderBtn'),
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
    xsltOutput: document.getElementById('xsltOutput')
  };

  // ---------- Initialization ----------
  window.addEventListener('DOMContentLoaded', async () => {
    initTheme();
    initCurrentDate();
    wireHandlers();
    await loadXML();
  });

  function initTheme() {
    // Load saved theme or default to light
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
      // Save preference to localStorage
      const isCollapsed = els.sidebar.classList.contains('collapsed');
      localStorage.setItem('sidebarCollapsed', isCollapsed);
    });

    // Load sidebar preference
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
      // Auto-switch to students page when searching
      if (state.searchQuery && state.currentPage === 'dashboard') {
        switchPage('students');
      }
    });

    // Honor filter toggle
    els.honorToggleBtn.addEventListener('click', () => {
      state.honorOnly = !state.honorOnly;
      updateHonorButtonText();
      renderTable();
      // Switch to students page
      if (state.currentPage === 'dashboard') {
        switchPage('students');
      }
    });

    // Course filter
    els.courseSelect.addEventListener('change', () => {
      state.courseFilter = els.courseSelect.value;
      renderTable();
      // Switch to students page
      if (state.currentPage === 'dashboard') {
        switchPage('students');
      }
    });

    // Year filter
    els.yearSelect.addEventListener('change', () => {
      state.yearFilter = els.yearSelect.value;
      renderTable();
      // Switch to students page
      if (state.currentPage === 'dashboard') {
        switchPage('students');
      }
    });

    // Sort controls
    els.sortSelect.addEventListener('change', () => {
      state.sortBy = els.sortSelect.value;
      renderTable();
    });

    els.sortOrderBtn.addEventListener('click', () => {
      state.sortOrder = state.sortOrder === 'asc' ? 'desc' : 'asc';
      els.sortOrderBtn.classList.toggle('desc');
      renderTable();
    });

    // Reload XML
    els.reloadBtn.addEventListener('click', async () => {
      await loadXML(true);
    });

    // Export CSV
    if (els.exportBtn) {
      els.exportBtn.addEventListener('click', () => {
        exportToCSV();
      });
    }

    // Export PDF
    if (els.exportPdfBtn) {
      els.exportPdfBtn.addEventListener('click', () => {
        exportToPDF();
      });
    }

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
      // Show success feedback and switch to students page
      alert('Student added successfully!');
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
      alert('Grade updated successfully!');
      switchPage('students');
    });

    // Delete student, view profile, and edit details (delegated event)
    els.tableBody.addEventListener('click', (e) => {
      const target = /** @type {HTMLElement} */ (e.target);
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
    if (els.profileModalClose) {
      els.profileModalClose.addEventListener('click', () => {
        closeModal();
      });
    }

    if (els.profileModal) {
      els.profileModal.addEventListener('click', (e) => {
        if (e.target === els.profileModal) {
          closeModal();
        }
      });
    }

    // ESC key to close modals
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') {
        if (els.profileModal.classList.contains('active')) {
          closeModal();
        }
        if (els.editDetailsModal.classList.contains('active')) {
          closeEditDetailsModal();
        }
      }
    });

    // Edit Details Modal handlers
    if (els.editDetailsModalClose) {
      els.editDetailsModalClose.addEventListener('click', () => {
        closeEditDetailsModal();
      });
    }

    if (els.editDetailsCancelBtn) {
      els.editDetailsCancelBtn.addEventListener('click', () => {
        closeEditDetailsModal();
      });
    }

    if (els.editDetailsModal) {
      els.editDetailsModal.addEventListener('click', (e) => {
        if (e.target === els.editDetailsModal) {
          closeEditDetailsModal();
        }
      });
    }

    // Edit Details Form submit
    if (els.editDetailsForm) {
      els.editDetailsForm.addEventListener('submit', (e) => {
        e.preventDefault();
        updateStudentDetails();
      });
    }
  }

  function updateHonorButtonText() {
    const icon = `<svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
      <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
    </svg>`;
    const text = state.honorOnly ? 'Show All Students' : 'Show Dean\'s List (GPA ≤2.0)';
    els.honorToggleBtn.innerHTML = icon + text;
  }

  // ---------- Page Navigation ----------
  function switchPage(pageName) {
    state.currentPage = pageName;
    
    // Update nav items
    els.navItems.forEach((navItem) => {
      if (navItem.getAttribute('data-page') === pageName) {
        navItem.classList.add('active');
      } else {
        navItem.classList.remove('active');
      }
    });
    
    // Update pages
    els.pages.forEach((page) => {
      if (page.id === `${pageName}Page`) {
        page.classList.add('active');
      } else {
        page.classList.remove('active');
      }
    });

    // Special handling for XSLT page
    if (pageName === 'xslt') {
      renderXSLT();
    }
  }

  // ---------- XML Loading ----------
  async function loadXML(noCache = false) {
    try {
      const res = await fetch('students.xml', { cache: noCache ? 'reload' : 'no-store' });
      if (!res.ok) throw new Error('Failed to load students.xml');
      const xmlText = await res.text();
      const parser = new DOMParser();
      const parsed = parser.parseFromString(xmlText, 'application/xml');
      // Handle parser errors
      const parserError = parsed.getElementsByTagName('parsererror')[0];
      if (parserError) {
        console.error('XML Parser Error:', parserError.textContent);
        throw new Error('Invalid XML format');
      }
      xmlDoc = parsed;
      refreshUI();
    } catch (err) {
      console.error(err);
      alert('Error loading XML. Ensure the site is served via http://localhost/minisis/');
    }
  }

  // ---------- Rendering ----------
  function refreshUI() {
    renderDashboardStats();
    renderCourseDropdown();
    renderYearDropdown();
    renderEditStudentDropdown();
    renderTable();
  }

  function renderDashboardStats() {
    const students = getStudentElements();
    const honorCount = students.filter((el) => {
      const grade = Number(getText(el, 'grade'));
      return grade >= HONOR_THRESHOLD;
    }).length;
    
    const courses = new Set();
    students.forEach((el) => courses.add(getText(el, 'course')));
    
    els.totalStudents.textContent = students.length;
    els.honorStudents.textContent = honorCount;
    els.totalCourses.textContent = courses.size;
  }

  function getStudentElements() {
    if (!xmlDoc) return [];
    return Array.from(xmlDoc.getElementsByTagName('student'));
  }

  function applyFilters(students) {
    const query = state.searchQuery;
    const honor = state.honorOnly;
    const courseFilter = state.courseFilter;
    const yearFilter = state.yearFilter;
    return students.filter((el) => {
      const name = getText(el, 'name').toLowerCase();
      const course = getText(el, 'course');
      const year = getText(el, 'year');
      const grade = Number(getText(el, 'grade'));
      if (query && !name.includes(query)) return false;
      // In college GPA: lower is better, so honor is <= threshold
      if (honor && !(grade <= HONOR_THRESHOLD)) return false;
      if (courseFilter !== 'ALL' && course !== courseFilter) return false;
      if (yearFilter !== 'ALL' && year !== yearFilter) return false;
      return true;
    });
  }

  function sortStudents(students) {
    const sortBy = state.sortBy;
    const order = state.sortOrder === 'asc' ? 1 : -1;
    
    return students.sort((a, b) => {
      let aVal, bVal;
      
      if (sortBy === 'id') {
        aVal = Number(a.getAttribute('id') || '0');
        bVal = Number(b.getAttribute('id') || '0');
      } else if (sortBy === 'name') {
        aVal = getText(a, 'name').toLowerCase();
        bVal = getText(b, 'name').toLowerCase();
      } else if (sortBy === 'year') {
        aVal = Number(getText(a, 'year') || '0');
        bVal = Number(getText(b, 'year') || '0');
      } else if (sortBy === 'grade') {
        // In college GPA: lower is better (1.0 > 5.0)
        // So we reverse the comparison
        aVal = Number(getText(a, 'grade') || '5.0');
        bVal = Number(getText(b, 'grade') || '5.0');
        // Reverse comparison for GPA (ascending = best first)
        if (aVal < bVal) return -1 * order;
        if (aVal > bVal) return 1 * order;
        return 0;
      } else if (sortBy === 'honor') {
        // Sort by honor status (honor students first), then by grade
        const aGrade = Number(getText(a, 'grade') || '5.0');
        const bGrade = Number(getText(b, 'grade') || '5.0');
        const aIsHonor = aGrade <= HONOR_THRESHOLD ? 1 : 0;
        const bIsHonor = bGrade <= HONOR_THRESHOLD ? 1 : 0;
        
        // Primary sort: honor status
        if (aIsHonor !== bIsHonor) {
          return (bIsHonor - aIsHonor) * order;
        }
        // Secondary sort: GPA (lower is better, ascending)
        return (aGrade - bGrade);
      }
      
      if (aVal < bVal) return -1 * order;
      if (aVal > bVal) return 1 * order;
      return 0;
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
      // In college GPA: lower is better, honor is <= threshold
      const isHonor = grade <= HONOR_THRESHOLD;
      
      // Honor badge HTML (Dean's List for GPA <= 2.0)
      const honorBadge = isHonor 
        ? '<span style="display:inline-block;margin-left:8px;background:linear-gradient(135deg,#fbbf24,#f59e0b);color:white;padding:2px 8px;border-radius:10px;font-size:11px;font-weight:700;">⭐ Dean\'s List</span>' 
        : '';
      
      return (
        '<tr>' +
        `<td><input type="checkbox" class="select-checkbox" data-id="${escapeAttr(id)}"></td>` +
        `<td>${escapeHtml(id)}</td>` +
        `<td><span class="student-name-link" data-action="view" data-id="${escapeAttr(id)}" style="cursor:pointer;color:var(--blue-300);font-weight:500;text-decoration:underline;">${escapeHtml(name)}</span></td>` +
        `<td>${escapeHtml(course)}</td>` +
        `<td>${escapeHtml(year)}${yearSuffix} Year</td>` +
        `<td>${grade.toFixed(2)}${honorBadge}</td>` +
        `<td style="display:flex;gap:8px;">` +
        `<button class="btn-primary" data-action="edit" data-id="${escapeAttr(id)}" style="padding:8px 12px;font-size:13px;">Edit Details</button>` +
        `<button class="danger" data-action="delete" data-id="${escapeAttr(id)}">Delete</button>` +
        `</td>` +
        '</tr>'
      );
    });
    els.tableBody.innerHTML = rows.length > 0 ? rows.join('') : '<tr><td colspan="7" style="text-align:center;color:#9ca3af;padding:32px;">No students found</td></tr>';
  }

  function renderCourseDropdown() {
    const students = getStudentElements();
    const courses = new Set(['ALL']);
    students.forEach((el) => courses.add(getText(el, 'course')));
    const options = Array.from(courses).map((course) => {
      const label = course === 'ALL' ? 'All Courses' : course;
      const selected = state.courseFilter === course ? ' selected' : '';
      return `<option value="${escapeAttr(course)}"${selected}>${escapeHtml(label)}</option>`;
    });
    els.courseSelect.innerHTML = options.join('');
  }

  function renderYearDropdown() {
    const students = getStudentElements();
    const years = new Set(['ALL']);
    students.forEach((el) => years.add(getText(el, 'year')));
    const sortedYears = Array.from(years).filter(y => y !== 'ALL').sort();
    sortedYears.unshift('ALL');
    const options = sortedYears.map((year) => {
      const label = year === 'ALL' ? 'All Years' : `Year ${year}`;
      const selected = state.yearFilter === year ? ' selected' : '';
      return `<option value="${escapeAttr(year)}"${selected}>${escapeHtml(label)}</option>`;
    });
    els.yearSelect.innerHTML = options.join('');
  }

  function renderEditStudentDropdown() {
    const students = getStudentElements();
    const options = students.map((el) => {
      const id = el.getAttribute('id') || '';
      const name = getText(el, 'name');
      return `<option value="${escapeAttr(id)}">${escapeHtml(name)} (ID: ${escapeHtml(id)})</option>`;
    });
    els.editStudentSelect.innerHTML = options.join('');
  }

  // ---------- Modify XML (in-memory) ----------
  function addStudent(name, course, year, grade) {
    if (!xmlDoc) return;
    const studentsRoot = xmlDoc.getElementsByTagName('students')[0];
    const newId = getNextStudentId(); // Use 6-digit format
    const studentEl = xmlDoc.createElement('student');
    studentEl.setAttribute('id', newId);

    const nameEl = xmlDoc.createElement('name');
    nameEl.textContent = name;
    const courseEl = xmlDoc.createElement('course');
    courseEl.textContent = course;
    const yearEl = xmlDoc.createElement('year');
    yearEl.textContent = String(Math.max(1, Math.min(4, Number(year))));
    const gradeEl = xmlDoc.createElement('grade');
    gradeEl.textContent = String(Math.max(0, Math.min(100, Number(grade))));

    studentEl.appendChild(nameEl);
    studentEl.appendChild(courseEl);
    studentEl.appendChild(yearEl);
    studentEl.appendChild(gradeEl);
    studentsRoot.appendChild(studentEl);
    refreshUI();
  }

  function updateStudentGrade(studentId, grade) {
    if (!xmlDoc) return;
    const student = findStudentById(studentId);
    if (!student) return;
    const gradeEl = student.getElementsByTagName('grade')[0];
    if (gradeEl) {
      gradeEl.textContent = String(Math.max(0, Math.min(100, Number(grade))));
    }
    refreshUI();
  }

  function deleteStudent(studentId) {
    if (!xmlDoc) return;
    const student = findStudentById(studentId);
    if (!student || !student.parentNode) return;
    student.parentNode.removeChild(student);
    refreshUI();
  }

  function findStudentById(studentId) {
    const students = getStudentElements();
    return students.find((el) => el.getAttribute('id') === String(studentId)) || null;
  }

  function getNextId() {
    const students = getStudentElements();
    let maxId = 0;
    students.forEach((el) => {
      const id = Number(el.getAttribute('id') || '0');
      if (!Number.isNaN(id)) maxId = Math.max(maxId, id);
    });
    return maxId + 1;
  }

  function getText(parent, tag) {
    const el = parent.getElementsByTagName(tag)[0];
    return el ? (el.textContent || '').trim() : '';
  }

  function setText(parent, tag, value) {
    const el = parent.getElementsByTagName(tag)[0];
    if (el) {
      el.textContent = value;
    }
  }

  // ---------- XSLT (optional bonus) ----------
  async function renderXSLT() {
    try {
      const [xmlRes, xslRes] = await Promise.all([
        fetch('students.xml', { cache: 'no-store' }),
        fetch('students.xsl', { cache: 'no-store' })
      ]);
      const [xmlText, xslText] = await Promise.all([xmlRes.text(), xslRes.text()]);
      const parser = new DOMParser();
      const xml = parser.parseFromString(xmlText, 'application/xml');
      const xsl = parser.parseFromString(xslText, 'application/xml');
      const processor = new XSLTProcessor();
      processor.importStylesheet(xsl);
      const fragment = processor.transformToFragment(xml, document);
      els.xsltOutput.innerHTML = '';
      els.xsltOutput.appendChild(fragment);
    } catch (err) {
      console.error('XSLT transform error', err);
      els.xsltOutput.textContent = 'Failed to render XSLT view.';
    }
  }

  // ---------- Export Functions ----------
  function exportToCSV() {
    const students = getStudentElements();
    const filtered = applyFilters(students);
    const sorted = sortStudents(filtered);

    if (sorted.length === 0) {
      alert('No students to export!');
      return;
    }

    // CSV Header
    const headers = ['ID', 'Name', 'Course', 'Year', 'Grade'];
    const csvRows = [headers.join(',')];

    // CSV Data
    sorted.forEach((el) => {
      const id = el.getAttribute('id') || '';
      const name = getText(el, 'name');
      const course = getText(el, 'course');
      const year = getText(el, 'year');
      const grade = getText(el, 'grade');

      // Escape CSV values (handle commas and quotes)
      const row = [
        escapeCSV(id),
        escapeCSV(name),
        escapeCSV(course),
        escapeCSV(year),
        escapeCSV(grade)
      ];
      csvRows.push(row.join(','));
    });

    // Create CSV content
    const csvContent = csvRows.join('\n');

    // Create download
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);
    
    // Generate filename with date
    const date = new Date().toISOString().split('T')[0];
    const filename = `students_${date}.csv`;
    
    link.setAttribute('href', url);
    link.setAttribute('download', filename);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);

    // Show success message
    showNotification('Export successful!', `Downloaded ${sorted.length} students to ${filename}`);
  }

  function exportToPDF() {
    // Simple print-based PDF export
    // The CSS has @media print styles defined
    const students = getStudentElements();
    const filtered = applyFilters(students);
    
    if (filtered.length === 0) {
      alert('No students to export!');
      return;
    }

    // Switch to students page and trigger print
    if (state.currentPage !== 'students') {
      switchPage('students');
      setTimeout(() => {
        window.print();
      }, 500);
    } else {
      window.print();
    }
  }

  function escapeCSV(value) {
    // Convert to string
    const str = String(value);
    
    // If contains comma, quote, or newline, wrap in quotes and escape quotes
    if (str.includes(',') || str.includes('"') || str.includes('\n')) {
      return '"' + str.replace(/"/g, '""') + '"';
    }
    
    return str;
  }

  function showNotification(title, message) {
    // Simple alert for now (can be enhanced with toast notifications)
    alert(title + '\n' + message);
  }

  // ---------- Student Profile Modal ----------
  function showStudentProfile(studentId) {
    const student = findStudentById(studentId);
    if (!student) {
      alert('Student not found!');
      return;
    }

    const id = student.getAttribute('id') || '';
    const name = getText(student, 'name');
    const course = getText(student, 'course');
    const year = getText(student, 'year');
    const grade = Number(getText(student, 'grade'));

    // Determine grade category for college GPA (1.0-5.0 scale)
    let gradeCategory = '';
    let gradeCategoryColor = '';
    let letterGrade = '';
    if (grade <= 1.25) {
      gradeCategory = 'Excellent';
      gradeCategoryColor = 'var(--grade-excellent)';
      letterGrade = 'A';
    } else if (grade <= 1.75) {
      gradeCategory = 'Very Good';
      gradeCategoryColor = 'var(--grade-good)';
      letterGrade = 'B+';
    } else if (grade <= 2.25) {
      gradeCategory = 'Good';
      gradeCategoryColor = 'var(--grade-good)';
      letterGrade = 'B';
    } else if (grade <= 2.75) {
      gradeCategory = 'Fair';
      gradeCategoryColor = 'var(--grade-average)';
      letterGrade = 'C+';
    } else if (grade <= 3.0) {
      gradeCategory = 'Passing';
      gradeCategoryColor = 'var(--grade-average)';
      letterGrade = 'C';
    } else {
      gradeCategory = 'Failing';
      gradeCategoryColor = 'var(--grade-poor)';
      letterGrade = 'F';
    }

    // In college GPA: lower is better, dean's list is <= 2.0
    const isHonor = grade <= HONOR_THRESHOLD;
    const yearSuffix = year === '1' ? 'st' : year === '2' ? 'nd' : year === '3' ? 'rd' : 'th';

    // Progress bar: invert for GPA (5.0 - grade) / 4.0 * 100 to show better performance
    const progressPercent = Math.max(0, Math.min(100, ((5.0 - grade) / 4.0) * 100));

    // Build modal content
    const modalContent = `
      <div style="text-align: center; margin-bottom: 24px;">
        <div style="width: 80px; height: 80px; margin: 0 auto 16px; border-radius: 50%; background: linear-gradient(135deg, var(--blue-300), var(--blue-100)); display: flex; align-items: center; justify-content: center; font-size: 32px; font-weight: 700; color: white;">
          ${escapeHtml(name.split(' ').map(n => n[0]).join(''))}
        </div>
        <h3 style="font-size: 24px; font-weight: 700; color: var(--text-primary); margin-bottom: 4px;">${escapeHtml(name)}</h3>
        <p style="color: var(--text-secondary); font-size: 14px;">Student ID: ${escapeHtml(id)}</p>
        ${isHonor ? '<span style="display: inline-block; background: linear-gradient(135deg, #fbbf24, #f59e0b); color: white; padding: 4px 12px; border-radius: 12px; font-size: 12px; font-weight: 700; margin-top: 8px;">⭐ Dean\'s List</span>' : ''}
      </div>

      <div style="background: var(--input-bg); border-radius: 12px; padding: 20px; margin-bottom: 20px;">
        <div class="profile-detail">
          <span>Course</span>
          <span>${escapeHtml(course)}</span>
        </div>
        <div class="profile-detail">
          <span>Year Level</span>
          <span>${escapeHtml(year)}${yearSuffix} Year</span>
        </div>
        <div class="profile-detail">
          <span>GPA</span>
          <span style="color: ${gradeCategoryColor}; font-weight: 700; font-size: 18px;">${grade.toFixed(2)}</span>
        </div>
        <div class="profile-detail">
          <span>Letter Grade</span>
          <span style="color: ${gradeCategoryColor}; font-weight: 700; font-size: 18px;">${letterGrade}</span>
        </div>
        <div class="profile-detail">
          <span>Performance</span>
          <span style="color: ${gradeCategoryColor}; font-weight: 600;">${gradeCategory}</span>
        </div>
      </div>

      <div style="margin-bottom: 16px;">
        <div style="margin-bottom: 8px; color: var(--text-secondary); font-size: 13px; font-weight: 600;">Performance Level</div>
        <div class="progress-bar" style="height: 12px;">
          <div class="progress-fill ${gradeCategory.toLowerCase().replace(' ', '-')}" style="width: ${progressPercent.toFixed(0)}%;"></div>
        </div>
        <div style="margin-top: 4px; font-size: 12px; color: var(--text-secondary);">Lower GPA is better • 1.0 = Perfect • 5.0 = Failing</div>
      </div>

      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-top: 20px;">
        <button onclick="document.querySelector('#profileModal').classList.remove('active'); document.querySelector('#editPage').scrollIntoView();" class="btn-primary" style="padding: 12px; font-size: 14px;">Edit Grade</button>
        <button onclick="if(confirm('Delete ${escapeHtml(name)}?')) { document.querySelector('#profileModal').classList.remove('active'); }" class="danger" style="width: 100%; padding: 12px; font-size: 14px;">Delete Student</button>
      </div>
    `;

    els.profileModalBody.innerHTML = modalContent;
    els.profileModal.classList.add('active');
  }

  function closeModal() {
    if (els.profileModal) {
      els.profileModal.classList.remove('active');
    }
  }

  // ---------- Edit Student Details Modal ----------
  function showEditDetailsModal(studentId) {
    const student = findStudentById(studentId);
    if (!student) {
      alert('Student not found!');
      return;
    }

    const name = getText(student, 'name');
    const course = getText(student, 'course');
    const year = getText(student, 'year');
    const grade = getText(student, 'grade');

    // Populate course dropdown with all available courses
    populateEditCourseDropdown();

    // Populate form (store old ID and show current ID)
    els.editDetailsOldId.value = studentId;
    els.editDetailsId.value = studentId;
    els.editDetailsName.value = name;
    els.editDetailsCourse.value = course;
    els.editDetailsYear.value = year;
    els.editDetailsGrade.value = grade;

    // Show modal
    els.editDetailsModal.classList.add('active');
  }

  function populateEditCourseDropdown() {
    // Get all unique courses from students
    const students = getStudentElements();
    const courses = new Set();
    students.forEach((el) => {
      const course = getText(el, 'course');
      if (course) {
        courses.add(course);
      }
    });

    // Sort courses alphabetically
    const sortedCourses = Array.from(courses).sort();

    // Build dropdown options
    const options = ['<option value="">Select Course</option>'];
    sortedCourses.forEach((course) => {
      options.push(`<option value="${escapeAttr(course)}">${escapeHtml(course)}</option>`);
    });

    // Update dropdown
    els.editDetailsCourse.innerHTML = options.join('');
  }

  function closeEditDetailsModal() {
    if (els.editDetailsModal) {
      els.editDetailsModal.classList.remove('active');
      els.editDetailsForm.reset();
    }
  }

  function updateStudentDetails() {
    const oldStudentId = els.editDetailsOldId.value;
    let newStudentId = els.editDetailsId.value.trim();
    const newName = els.editDetailsName.value.trim();
    const newCourse = els.editDetailsCourse.value.trim();
    const newYear = els.editDetailsYear.value;
    const newGrade = els.editDetailsGrade.value;

    if (!oldStudentId || !newStudentId || !newName || !newCourse || !newYear || !newGrade) {
      alert('All fields are required!');
      return;
    }

    // Validate 6-digit ID format
    if (!/^\d{6}$/.test(newStudentId)) {
      alert('Student ID must be exactly 6 digits (e.g., 000001, 000002)');
      return;
    }

    const student = findStudentById(oldStudentId);
    if (!student) {
      alert('Student not found!');
      return;
    }

    // Check if new ID already exists (only if ID changed)
    if (oldStudentId !== newStudentId) {
      const existingStudent = findStudentById(newStudentId);
      if (existingStudent) {
        alert(`Student ID ${newStudentId} already exists! Please choose a different ID.`);
        return;
      }
      
      // Update the ID attribute
      student.setAttribute('id', newStudentId);
    }

    // Update all other fields
    setText(student, 'name', newName);
    setText(student, 'course', newCourse);
    setText(student, 'year', newYear);
    setText(student, 'grade', newGrade);

    // Refresh UI
    renderTable();
    renderCourseDropdown();
    renderYearDropdown();
    renderEditStudentDropdown();
    renderDashboardStats();

    // Close modal
    closeEditDetailsModal();

    alert(`Student details updated successfully!\n\nID: ${newStudentId}\nName: ${newName}\nCourse: ${newCourse}\nYear: ${newYear}\nGPA: ${newGrade}`);
  }

  // ---------- Utilities ----------
  function formatStudentId(id) {
    // Convert to string and pad with leading zeros to 6 digits
    return String(id).padStart(6, '0');
  }

  function getNextStudentId() {
    // Find the highest existing ID and increment
    const students = getStudentElements();
    let maxId = 0;
    students.forEach((student) => {
      const id = parseInt(student.getAttribute('id') || '0', 10);
      if (id > maxId) {
        maxId = id;
      }
    });
    return formatStudentId(maxId + 1);
  }

  function escapeHtml(str) {
    return String(str)
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#039;');
  }

  function escapeAttr(str) {
    return escapeHtml(str).replaceAll('"', '&quot;');
  }
})();
