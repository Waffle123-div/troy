<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Contact.aspx.cs" Inherits="Booking_system.Contact" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <h2>Contact Us</h2>
    <div class="contact-container">
        <div class="contact-info">
            <h3>Get in Touch</h3>
            <p>Have questions about our booking system? We're here to help!</p>
            <ul class="contact-details">
                <li><i class="icon-location"></i> 123 Event Street, BookingCity</li>
                <li><i class="icon-phone"></i> +1 (555) 123-4567</li>
                <li><i class="icon-email"></i> info@eventbookingsystem.com</li>
            </ul>
            <div class="hours">
                <h4>Business Hours</h4>
                <p>Monday - Friday: 9:00 AM - 5:00 PM</p>
                <p>Saturday: 10:00 AM - 2:00 PM</p>
                <p>Sunday: Closed</p>
            </div>
        </div>
        <div class="contact-form">
            <h3>Send us a Message</h3>
            <div class="form-group">
                <label for="txtName">Your Name</label>
                <asp:TextBox ID="txtName" runat="server" CssClass="textbox" placeholder="Enter your name"></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtEmail">Your Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="textbox" placeholder="Enter your email"></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtSubject">Subject</label>
                <asp:TextBox ID="txtSubject" runat="server" CssClass="textbox" placeholder="What is this regarding?"></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtMessage">Your Message</label>
                <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="5" CssClass="textbox" placeholder="How can we help you?"></asp:TextBox>
            </div>
            <asp:Button ID="btnSubmit" runat="server" Text="Send Message" CssClass="button" OnClick="btnSubmit_Click" />
            <asp:Label ID="lblMessage" runat="server" CssClass="message"></asp:Label>
        </div>
    </div>
</asp:Content> 