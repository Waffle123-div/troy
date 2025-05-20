<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminPanel.aspx.cs" Inherits="Booking_system.AdminPanel" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Event Booking System - Admin Panel</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet">
    <link href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" rel="stylesheet">
    <style type="text/css">
        /* Argon Dashboard Style - Inline version */
        :root {
            --blue: #5e72e4;
            --indigo: #5603ad;
            --purple: #8965e0;
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
            --primary: #5e72e4;
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
            --font-family-sans-serif: Open Sans, sans-serif;
            --font-family-monospace: SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
        }

        *, *::before, *::after {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Open Sans, sans-serif;
            font-size: 1rem;
            font-weight: 400;
            line-height: 1.5;
            color: #525f7f;
            text-align: left;
            background-color: #f8f9fe;
        }

        a {
            color: #5e72e4;
            text-decoration: none;
            background-color: transparent;
        }

        a:hover {
            color: #233dd2;
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
            background: linear-gradient(87deg, #5e72e4 0, #825ee4 100%) !important;
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
            color: #5e72e4;
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
            color: #5e72e4;
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
            background-color: #5e72e4;
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
            color: #32325d;
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
            background-color: #5e72e4;
            border-color: #5e72e4;
        }

        .btn-primary:hover {
            color: #fff;
            background-color: #3c50e0;
            border-color: #324cdd;
        }

        .btn-success {
            color: #fff;
            background-color: #2dce89;
            border-color: #2dce89;
        }

        .btn-success:hover {
            color: #fff;
            background-color: #26af74;
            border-color: #24a46d;
        }

        .btn-danger {
            color: #fff;
            background-color: #f5365c;
            border-color: #f5365c;
        }

        .btn-danger:hover {
            color: #fff;
            background-color: #f01d48;
            border-color: #ec0c38;
        }

        .btn-info {
            color: #fff;
            background-color: #11cdef;
            border-color: #11cdef;
        }

        .btn-info:hover {
            color: #fff;
            background-color: #0eaeca;
            border-color: #0da5c0;
        }

        .text-white {
            color: #fff !important;
        }

        .bg-success {
            background-color: #2dce89 !important;
        }

        .bg-danger {
            background-color: #f5365c !important;
        }

        .bg-warning {
            background-color: #fb6340 !important;
        }

        .bg-info {
            background-color: #11cdef !important;
        }

        .bg-default {
            background-color: #172b4d !important;
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

        /* Stats cards */
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

        .stat-card .icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .stat-card .icon i {
            font-size: 1.5rem;
        }

        .stat-card h3 {
            font-size: 2rem;
            font-weight: 600;
            color: #32325d;
            margin-bottom: 0.5rem;
        }

        .stat-card p {
            font-size: 0.875rem;
            color: #8898aa;
            margin-bottom: 0;
        }

        /* Table styles */
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
        
        /* Form controls */
        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-control {
            display: block;
            width: 100%;
            height: calc(2.75rem + 2px);
            padding: 0.625rem 0.75rem;
            font-size: 1rem;
            line-height: 1.5;
            color: #8898aa;
            background-color: #fff;
            background-clip: padding-box;
            border: 1px solid #dee2e6;
            border-radius: 0.25rem;
            box-shadow: 0 1px 3px rgba(50, 50, 93, 0.15), 0 1px 0 rgba(0, 0, 0, 0.02);
            transition: all 0.15s ease-in-out;
        }

        .form-control:focus {
            color: #8898aa;
            background-color: #fff;
            border-color: #5e72e4;
            outline: 0;
            box-shadow: 0 4px 6px rgba(50, 50, 93, 0.11), 0 1px 3px rgba(0, 0, 0, 0.08);
        }

        /* Filter dropdown */
        .filter-section {
            margin: 20px 0;
            display: flex;
            align-items: center;
        }

        .filter-section label {
            margin-right: 10px;
            font-weight: 600;
            color: #525f7f;
        }

        select.form-control {
            padding-right: 2rem;
            height: calc(2.25rem + 2px);
            cursor: pointer;
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
        
        /* Badge styles */
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
</head>
<body>
    <form id="form1" runat="server">
        <!-- Sidebar navigation -->
        <nav class="sidenav navbar-vertical">
            <div class="sidenav-header">
                <a class="sidenav-brand" href="Default.aspx">
                    <i class="fas fa-calendar-alt mr-2"></i> Admin Panel
                </a>
            </div>
            <div class="user-info">
                <i class="fas fa-user-shield"></i>
                <span class="username"><asp:Literal ID="litSidebarAdminName" runat="server"></asp:Literal></span>
            </div>
            <ul class="sidenav-nav">
                <li class="sidenav-item">
                    <a class="sidenav-link" href="Default.aspx">
                        <i class="fas fa-home"></i> Home
                    </a>
                </li>
                <li class="sidenav-item">
                    <a class="sidenav-link active" href="AdminPanel.aspx">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
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
                        <h1 class="fade-in">Admin Dashboard</h1>
                    </div>
                </div>
            </div>

            <div class="container">
                <!-- Stats cards -->
                <div class="dashboard-stats fade-in">
                    <div class="stat-card">
                        <div class="icon bg-warning text-white">
                            <i class="fas fa-clock"></i>
                        </div>
                        <h3><asp:Literal ID="litPendingCount" runat="server">0</asp:Literal></h3>
                        <p>Pending Bookings</p>
                    </div>
                    <div class="stat-card">
                        <div class="icon bg-success text-white">
                            <i class="fas fa-check"></i>
                        </div>
                        <h3><asp:Literal ID="litApprovedCount" runat="server">0</asp:Literal></h3>
                        <p>Approved Bookings</p>
                    </div>
                    <div class="stat-card">
                        <div class="icon bg-danger text-white">
                            <i class="fas fa-times"></i>
                        </div>
                        <h3><asp:Literal ID="litDeclinedCount" runat="server">0</asp:Literal></h3>
                        <p>Declined Bookings</p>
                    </div>
                </div>

                <!-- Admin info -->
                <div class="card fade-in">
                    <div class="card-header">
                        <h3>Welcome, <asp:Literal ID="litAdminName" runat="server"></asp:Literal></h3>
                    </div>
                </div>

                <!-- Filter section -->
                <div class="card fade-in">
                    <div class="card-header">
                        <h3>Booking Management</h3>
                    </div>
                    <div class="card-body">
                        <div class="filter-section">
                            <label>Filter by status:</label>
                            <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" 
                                OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged" CssClass="form-control" style="width: auto;">
                                <asp:ListItem Text="Pending" Value="Pending" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Approved" Value="Approved"></asp:ListItem>
                                <asp:ListItem Text="Declined" Value="Declined"></asp:ListItem>
                                <asp:ListItem Text="All" Value="All"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <!-- Bookings table -->
                        <asp:GridView ID="gvBookings" runat="server" CssClass="table" AutoGenerateColumns="False" 
                            DataKeyNames="EventID" OnRowCommand="gvBookings_RowCommand" 
                            EmptyDataText="No booking requests found.">
                            <Columns>
                                <asp:BoundField DataField="EventID" HeaderText="ID" />
                                <asp:BoundField DataField="EventName" HeaderText="Event Name" />
                                <asp:BoundField DataField="Location" HeaderText="Location" />
                                <asp:BoundField DataField="EventDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
                                <asp:BoundField DataField="StartTime" HeaderText="Start Time" />
                                <asp:BoundField DataField="EndTime" HeaderText="End Time" />
                                <asp:BoundField DataField="Username" HeaderText="Requested By" />
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class='badge <%# GetStatusBadgeClass(Eval("Status").ToString()) %>'>
                                            <%# Eval("Status") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:Panel ID="actionPanel" runat="server" Visible='<%# Eval("Status").ToString() == "Pending" %>'>
                                            <asp:Button ID="btnApprove" runat="server" Text="Approve" 
                                                CommandName="Approve" CommandArgument='<%# Eval("EventID") %>' 
                                                CssClass="btn btn-success" />
                                            <asp:Button ID="btnDecline" runat="server" Text="Decline" 
                                                CommandName="Decline" CommandArgument='<%# Eval("EventID") %>' 
                                                CssClass="btn btn-danger" />
                                        </asp:Panel>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>