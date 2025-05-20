using System;
using System.Web.UI;
using System.Net.Mail;
using System.Net;

namespace Booking_system
{
    public partial class Contact : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Page load logic
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            // Basic validation
            if (string.IsNullOrEmpty(txtName.Text) || string.IsNullOrEmpty(txtEmail.Text) || 
                string.IsNullOrEmpty(txtSubject.Text) || string.IsNullOrEmpty(txtMessage.Text))
            {
                lblMessage.Text = "Please fill in all fields.";
                lblMessage.CssClass = "error";
                return;
            }

            try
            {
                // In a real application, you would send an actual email here
                // This is just a simulation of what would happen
                
                // Display success message
                lblMessage.Text = "Thank you for your message! We will get back to you soon.";
                lblMessage.CssClass = "success";
                
                // Clear form fields
                txtName.Text = string.Empty;
                txtEmail.Text = string.Empty;
                txtSubject.Text = string.Empty;
                txtMessage.Text = string.Empty;
            }
            catch (Exception ex)
            {
                // Log the exception
                System.Diagnostics.Debug.WriteLine("Error sending contact email: " + ex.Message);
                
                // Show error message
                lblMessage.Text = "An error occurred while sending your message. Please try again later.";
                lblMessage.CssClass = "error";
            }
        }
    }
} 