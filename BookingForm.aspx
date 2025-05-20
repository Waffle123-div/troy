<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BookingForm.aspx.cs" Inherits="Booking_system.BookingForm" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Event Booking System - Book an Event</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script type="text/javascript">
        function validateForm() {
            var isValid = true;
            var errorMsg = "";
            
            // Required fields validation
            if (document.getElementById('<%= txtEventName.ClientID %>').value.trim() === "") {
                errorMsg += "• Event Name is required\n";
                isValid = false;
            }
            
            if (document.getElementById('<%= txtLocation.ClientID %>').value.trim() === "") {
                errorMsg += "• Location is required\n";
                isValid = false;
            }
            
            if (document.getElementById('<%= txtEventDate.ClientID %>').value.trim() === "") {
                errorMsg += "• Event Date is required\n";
                isValid = false;
            }
            
            if (document.getElementById('<%= txtStartTime.ClientID %>').value.trim() === "") {
                errorMsg += "• Start Time is required\n";
                isValid = false;
            }
            
            if (document.getElementById('<%= txtEndTime.ClientID %>').value.trim() === "") {
                errorMsg += "• End Time is required\n";
                isValid = false;
            }
            
            // Date validation
            var eventDate = new Date(document.getElementById('<%= txtEventDate.ClientID %>').value);
            var today = new Date();
            today.setHours(0, 0, 0, 0);
            
            if (eventDate < today) {
                errorMsg += "• Event Date cannot be in the past\n";
                isValid = false;
            }
            
            // Time validation
            if (document.getElementById('<%= txtStartTime.ClientID %>').value >= 
                document.getElementById('<%= txtEndTime.ClientID %>').value) {
                errorMsg += "• End Time must be after Start Time\n";
                isValid = false;
            }
            
            // Attendees validation
            var attendees = parseInt(document.getElementById('<%= txtAttendees.ClientID %>').value);
            if (isNaN(attendees) || attendees < 1) {
                errorMsg += "• Number of Attendees must be a positive number\n";
                isValid = false;
            }
            
            // Terms validation
            if (!document.getElementById('<%= chkTerms.ClientID %>').checked) {
                errorMsg += "• You must agree to the terms and conditions\n";
                isValid = false;
            }
            
            // Display errors if any
            if (!isValid) {
                var errorElement = document.getElementById('validationErrors');
                errorElement.textContent = errorMsg;
                errorElement.style.display = 'block';
                return false;
            }
            
            return true;
        }
        
        function updatePrice() {
            var attendees = parseInt(document.getElementById('<%= txtAttendees.ClientID %>').value) || 0;
            var category = document.getElementById('<%= ddlEventCategory.ClientID %>').value;
            var startTime = document.getElementById('<%= txtStartTime.ClientID %>').value;
            var endTime = document.getElementById('<%= txtEndTime.ClientID %>').value;
            
            var hours = 0;
            if (startTime && endTime) {
                var start = new Date('2000-01-01T' + startTime + ':00');
                var end = new Date('2000-01-01T' + endTime + ':00');
                hours = (end - start) / (1000 * 60 * 60);
            }
            
            var baseRate = 0;
            switch(category) {
                case "Conference": baseRate = 150; break;
                case "Meeting": baseRate = 100; break;
                case "Workshop": baseRate = 120; break;
                case "Social": baseRate = 200; break;
                case "Other": baseRate = 80; break;
                default: baseRate = 100;
            }
            
            var estimatedPrice = baseRate * hours + (attendees * 5);
            
            if (!isNaN(estimatedPrice) && estimatedPrice > 0) {
                document.getElementById('estimatedPrice').textContent = estimatedPrice.toFixed(2);
                document.getElementById('priceEstimate').style.display = 'block';
            } else {
                document.getElementById('priceEstimate').style.display = 'none';
            }
        }
        
        // Mini-calendar functionality
        document.addEventListener('DOMContentLoaded', function() {
            initializeCalendar();
        });
        
        function initializeCalendar() {
            const calendarEl = document.getElementById('miniCalendar');
            const dateInput = document.getElementById('<%= txtEventDate.ClientID %>');
            const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
            
            let date = new Date();
            if (dateInput.value) {
                date = new Date(dateInput.value);
            }
            
            renderCalendar(date);
            
            // Event listeners for navigation
            document.getElementById('prevMonth').addEventListener('click', function() {
                date.setMonth(date.getMonth() - 1);
                renderCalendar(date);
            });
            
            document.getElementById('nextMonth').addEventListener('click', function() {
                date.setMonth(date.getMonth() + 1);
                renderCalendar(date);
            });
            
            function renderCalendar(date) {
                const year = date.getFullYear();
                const month = date.getMonth();
                
                // Update month and year display
                document.getElementById('calendarMonthYear').textContent = months[month] + ' ' + year;
                
                // Clear existing calendar
                const calendarBody = document.getElementById('calendarBody');
                calendarBody.innerHTML = '';
                
                // Get first day of month and last day
                const firstDay = new Date(year, month, 1).getDay();
                const lastDay = new Date(year, month + 1, 0).getDate();
                
                // Create calendar rows
                let date1 = 1;
                for (let i = 0; i < 6; i++) {
                    // Break if we've gone past the last day
                    if (date1 > lastDay) break;
                    
                    const row = document.createElement('tr');
                    
                    // Create days in the row
                    for (let j = 0; j < 7; j++) {
                        const cell = document.createElement('td');
                        
                        if (i === 0 && j < firstDay) {
                            // Empty cells before the first day
                            cell.innerHTML = '';
                        } else if (date1 > lastDay) {
                            // Empty cells after the last day
                            cell.innerHTML = '';
                        } else {
                            // Regular day cells
                            cell.textContent = date1;
                            
                            // Add today class
                            const today = new Date();
                            if (date1 === today.getDate() && month === today.getMonth() && year === today.getFullYear()) {
                                cell.classList.add('today');
                            }
                            
                            // Add selected class if this is the selected date
                            const selectedDate = new Date(dateInput.value);
                            if (date1 === selectedDate.getDate() && month === selectedDate.getMonth() && year === selectedDate.getFullYear()) {
                                cell.classList.add('selected');
                            }
                            
                            // Past days are disabled
                            if (new Date(year, month, date1) < new Date(new Date().setHours(0,0,0,0))) {
                                cell.classList.add('disabled');
                            } else {
                                // Add click event for future dates
                                cell.addEventListener('click', function() {
                                    // Format the date as yyyy-MM-dd
                                    const selectedDate = new Date(year, month, date1);
                                    const formattedDate = selectedDate.toISOString().split('T')[0];
                                    dateInput.value = formattedDate;
                                    
                                    // Update selected class
                                    document.querySelectorAll('#calendarBody td.selected').forEach(el => {
                                        el.classList.remove('selected');
                                    });
                                    this.classList.add('selected');
                                    
                                    // Update price estimate
                                    updatePrice();
                                });
                                
                                cell.classList.add('selectable');
                            }
                            
                            date1++;
                        }
                        
                        row.appendChild(cell);
                    }
                    
                    calendarBody.appendChild(row);
                }
            }
        }
    </script>
    <style type="text/css">
        /* Reset default styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        /* Body styling */
        body {
            font-family: 'Segoe UI', 'Helvetica Neue', Arial, sans-serif;
            background: linear-gradient(135deg, #4158D0, #C850C0);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            color: #333;
            line-height: 1.6;
        }

        .form-container {
            max-width: 850px;
            width: 95%;
            margin: 30px auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 16px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.25);
            padding: 40px;
            position: relative;
            backdrop-filter: blur(5px);
            overflow: hidden;
        }
        
        .form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 8px;
            background: linear-gradient(90deg, #FF3CAC, #784BA0, #2B86C5);
        }

        h2 {
            font-size: 2.2rem;
            font-weight: 700;
            color: #3d4465;
            text-align: center;
            margin-bottom: 30px;
            position: relative;
            padding-bottom: 12px;
        }
        
        h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(90deg, #784BA0, #2B86C5);
            border-radius: 2px;
        }

        .progress-container {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
            position: relative;
        }
        
        .progress-container::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            width: 100%;
            height: 3px;
            background-color: #e2e8f0;
            transform: translateY(-50%);
            z-index: 1;
        }
        
        .progress-step {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            color: #718096;
            position: relative;
            z-index: 2;
        }
        
        .progress-step.active {
            background: linear-gradient(135deg, #4158D0, #C850C0);
            color: white;
        }
        
        .progress-step.completed {
            background: linear-gradient(135deg, #10B981, #3B82F6);
            color: white;
        }
        
        .progress-step-label {
            position: absolute;
            bottom: -25px;
            font-size: 0.85rem;
            font-weight: 500;
            white-space: nowrap;
            transform: translateX(-50%);
            left: 50%;
        }

        .form-group {
            margin-bottom: 25px;
            position: relative;
        }
        
        .form-label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: #4a5568;
            font-size: 1.05rem;
            transition: all 0.3s ease;
        }
        
        .form-control {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            box-sizing: border-box;
            transition: all 0.3s ease;
            font-size: 1.05rem;
            color: #2d3748;
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .form-control:focus {
            border-color: #4158D0;
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.2);
            outline: none;
        }
        
        .form-control:hover:not(:focus) {
            border-color: #cbd5e0;
        }
        
        /* Special styling for date & time inputs */
        input[type="date"].form-control,
        input[type="time"].form-control {
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            padding-right: 30px;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="%23718096" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 9l6 6 6-6"/></svg>');
            background-repeat: no-repeat;
            background-position: right 8px center;
            background-size: 16px;
        }
        
        input[type="number"].form-control {
            appearance: textfield;
            -moz-appearance: textfield;
            -webkit-appearance: textfield;
        }
        
        input[type="number"].form-control::-webkit-outer-spin-button,
        input[type="number"].form-control::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        textarea.form-control {
            min-height: 100px;
            resize: vertical;
        }
        
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 25px;
        }
        
        .form-col {
            flex: 1;
        }
        
        .checkbox-container {
            display: flex;
            align-items: center;
            margin-top: 15px;
        }
        
        .checkbox-container input[type="checkbox"] {
            width: 20px;
            height: 20px;
            margin-right: 10px;
        }
        
        .checkbox-container label {
            font-size: 1rem;
            color: #4a5568;
        }
        
        .terms-link {
            color: #4158D0;
            text-decoration: none;
            font-weight: 600;
        }
        
        .terms-link:hover {
            text-decoration: underline;
        }

        .validation-errors {
            background-color: rgba(254, 226, 226, 0.8);
            color: #b91c1c;
            border: 1px solid #f87171;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 25px;
            font-size: 0.95rem;
            display: none;
            white-space: pre-line;
        }
        
        .price-estimate {
            background-color: rgba(219, 234, 254, 0.8);
            border: 1px solid #93c5fd;
            border-radius: 8px;
            padding: 15px;
            margin-top: 25px;
            margin-bottom: 25px;
            text-align: center;
            display: none;
        }
        
        .price-value {
            font-size: 1.25rem;
            font-weight: 700;
            color: #1e40af;
        }

        .button-container {
            margin-top: 35px;
            display: flex;
            flex-direction: row;
            justify-content: space-between;
            gap: 20px;
        }

        .btn {
            padding: 14px 24px;
            font-size: 1.05rem;
            font-weight: 600;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            flex: 1;
            display: block;
            text-decoration: none;
            position: relative;
            overflow: hidden;
            z-index: 1;
        }
        
        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 0;
            height: 100%;
            background: rgba(255, 255, 255, 0.2);
            transition: all 0.4s;
            z-index: -1;
        }
        
        .btn:hover::before {
            width: 100%;
        }

        .btn-primary {
            background: linear-gradient(45deg, #4158D0, #C850C0);
            color: white;
            box-shadow: 0 4px 15px rgba(79, 70, 229, 0.3);
        }
        
        .btn-primary:hover {
            box-shadow: 0 6px 22px rgba(79, 70, 229, 0.4);
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: linear-gradient(45deg, #334155, #475569);
            color: white;
            box-shadow: 0 4px 12px rgba(51, 65, 85, 0.3);
        }
        
        .btn-secondary:hover {
            box-shadow: 0 6px 18px rgba(51, 65, 85, 0.4);
            transform: translateY(-2px);
        }
        
        .calendar-view {
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 15px;
            background-color: white;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }
        
        .file-upload {
            position: relative;
            display: inline-block;
            width: 100%;
        }
        
        .file-upload-label {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 12px 16px;
            background-color: #f8fafc;
            border: 2px dashed #cbd5e0;
            border-radius: 8px;
            cursor: pointer;
            text-align: center;
            font-size: 1rem;
            color: #64748b;
            transition: all 0.3s ease;
        }
        
        .file-upload-label:hover {
            border-color: #4158D0;
            color: #4158D0;
        }
        
        .file-upload input[type="file"] {
            position: absolute;
            left: 0;
            top: 0;
            opacity: 0;
            width: 100%;
            height: 100%;
            cursor: pointer;
        }
        
        .file-name {
            margin-top: 8px;
            font-size: 0.9rem;
            color: #475569;
        }

        .message {
            margin-top: 25px;
            padding: 14px;
            border-radius: 8px;
            font-weight: 500;
            font-size: 1.05rem;
            text-align: center;
            opacity: 0;
            transition: opacity 0.3s ease;
            max-width: 90%;
            margin-left: auto;
            margin-right: auto;
        }
        
        .message:not(:empty) {
            opacity: 1;
        }

        .error-message {
            background-color: rgba(254, 226, 226, 0.8);
            color: #b91c1c;
            border: 1px solid #f87171;
        }

        .success-message {
            background-color: rgba(209, 250, 229, 0.8);
            color: #047857;
            border: 1px solid #6ee7b7;
        }
        
        .info-message {
            background-color: rgba(219, 234, 254, 0.8);
            color: #1e40af;
            border: 1px solid #93c5fd;
        }
        
        /* Step visibility */
        .form-step {
            display: none;
        }
        
        .form-step.active {
            display: block;
        }
        
        /* Responsive adjustments */
        @media (max-width: 992px) {
            .form-container {
                max-width: 750px;
                width: 95%;
            }
        }
        
        @media (max-width: 768px) {
            .form-container {
                width: 95%;
                padding: 30px 25px;
                margin: 20px auto;
            }
            
            h2 {
                font-size: 1.8rem;
            }
            
            .form-label {
                font-size: 1rem;
                margin-bottom: 8px;
            }
            
            .form-control, .btn {
                padding: 12px 16px;
                font-size: 1rem;
            }
            
            .button-container {
                flex-direction: column;
                gap: 15px;
            }
            
            .form-row {
                flex-direction: column;
                gap: 10px;
            }
            
            .progress-step {
                width: 30px;
                height: 30px;
                font-size: 0.8rem;
            }
            
            .progress-step-label {
                font-size: 0.7rem;
                bottom: -20px;
            }
        }
        
        @media (max-width: 480px) {
            .form-container {
                width: 100%;
                padding: 25px 20px;
                border-radius: 12px;
            }
            
            .form-control {
                padding: 10px 14px;
            }
            
            h2 {
                font-size: 1.6rem;
            }
        }
        
        /* Mini Calendar Styles */
        .mini-calendar {
            margin-top: 10px;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 15px;
            background: linear-gradient(45deg, #4158D0, #C850C0);
            color: white;
        }
        
        .calendar-nav {
            background: none;
            border: none;
            color: white;
            font-size: 1.2rem;
            cursor: pointer;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: background 0.3s;
        }
        
        .calendar-nav:hover {
            background: rgba(255,255,255,0.2);
        }
        
        .calendar-month-year {
            font-weight: 600;
            font-size: 1rem;
        }
        
        .calendar-body {
            padding: 10px;
        }
        
        .calendar-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .calendar-table th {
            padding: 8px 0;
            font-size: 0.8rem;
            color: #64748b;
            font-weight: 500;
            text-align: center;
        }
        
        .calendar-table td {
            text-align: center;
            padding: 8px 0;
            font-size: 0.9rem;
            width: 14.28%;
            cursor: default;
            border-radius: 4px;
        }
        
        .calendar-table td.selectable {
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .calendar-table td.selectable:hover {
            background-color: #e2e8f0;
        }
        
        .calendar-table td.today {
            background-color: #e5edff;
            font-weight: 600;
        }
        
        .calendar-table td.selected {
            background: linear-gradient(45deg, #4158D0, #C850C0);
            color: white;
            font-weight: 600;
        }
        
        .calendar-table td.disabled {
            color: #cbd5e0;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" onsubmit="return validateForm();">
        <div class="form-container">
            <h2>Book Your Event</h2>
            
            <div class="progress-container">
                <div class="progress-step active" id="step1Indicator">
                    1
                    <span class="progress-step-label">Details</span>
                </div>
                <div class="progress-step" id="step2Indicator">
                    2
                    <span class="progress-step-label">Additional Info</span>
                </div>
                <div class="progress-step" id="step3Indicator">
                    3
                    <span class="progress-step-label">Review</span>
                </div>
            </div>
            
            <div id="validationErrors" class="validation-errors"></div>
            
            <div id="step1" class="form-step active">
                <div class="form-group">
                    <label class="form-label" for="txtEventName">Event Name</label>
                    <asp:TextBox ID="txtEventName" runat="server" CssClass="form-control" placeholder="Enter event name"></asp:TextBox>
                </div>
                
                <div class="form-group">
                    <label class="form-label" for="ddlEventCategory">Event Category</label>
                    <asp:DropDownList ID="ddlEventCategory" runat="server" CssClass="form-control" onchange="updatePrice();">
                        <asp:ListItem Text="Select Category" Value="" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Conference" Value="Conference"></asp:ListItem>
                        <asp:ListItem Text="Meeting" Value="Meeting"></asp:ListItem>
                        <asp:ListItem Text="Workshop" Value="Workshop"></asp:ListItem>
                        <asp:ListItem Text="Social Event" Value="Social"></asp:ListItem>
                        <asp:ListItem Text="Other" Value="Other"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                
                <div class="form-group">
                    <label class="form-label" for="txtLocation">Location</label>
                    <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control" placeholder="Enter event location"></asp:TextBox>
                </div>
                
                <div class="form-row">
                    <div class="form-col">
                        <div class="form-group">
                            <label class="form-label" for="txtEventDate">Event Date</label>
                            <asp:TextBox ID="txtEventDate" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                            
                            <div class="mini-calendar" id="miniCalendar">
                                <div class="calendar-header">
                                    <button type="button" id="prevMonth" class="calendar-nav">«</button>
                                    <div id="calendarMonthYear" class="calendar-month-year">January 2023</div>
                                    <button type="button" id="nextMonth" class="calendar-nav">»</button>
                                </div>
                                <div class="calendar-body">
                                    <table class="calendar-table">
                                        <thead>
                                            <tr>
                                                <th>Su</th>
                                                <th>Mo</th>
                                                <th>Tu</th>
                                                <th>We</th>
                                                <th>Th</th>
                                                <th>Fr</th>
                                                <th>Sa</th>
                                            </tr>
                                        </thead>
                                        <tbody id="calendarBody">
                                            <!-- Will be filled by JavaScript -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-col">
                        <div class="form-group">
                            <label class="form-label" for="txtAttendees">Number of Attendees</label>
                            <asp:TextBox ID="txtAttendees" runat="server" TextMode="Number" min="1" value="1" CssClass="form-control" onchange="updatePrice();"></asp:TextBox>
                        </div>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-col">
                        <div class="form-group">
                            <label class="form-label" for="txtStartTime">Start Time</label>
                            <asp:TextBox ID="txtStartTime" runat="server" TextMode="Time" CssClass="form-control" onchange="updatePrice();"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-col">
                        <div class="form-group">
                            <label class="form-label" for="txtEndTime">End Time</label>
                            <asp:TextBox ID="txtEndTime" runat="server" TextMode="Time" CssClass="form-control" onchange="updatePrice();"></asp:TextBox>
                        </div>
                    </div>
                </div>
                
                <div id="priceEstimate" class="price-estimate">
                    <p>Estimated price based on your selections: $<span id="estimatedPrice">0.00</span></p>
                    <p class="note">(Final price may vary based on additional services requested)</p>
                </div>
                
                <div class="button-container">
                    <asp:Button ID="btnNext1" runat="server" Text="Next: Additional Information" CssClass="btn btn-primary" OnClientClick="document.getElementById('step1').classList.remove('active'); document.getElementById('step2').classList.add('active'); document.getElementById('step1Indicator').classList.add('completed'); document.getElementById('step1Indicator').classList.remove('active'); document.getElementById('step2Indicator').classList.add('active'); return false;" />
                </div>
            </div>
            
            <div id="step2" class="form-step">
                <div class="form-group">
                    <label class="form-label" for="txtDescription">Event Description</label>
                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" CssClass="form-control" placeholder="Please provide details about your event, any special requirements, etc."></asp:TextBox>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Event Materials</label>
                    <div class="file-upload">
                        <label class="file-upload-label">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 10px;"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="17 8 12 3 7 8"></polyline><line x1="12" y1="3" x2="12" y2="15"></line></svg>
                            Click to upload a file
                        </label>
                        <asp:FileUpload ID="fileUpload" runat="server" onchange="document.getElementById('fileName').textContent = this.value ? this.value.split('\\').pop() : ''" />
                        <div id="fileName" class="file-name"></div>
                    </div>
                </div>
                
                <div class="form-group checkbox-container">
                    <asp:CheckBox ID="chkTerms" runat="server" />
                    <label for="<%= chkTerms.ClientID %>">I agree to the <a href="#" class="terms-link" onclick="window.open('Terms.aspx', 'Terms', 'width=600,height=600'); return false;">terms and conditions</a></label>
                </div>
                
                <div class="button-container">
                    <asp:Button ID="btnBack2" runat="server" Text="Back" CssClass="btn btn-secondary" OnClientClick="document.getElementById('step2').classList.remove('active'); document.getElementById('step1').classList.add('active'); document.getElementById('step2Indicator').classList.remove('active'); document.getElementById('step1Indicator').classList.remove('completed'); document.getElementById('step1Indicator').classList.add('active'); return false;" />
                    <asp:Button ID="btnNext2" runat="server" Text="Next: Review" CssClass="btn btn-primary" OnClientClick="document.getElementById('step2').classList.remove('active'); document.getElementById('step3').classList.add('active'); document.getElementById('step2Indicator').classList.add('completed'); document.getElementById('step2Indicator').classList.remove('active'); document.getElementById('step3Indicator').classList.add('active'); return false;" />
                </div>
            </div>
            
            <div id="step3" class="form-step">
                <h3 style="text-align: center; margin-bottom: 20px; color: #3d4465;">Review Your Booking</h3>
                
                <div style="background-color: #f8fafc; border-radius: 8px; padding: 20px; margin-bottom: 25px;">
                    <div class="form-row">
                        <div class="form-col">
                            <p><strong>Event Name:</strong> <span id="reviewEventName"></span></p>
                            <p><strong>Category:</strong> <span id="reviewCategory"></span></p>
                            <p><strong>Location:</strong> <span id="reviewLocation"></span></p>
                        </div>
                        <div class="form-col">
                            <p><strong>Date:</strong> <span id="reviewDate"></span></p>
                            <p><strong>Time:</strong> <span id="reviewTime"></span></p>
                            <p><strong>Attendees:</strong> <span id="reviewAttendees"></span></p>
                        </div>
                    </div>
                    <p style="margin-top: 15px;"><strong>Description:</strong> <span id="reviewDescription"></span></p>
                    <p style="margin-top: 15px;"><strong>Attachments:</strong> <span id="reviewAttachments"></span></p>
                    
                    <div class="price-estimate" style="display: block; margin-top: 15px;">
                        <p>Estimated Price: $<span id="reviewPrice"></span></p>
                    </div>
                </div>
                
                <script type="text/javascript">
                    document.getElementById('btnNext2').addEventListener('click', function() {
                        // Populate review page
                        document.getElementById('reviewEventName').textContent = document.getElementById('<%= txtEventName.ClientID %>').value;
                        document.getElementById('reviewCategory').textContent = document.getElementById('<%= ddlEventCategory.ClientID %>').options[document.getElementById('<%= ddlEventCategory.ClientID %>').selectedIndex].text;
                        document.getElementById('reviewLocation').textContent = document.getElementById('<%= txtLocation.ClientID %>').value;
                        
                        var eventDate = new Date(document.getElementById('<%= txtEventDate.ClientID %>').value);
                        document.getElementById('reviewDate').textContent = eventDate.toLocaleDateString();
                        
                        var startTime = document.getElementById('<%= txtStartTime.ClientID %>').value;
                        var endTime = document.getElementById('<%= txtEndTime.ClientID %>').value;
                        document.getElementById('reviewTime').textContent = startTime + ' to ' + endTime;
                        
                        document.getElementById('reviewAttendees').textContent = document.getElementById('<%= txtAttendees.ClientID %>').value;
                        document.getElementById('reviewDescription').textContent = document.getElementById('<%= txtDescription.ClientID %>').value || 'None provided';
                        
                        var fileInput = document.getElementById('<%= fileUpload.ClientID %>');
                        if (fileInput.files.length > 0) {
                            var fileNames = [];
                            for (var i = 0; i < fileInput.files.length; i++) {
                                fileNames.push(fileInput.files[i].name);
                            }
                            document.getElementById('reviewAttachments').textContent = fileNames.join(', ');
                        } else {
                            document.getElementById('reviewAttachments').textContent = 'No files attached';
                        }
                        
                        document.getElementById('reviewPrice').textContent = document.getElementById('estimatedPrice').textContent;
                    });
                </script>
                
                <div class="button-container">
                    <asp:Button ID="btnBack3" runat="server" Text="Back" CssClass="btn btn-secondary" OnClientClick="document.getElementById('step3').classList.remove('active'); document.getElementById('step2').classList.add('active'); document.getElementById('step3Indicator').classList.remove('active'); document.getElementById('step2Indicator').classList.remove('completed'); document.getElementById('step2Indicator').classList.add('active'); return false;" />
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit Booking" OnClick="btnSubmit_Click" CssClass="btn btn-primary" />
                </div>
            </div>
            
            <asp:Label ID="lblMessage" runat="server" CssClass="message"></asp:Label>
        </div>
    </form>
</body>
</html>