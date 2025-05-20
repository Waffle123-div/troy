<%@ Page Title="About Us" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="About.aspx.cs" Inherits="Booking_system.About" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <div class="about-container">
        <h2>About Us</h2>
        
        <section class="about-section">
            <h3>Our Story</h3>
            <p>
                The Event Booking System was founded in 2023 with a simple mission: to make event management and booking as effortless as possible. 
                What started as a small project to help local venues manage their bookings has grown into a comprehensive platform serving organizations of all sizes.
            </p>
            <p>
                Our team of dedicated professionals combines expertise in event management, software development, and customer service to deliver a seamless booking experience 
                for both venue administrators and users.
            </p>
        </section>
        
        <section class="about-section">
            <h3>Our Mission</h3>
            <p>
                We strive to simplify the event booking process through innovative technology while maintaining the human touch that makes each event special. 
                Our platform is designed to be intuitive, reliable, and adaptable to the unique needs of different venues and event types.
            </p>
        </section>
        
        <section class="about-section">
            <h3>Why Choose Us?</h3>
            <div class="features-grid">
                <div class="feature">
                    <h4>User-Friendly Interface</h4>
                    <p>Our platform is designed with simplicity in mind, making it easy for anyone to book and manage events.</p>
                </div>
                <div class="feature">
                    <h4>Secure Authentication</h4>
                    <p>We prioritize the security of your data with robust authentication and privacy measures.</p>
                </div>
                <div class="feature">
                    <h4>Efficient Approval Process</h4>
                    <p>Our streamlined approval workflow ensures quick turnaround times for booking requests.</p>
                </div>
                <div class="feature">
                    <h4>Comprehensive Reporting</h4>
                    <p>Get insights into booking patterns and venue utilization with our reporting tools.</p>
                </div>
            </div>
        </section>
        
        <section class="about-section">
            <h3>Our Team</h3>
            <p>
                Behind the Event Booking System is a team of passionate professionals dedicated to making event management easier and more efficient. 
                Our diverse backgrounds in technology, event planning, and customer service allow us to approach challenges from multiple perspectives.
            </p>
            <p>
                We're constantly learning, improving, and adapting our platform based on user feedback and emerging industry trends.
            </p>
        </section>
        
        <section class="about-section">
            <h3>Get Started Today</h3>
            <p>
                Ready to experience the difference? Create an account today and discover how the Event Booking System can streamline your event management process.
            </p>
            <div class="cta-buttons">
                <a href="RegisterUser.aspx" class="btn">Create Account</a>
                <a href="Contact.aspx" class="btn btn-outline">Contact Us</a>
            </div>
        </section>
    </div>
</asp:Content>
