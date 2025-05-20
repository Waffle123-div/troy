<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Booking_system.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Dashboard - Event Booking System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet">
    <link href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" rel="stylesheet">
    <style type="text/css">
        /* Argon Dashboard Style - Inline version with home page color scheme */
        :root {
            /* Home page colors */
            --primary-color: #1e3c72;
            --primary-light: #2a5298;
            --secondary-color: #6c5ce7;
            --primary-gradient: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
            
            /* Standard Argon colors with overrides */
            --blue: var(--primary-color);
            --indigo: #5603ad;
            --purple: var(--secondary-color);
            --pink: #f3a4b5;
            --red: #f5365c;
            --orange: #fb6340;
            --yellow: #ffd600;
            --green: #2dce89;
            --teal: #11cdef;
            --cyan: #2bffc6;
            --white: #fff;
            --gray: #8898aa;
            --gray-dark: #32325d;
            --light: #ced4da;
            --lighter: #e9ecef;
            --primary: var(--primary-color);
            --secondary: #f7fafc;
            --success: #2dce89;
            --info: #11cdef;
            --warning: #fb6340;
            --danger: #f5365c;
            --light: #adb5bd;
            --dark: #212529;
            --default: #172b4d;
            --white: #fff;
            --neutral: #fff;
            --darker: black;
            --breakpoint-xs: 0;
            --breakpoint-sm: 576px;
            --breakpoint-md: 768px;
            --breakpoint-lg: 992px;
            --breakpoint-xl: 1200px;
            --font-family-sans-serif: Poppins, 'Open Sans', sans-serif;
            --font-family-monospace: SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
        }

        *, *::before, *::after {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Poppins, 'Open Sans', sans-serif;
            font-size: 1rem;
            font-weight: 400;
            line-height: 1.5;
            color: #525f7f;
            text-align: left;
            background-color: #f8f9fe;
        }

        a {
            color: var(--primary-color);
            text-decoration: none;
            background-color: transparent;
        }

        a:hover {
            color: var(--primary-light);
            text-decoration: none;
        }

        .container {
            width: 100%;
            padding-right: 15px;
            padding-left: 15px;
            margin-right: auto;
            margin-left: auto;
            max-width: 1140px;
        }

        .bg-gradient-primary {
            background: var(--primary-gradient) !important;
        }

        .navbar-vertical {
            padding-top: 0;
            box-shadow: 0 0 2rem 0 rgba(136, 152, 170, .15);
            transition: all .15s ease;
        }

        .navbar-vertical .navbar-brand {
            font-size: 1rem;
            padding-bottom: 1rem;
            padding-top: 1rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .025em;
        }

        .sidenav {
            width: 250px;
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            z-index: 1050;
            background-color: #fff;
            box-shadow: 0 0 2rem 0 rgba(136, 152, 170, .15);
            padding: 0;
        }

        .sidenav-header {
            padding: 1.5rem;
            text-align: center;
        }

        .sidenav-brand {
            font-size: 1rem;
            font-weight: 700;
            color: var(--primary-color);
            text-transform: uppercase;
            letter-spacing: .025em;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 100%;
        }

        .sidenav-nav {
            padding-left: 0;
            list-style: none;
            margin-bottom: 0;
        }

        .sidenav-item {
            margin-bottom: 0.125rem;
        }

        .sidenav-link {
            display: block;
            padding: 0.675rem 1.5rem;
            font-size: 0.875rem;
            color: #525f7f;
        }

        .sidenav-link:hover, .sidenav-link.active {
            color: var(--primary-color);
            background-color: #f6f9fc;
        }

        .sidenav-link i {
            min-width: 2.25rem;
            font-size: 0.9375rem;
            line-height: 1.5rem;
        }

        .main-content {
            position: relative;
            margin-left: 250px;
            padding: 1.5rem 1.5rem 4.5rem;
        }

        .header {
            position: relative;
            background-color: var(--primary-color);
            padding: 2rem 0;
            margin-bottom: 2rem;
        }

        .header-body {
            padding-bottom: 1.5rem;
        }

        .header-body h1 {
            color: #fff;
            margin-bottom: 0;
            font-weight: 600;
        }

        .card {
            position: relative;
            display: flex;
            flex-direction: column;
            min-width: 0;
            word-wrap: break-word;
            background-color: #fff;
            background-clip: border-box;
            border: 1px solid rgba(0, 0, 0, 0.05);
            border-radius: 0.375rem;
            margin-bottom: 30px;
            box-shadow: 0 0 2rem 0 rgba(136, 152, 170, .15);
        }

        .card-header {
            padding: 1.25rem 1.5rem;
            margin-bottom: 0;
            background-color: #fff;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .card-header h2, .card-header h3, .card-header h4 {
            margin-bottom: 0;
            color: var(--primary-color);
            font-weight: 500;
        }

        .card-body {
            flex: 1 1 auto;
            padding: 1.5rem;
        }

        .btn {
            display: inline-block;
            font-weight: 600;
            text-align: center;
            white-space: nowrap;
            vertical-align: middle;
            user-select: none;
            border: 1px solid transparent;
            padding: 0.625rem 1.25rem;
            font-size: 0.875rem;
            line-height: 1.5;
            border-radius: 0.375rem;
            transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
            margin: 0.125rem;
        }

        .btn-primary {
            color: #fff;
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            color: #fff;
            background-color: var(--primary-light);
            border-color: var(--primary-light);
        }

        .btn-outline {
            color: var(--primary-color);
            background-color: transparent;
            border-color: var(--primary-color);
        }

        .btn-outline:hover {
            color: #fff;
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .dashboard-stats {
            display: flex;
            flex-wrap: wrap;
            margin: -1rem;
            margin-bottom: 1rem;
        }

        .stat-card {
            background-color: #fff;
            border-radius: 0.375rem;
            box-shadow: 0 0 2rem 0 rgba(136, 152, 170, .15);
            padding: 1.5rem;
            margin: 1rem;
            flex: 1;
            min-width: 200px;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0 3rem 0 rgba(136, 152, 170, .2);
        }

        .stat-card h3 {
            font-size: 2rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .stat-card p {
            font-size: 0.875rem;
            color: #8898aa;
            margin-bottom: 0;
        }

        .welcome-message {
            background-color: #fff;
            border-radius: 0.375rem;
            box-shadow: 0 0 2rem 0 rgba(136, 152, 170, .15);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .welcome-message p {
            margin-bottom: 0;
            color: #525f7f;
        }

        .grid {
            display: flex;
            flex-wrap: wrap;
            margin: -0.5rem;
        }

        .grid > * {
            margin: 0.5rem;
        }

        .table {
            width: 100%;
            margin-bottom: 1rem;
            color: #525f7f;
            border-collapse: collapse;
        }

        .table th, .table td {
            padding: 1rem;
            vertical-align: top;
            border-top: 1px solid #e9ecef;
        }

        .table thead th {
            vertical-align: bottom;
            border-bottom: 2px solid #e9ecef;
            background-color: #f6f9fc;
            color: #8898aa;
            font-size: 0.65rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .table tbody tr:hover {
            background-color: #f6f9fc;
        }

        .badge {
            display: inline-block;
            padding: 0.35em 0.5em;
            font-size: 66%;
            font-weight: 600;
            line-height: 1;
            text-align: center;
            white-space: nowrap;
            vertical-align: baseline;
            border-radius: 0.375rem;
            transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }

        .badge-success {
            color: #fff;
            background-color: #2dce89;
        }

        .badge-warning {
            color: #fff;
            background-color: #fb6340;
        }

        .badge-danger {
            color: #fff;
            background-color: #f5365c;
        }

        .badge-info {
            color: #fff;
            background-color: #11cdef;
        }

        /* User info display */
        .user-info {
            display: flex;
            align-items: center;
            padding: 0.5rem 1.5rem;
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.875rem;
        }

        .user-info .username {
            font-weight: 600;
            color: white;
            margin-left: 0.5rem;
        }

        /* Mobile responsiveness */
        @media (max-width: 992px) {
            .sidenav {
                width: 100%;
                height: auto;
                position: relative;
            }
            .main-content {
                margin-left: 0;
            }
            .stat-card {
                min-width: 100%;
            }
        }
    </style>
    <script type="text/javascript">
        function navigateToHome() {
            window.location.href = 'Default.aspx';
            return false;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Sidebar navigation -->
        <nav class="sidenav navbar-vertical">
            <div class="sidenav-header">
                <a class="sidenav-brand" href="Default.aspx">
                    <i class="fas fa-calendar-alt mr-2"></i> Event Booking
                </a>
            </div>
            <div class="user-info" style="background-color: var(--primary-color);">
                <i class="fas fa-user-circle"></i>
                <span class="username"><asp:Label ID="lblSidebarUsername" runat="server" Text=""></asp:Label></span>
            </div>
            <ul class="sidenav-nav">
                <li class="sidenav-item">
                    <a class="sidenav-link" href="Default.aspx">
                        <i class="fas fa-home"></i> Home
                    </a>
                </li>
                <li class="sidenav-item">
                    <a class="sidenav-link active" href="Dashboard.aspx">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </a>
                </li>
                <li class="sidenav-item">
                    <a class="sidenav-link" href="BookingForm.aspx">
                        <i class="fas fa-calendar-plus"></i> New Booking
                    </a>
                </li>
                <li class="sidenav-item">
                    <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="sidenav-link">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </asp:LinkButton>
                </li>
            </ul>
        </nav>

        <!-- Main content -->
        <div class="main-content">
            <!-- Header -->
            <div class="header bg-gradient-primary">
                <div class="container">
                    <div class="header-body">
                        <h1 class="fade-in">Welcome, <asp:Label ID="lblUsername" runat="server"></asp:Label></h1>
                    </div>
                </div>
            </div>

            <div class="container">
                <!-- Stats cards -->
                <div class="dashboard-stats fade-in">
                    <div class="stat-card">
                        <h3><asp:Label ID="lblTotalBookings" runat="server">0</asp:Label></h3>
                        <p>Total Bookings</p>
                    </div>
                    <div class="stat-card">
                        <h3><asp:Label ID="lblPendingBookings" runat="server">0</asp:Label></h3>
                        <p>Pending Approvals</p>
                    </div>
                    <div class="stat-card">
                        <h3><asp:Label ID="lblApprovedBookings" runat="server">0</asp:Label></h3>
                        <p>Approved Bookings</p>
                    </div>
                </div>

                <!-- Welcome message -->
                <div class="welcome-message fade-in">
                    <p>Welcome back, <asp:Label ID="lblWelcomeUser" runat="server"></asp:Label>! Here's an overview of your bookings.</p>
                </div>

                <!-- Bookings table -->
                <div class="card fade-in">
                    <div class="card-header">
                        <h3>Your Bookings</h3>
                    </div>
                    <div class="card-body">
                        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
                            CssClass="table" OnRowCommand="GridView1_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="booking_id" HeaderText="Booking ID" />
                                <asp:BoundField DataField="venue_name" HeaderText="Event Name" />
                                <asp:BoundField DataField="EventDate" HeaderText="Event Date" DataFormatString="{0:yyyy-MM-dd}" />
                                <asp:BoundField DataField="event_time" HeaderText="Time" />
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class='badge <%# GetStatusBadgeClass(Eval("status").ToString()) %>'> 
                                            <%# Eval("status") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:Button runat="server" Text="Cancel" 
                                            CommandName="CancelBooking" 
                                            CommandArgument='<%# Eval("booking_id") %>'
                                            CssClass="btn btn-outline"
                                            OnClientClick="return confirm('Are you sure you want to cancel this booking?');" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>

                <!-- Quick actions -->
                <div class="card fade-in">
                    <div class="card-header">
                        <h3>Quick Actions</h3>
                    </div>
                    <div class="card-body">
                        <div class="grid">
                            <asp:Button ID="btnNewBooking" runat="server" Text="Create New Booking" 
                                OnClick="btnNewBooking_Click" CssClass="btn btn-primary" />
                            <asp:Button ID="btnViewProfile" runat="server" Text="View Profile" 
                                OnClick="btnViewProfile_Click" CssClass="btn btn-outline" />
                        </div>
                    </div>
                </div>
                
                <!-- Diagnostic section for development only -->
                <div class="card fade-in" style="margin-top: 20px; border: 1px dashed #ff0000;">
                    <div class="card-header">
                        <h3>Troubleshooting Tools</h3>
                    </div>
                    <div class="card-body">
                        <p style="color: #ff0000; font-weight: bold;">For development use only. Remove in production.</p>
                        <div class="grid">
                            <asp:Button ID="btnCreateTestBooking" runat="server" Text="Create Test Booking Entry" 
                                CssClass="btn btn-danger" OnClick="btnCreateTestBooking_Click" />
                            <asp:Button ID="btnAddTestData" runat="server" Text="Add Test Booking (Alt)" 
                                CssClass="btn btn-warning" OnClick="btnAddTestData_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>