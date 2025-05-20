<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs" Inherits="Booking_system.AdminLogin" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Login - Event Booking System</title>
    <style type="text/css">
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .login-container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
            padding: 40px;
            width: 400px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .header h2 {
            color: #1e3c72;
            margin: 0;
            font-weight: 600;
            font-size: 24px;
        }
        
        .logo {
            font-size: 28px;
            font-weight: 700;
            color: #1e3c72;
            margin-bottom: 10px;
        }
        
        .admin-badge {
            background-color: #1e3c72;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            display: inline-block;
            margin-bottom: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }
        
        .textbox {
            width: 100%;
            padding: 12px;
            border: 2px solid #e1e5eb;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .textbox:focus {
            border-color: #1e3c72;
            outline: none;
        }
        
        .button {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            border: none;
            border-radius: 6px;
            padding: 14px 20px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
            font-weight: 600;
            transition: opacity 0.3s;
        }
        
        .button:hover {
            opacity: 0.9;
        }
        
        .error {
            color: #dc3545;
            font-size: 14px;
            margin-top: 15px;
            display: block;
            text-align: center;
        }
        
        .links {
            margin-top: 20px;
            text-align: center;
            font-size: 14px;
        }
        
        .links a {
            color: #1e3c72;
            text-decoration: none;
            transition: color 0.3s;
        }
        
        .links a:hover {
            color: #2a5298;
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <div class="header">
                <div class="logo">Event Booking System</div>
                <div class="admin-badge">Administrator Access</div>
                <h2>Admin Login</h2>
            </div>
            
            <div class="form-group">
                <label for="txtAdminUsername">Username</label>
                <asp:TextBox ID="txtAdminUsername" runat="server" CssClass="textbox"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label for="txtAdminPassword">Password</label>
                <asp:TextBox ID="txtAdminPassword" runat="server" TextMode="Password" CssClass="textbox"></asp:TextBox>
            </div>
            
            <asp:Button ID="btnAdminLogin" runat="server" Text="Login as Administrator" OnClick="btnAdminLogin_Click" CssClass="button" />
            
            <asp:Label ID="lblMessage" runat="server" CssClass="error"></asp:Label>
            
            <div class="links">
                <asp:HyperLink ID="UserLoginLink" runat="server" NavigateUrl="~/Login.aspx">User Login</asp:HyperLink>
                &nbsp;|&nbsp;
                <asp:HyperLink ID="AdminRegisterLink" runat="server" NavigateUrl="~/AdminRegistration.aspx">Register Admin</asp:HyperLink>
                &nbsp;|&nbsp;
                <asp:HyperLink ID="HomeLink" runat="server" NavigateUrl="~/Default.aspx">Back to Home</asp:HyperLink>
            </div>
        </div>
    </form>
</body>
</html> 