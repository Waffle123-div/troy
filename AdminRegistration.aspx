<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdminRegistration.aspx.cs" Inherits="AdminRegistration" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Registration - Event Booking System</title>
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
        
        .registration-container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
            padding: 40px;
            width: 450px;
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
        
        .success {
            color: #28a745;
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
        <div class="registration-container">
            <div class="header">
                <div class="logo">Event Booking System</div>
                <div class="admin-badge">Administrator Registration</div>
                <h2>Create Admin Account</h2>
            </div>
            
            <div class="form-group">
                <label for="txtUsername">Username</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="textbox"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
                    ControlToValidate="txtUsername" 
                    ErrorMessage="Username is required." 
                    Display="Dynamic" CssClass="error">
                </asp:RequiredFieldValidator>
            </div>
            
            <div class="form-group">
                <label for="txtEmail">Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="textbox" TextMode="Email"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                    ControlToValidate="txtEmail" 
                    ErrorMessage="Email is required." 
                    Display="Dynamic" CssClass="error">
                </asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revEmail" runat="server" 
                    ControlToValidate="txtEmail" 
                    ErrorMessage="Please enter a valid email." 
                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" 
                    Display="Dynamic" CssClass="error">
                </asp:RegularExpressionValidator>
            </div>
            
            <div class="form-group">
                <label for="txtPassword">Password</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="textbox"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                    ControlToValidate="txtPassword" 
                    ErrorMessage="Password is required." 
                    Display="Dynamic" CssClass="error">
                </asp:RequiredFieldValidator>
            </div>
            
            <div class="form-group">
                <label for="txtConfirmPassword">Confirm Password</label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="textbox"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" 
                    ControlToValidate="txtConfirmPassword" 
                    ErrorMessage="Please confirm your password." 
                    Display="Dynamic" CssClass="error">
                </asp:RequiredFieldValidator>
                <asp:CompareValidator ID="cvPassword" runat="server" 
                    ControlToValidate="txtConfirmPassword" 
                    ControlToCompare="txtPassword" 
                    ErrorMessage="Passwords do not match." 
                    Display="Dynamic" CssClass="error">
                </asp:CompareValidator>
            </div>
            
            <div class="form-group">
                <label for="txtSecretKey">Admin Registration Key</label>
                <asp:TextBox ID="txtSecretKey" runat="server" CssClass="textbox"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvSecretKey" runat="server" 
                    ControlToValidate="txtSecretKey" 
                    ErrorMessage="Registration key is required." 
                    Display="Dynamic" CssClass="error">
                </asp:RequiredFieldValidator>
            </div>
            
            <asp:Button ID="btnRegister" runat="server" Text="Register as Administrator" OnClick="btnRegister_Click" CssClass="button" />
            
            <asp:Label ID="lblMessage" runat="server" CssClass="error"></asp:Label>
            <asp:Label ID="lblSuccess" runat="server" CssClass="success"></asp:Label>
            
            <div class="links">
                <asp:HyperLink ID="AdminLoginLink" runat="server" NavigateUrl="~/AdminLogin.aspx">Already have an admin account? Log in</asp:HyperLink>
                <br /><br />
                <asp:HyperLink ID="HomeLink" runat="server" NavigateUrl="~/Default.aspx">Back to Home</asp:HyperLink>
            </div>
        </div>
    </form>
</body>
</html> 