using System;
using System.IO;
using global::MySql.Data.MySqlClient;
using System.Configuration;
using System.Globalization;
using System.Web;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Booking_system
{
    public partial class BookingForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
                Response.Redirect("Login.aspx");
            
            // Check if the user is an admin, redirect to admin panel if true
            if (Session["Role"] != null && Session["Role"].ToString().Equals("Admin", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("AdminPanel.aspx");
                return;
            }
                
            if (!IsPostBack)
            {
                // Set default values
                txtEventDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtAttendees.Text = "1";
                
                // If there's form data in the session, load it
                if (Session["BookingFormData"] != null)
                {
                    BookingFormData formData = (BookingFormData)Session["BookingFormData"];
                    LoadFormData(formData);
                }
                
                // Set up client-side autosave
                ClientScript.RegisterStartupScript(this.GetType(), "AutoSave", @"
                    setInterval(function() {
                        if (document.activeElement && document.activeElement.id) {
                            // Only save if user is actively entering data
                            if (document.activeElement.tagName === 'INPUT' || 
                                document.activeElement.tagName === 'TEXTAREA' || 
                                document.activeElement.tagName === 'SELECT') {
                                
                                var formData = new FormData();
                                formData.append('__EVENTTARGET', 'AutoSave');
                                formData.append('__EVENTARGUMENT', '');
                                
                                // Add form fields
                                var inputs = document.querySelectorAll('input, textarea, select');
                                for (var i = 0; i < inputs.length; i++) {
                                    if (inputs[i].name && inputs[i].type !== 'file' && 
                                        inputs[i].type !== 'button' && inputs[i].type !== 'submit') {
                                        formData.append(inputs[i].name, inputs[i].value);
                                    }
                                }
                                
                                // Send using fetch
                                fetch(window.location.href, {
                                    method: 'POST',
                                    body: formData
                                });
                            }
                        }
                    }, 30000); // Autosave every 30 seconds
                ", true);
            }
            
            // Handle autosave
            if (Request["__EVENTTARGET"] == "AutoSave")
            {
                SaveFormToSession();
                Response.ContentType = "text/plain";
                Response.Write("Autosaved");
                Response.End();
            }
        }
        
        private void SaveFormToSession()
        {
            var formData = new BookingFormData
            {
                EventName = txtEventName.Text,
                EventCategory = ddlEventCategory.SelectedValue,
                Location = txtLocation.Text,
                EventDate = txtEventDate.Text,
                StartTime = txtStartTime.Text,
                EndTime = txtEndTime.Text,
                Attendees = txtAttendees.Text,
                Description = txtDescription.Text,
                TermsAccepted = chkTerms.Checked
            };
            
            Session["BookingFormData"] = formData;
        }
        
        private void LoadFormData(BookingFormData formData)
        {
            txtEventName.Text = formData.EventName;
            if (!string.IsNullOrEmpty(formData.EventCategory))
            {
                ddlEventCategory.SelectedValue = formData.EventCategory;
            }
            txtLocation.Text = formData.Location;
            txtEventDate.Text = formData.EventDate;
            txtStartTime.Text = formData.StartTime;
            txtEndTime.Text = formData.EndTime;
            txtAttendees.Text = formData.Attendees;
            txtDescription.Text = formData.Description;
            chkTerms.Checked = formData.TermsAccepted;
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            // Save form to session first (in case validation fails)
            SaveFormToSession();
            
            // Client-side validation is already in place, but we should still validate server-side
            if (!ValidateForm())
                return;
            
            // Check for time slot availability
            if (!CheckTimeSlotAvailability())
            {
                DisplayErrorMessage("The selected time slot is not available. Please choose a different time.");
                return;
            }

            // Get User ID from session
            int? userId = null;
            if (Session["UserID"] != null)
            {
                userId = Convert.ToInt32(Session["UserID"]);
            }

            if (userId == null)
            {
                DisplayErrorMessage("User session not found. Please log in again.");
                Response.Redirect("Login.aspx");
                return;
            }
            
            try
            {
                // Process file uploads first
                string attachmentPaths = ProcessFileUploads(userId.Value);
                string connectionString = ConfigurationManager.ConnectionStrings["EventBookingDBConnection"].ConnectionString;

                // Parse date and times
                DateTime parsedEventDate = DateTime.ParseExact(txtEventDate.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture);
                DateTime parsedStartTime = DateTime.ParseExact(txtStartTime.Text, "HH:mm", CultureInfo.InvariantCulture);
                DateTime parsedEndTime = DateTime.ParseExact(txtEndTime.Text, "HH:mm", CultureInfo.InvariantCulture);
                int attendees = int.Parse(txtAttendees.Text);

                using (MySqlConnection conn = new MySqlConnection(connectionString))
                {
                    conn.Open();
                    
                    // Insert into BookingRequests table directly without transaction to simplify
                    string query = @"
                        INSERT INTO BookingRequests 
                        (UserID, EventName, EventCategory, EventDate, StartTime, EndTime, 
                        NumberOfAttendees, Location, Description, Status, Notes, Attachments, RequestDate) 
                        VALUES 
                        (@UserID, @EventName, @EventCategory, @EventDate, @StartTime, @EndTime,
                        @NumberOfAttendees, @Location, @Description, 'Pending', @Notes, @Attachments, NOW())";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId.Value);
                        cmd.Parameters.AddWithValue("@EventName", txtEventName.Text.Trim());
                        cmd.Parameters.AddWithValue("@EventCategory", ddlEventCategory.SelectedValue);
                        cmd.Parameters.AddWithValue("@EventDate", parsedEventDate.Date);
                        cmd.Parameters.AddWithValue("@StartTime", parsedStartTime.TimeOfDay);
                        cmd.Parameters.AddWithValue("@EndTime", parsedEndTime.TimeOfDay);
                        cmd.Parameters.AddWithValue("@NumberOfAttendees", attendees);
                        cmd.Parameters.AddWithValue("@Location", txtLocation.Text.Trim());
                        cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                        cmd.Parameters.AddWithValue("@Notes", "Submitted through web form");
                        cmd.Parameters.AddWithValue("@Attachments", attachmentPaths);
                        
                        cmd.ExecuteNonQuery();
                    }
                }

                // Clear the session data since form was successfully submitted
                Session.Remove("BookingFormData");
                
                // Add a success message to the session to display on the destination page
                Session["SuccessMessage"] = "Booking request submitted successfully. Awaiting admin approval.";
                
                // Simple redirect without the Response.End() that can cause connection issues
                if (Session["Role"] != null && Session["Role"].ToString().Equals("Admin", StringComparison.OrdinalIgnoreCase))
                {
                    Response.Redirect("AdminPanel.aspx");
                }
                else
                {
                    Response.Redirect("Dashboard.aspx");
                }
            }
            catch (Exception ex)
            {
                DisplayErrorMessage("A database error occurred. Please try again. Error: " + ex.Message);
            }
        }
        
        private string ProcessFileUploads(int userId)
        {
            if (fileUpload.HasFile)
            {
                var uploadDir = Server.MapPath("~/Uploads/" + userId);
                
                // Create directory if it doesn't exist
                if (!Directory.Exists(uploadDir))
                    Directory.CreateDirectory(uploadDir);
                    
                var sb = new StringBuilder();
                
                // Handle a single file upload instead of multiple
                HttpPostedFile file = fileUpload.PostedFile;
                if (file.ContentLength > 0)
                {
                    // Generate a unique filename
                    string fileName = Path.GetFileName(file.FileName);
                    string uniqueFileName = Guid.NewGuid().ToString() + "_" + fileName;
                    string filePath = Path.Combine(uploadDir, uniqueFileName);
                    
                    // Save the file
                    file.SaveAs(filePath);
                    
                    sb.Append("Uploads/" + userId + "/" + uniqueFileName);
                }
                
                return sb.ToString();
            }
            return string.Empty;
        }
        
        private bool CheckTimeSlotAvailability()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["EventBookingDBConnection"].ConnectionString;
                
                DateTime parsedEventDate = DateTime.ParseExact(txtEventDate.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture);
                DateTime parsedStartTime = DateTime.ParseExact(txtStartTime.Text, "HH:mm", CultureInfo.InvariantCulture);
                DateTime parsedEndTime = DateTime.ParseExact(txtEndTime.Text, "HH:mm", CultureInfo.InvariantCulture);
                
                TimeSpan startTime = parsedStartTime.TimeOfDay;
                TimeSpan endTime = parsedEndTime.TimeOfDay;
                
                using (MySqlConnection conn = new MySqlConnection(connectionString))
                {
                    conn.Open();
                    
                    // Check for overlapping events that are approved
                    string query = @"
                        SELECT COUNT(*) FROM BookingRequests 
                        WHERE EventDate = @EventDate 
                        AND Status = 'Approved'
                        AND NOT (
                            (StartTime >= @EndTime) OR
                            (EndTime <= @StartTime)
                        )";
                    
                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EventDate", parsedEventDate.Date);
                        cmd.Parameters.AddWithValue("@StartTime", startTime);
                        cmd.Parameters.AddWithValue("@EndTime", endTime);
                        
                        int conflictCount = Convert.ToInt32(cmd.ExecuteScalar());
                        
                        return conflictCount == 0;
                    }
                }
            }
            catch (Exception)
            {
                // If there's an error checking availability, assume available
                // but log the error (in a real application)
                return true;
            }
        }

        private bool ValidateForm()
        {
            // Basic validation for empty fields
            if (string.IsNullOrEmpty(txtEventName.Text) || string.IsNullOrEmpty(txtLocation.Text) ||
                string.IsNullOrEmpty(txtEventDate.Text) || string.IsNullOrEmpty(txtStartTime.Text) ||
                string.IsNullOrEmpty(txtEndTime.Text) || string.IsNullOrEmpty(txtAttendees.Text) ||
                string.IsNullOrEmpty(ddlEventCategory.SelectedValue))
            {
                DisplayErrorMessage("All required fields must be filled out.");
                return false;
            }

            // Validate terms acceptance
            if (!chkTerms.Checked)
            {
                DisplayErrorMessage("You must accept the terms and conditions.");
                return false;
            }

            // Validate attendees is a positive number
            int attendees;
            if (!int.TryParse(txtAttendees.Text, out attendees) || attendees < 1)
            {
                DisplayErrorMessage("Number of attendees must be a positive number.");
                return false;
            }

            string eventDateStr = txtEventDate.Text;
            string startTimeStr = txtStartTime.Text;
            string endTimeStr = txtEndTime.Text;

            DateTime parsedEventDate;
            DateTime parsedStartTime;
            DateTime parsedEndTime;

            string dateFormat = "yyyy-MM-dd";
            string timeFormat = "HH:mm";

            bool isDateValid = DateTime.TryParseExact(eventDateStr, dateFormat, 
                                                    CultureInfo.InvariantCulture, 
                                                    DateTimeStyles.None, 
                                                    out parsedEventDate);

            bool isStartTimeValid = DateTime.TryParseExact(startTimeStr, timeFormat, 
                                                        CultureInfo.InvariantCulture, 
                                                        DateTimeStyles.None, 
                                                        out parsedStartTime);

            bool isEndTimeValid = DateTime.TryParseExact(endTimeStr, timeFormat, 
                                                      CultureInfo.InvariantCulture, 
                                                      DateTimeStyles.None, 
                                                      out parsedEndTime);

            if (!isDateValid || !isStartTimeValid || !isEndTimeValid)
            {
                DisplayErrorMessage("Invalid date or time format. Please check your entries.");
                return false;
            }

            // Validate event date is not in the past
            if (parsedEventDate.Date < DateTime.Now.Date)
            {
                DisplayErrorMessage("Event date cannot be in the past.");
                return false;
            }

            // Combine date with times
            DateTime eventStartDateTime = parsedEventDate.Date + parsedStartTime.TimeOfDay;
            DateTime eventEndDateTime = parsedEventDate.Date + parsedEndTime.TimeOfDay;

            if (eventEndDateTime <= eventStartDateTime)
            {
                DisplayErrorMessage("End time must be after start time.");
                return false;
            }
            
            // Validate file uploads
            if (fileUpload.HasFile)
            {
                HttpPostedFile file = fileUpload.PostedFile;
                // Check file size (max 10MB)
                if (file.ContentLength > 10 * 1024 * 1024)
                {
                    DisplayErrorMessage("File size exceeds the 10MB limit.");
                    return false;
                }
                
                // Check file extension
                string ext = Path.GetExtension(file.FileName).ToLower();
                string[] allowedExtensions = { ".pdf", ".doc", ".docx", ".ppt", ".pptx", ".xls", ".xlsx", ".jpg", ".jpeg", ".png" };
                
                bool isAllowedExtension = false;
                foreach (string allowedExt in allowedExtensions)
                {
                    if (ext == allowedExt)
                    {
                        isAllowedExtension = true;
                        break;
                    }
                }
                
                if (!isAllowedExtension)
                {
                    DisplayErrorMessage("File type not allowed. Please upload PDF, Office documents, or images.");
                    return false;
                }
            }

            return true;
        }

        private void DisplayErrorMessage(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "message error-message";
            
            // Add client-side script to ensure the message is visible
            ClientScript.RegisterStartupScript(this.GetType(), "ScrollToMessage", 
                "document.getElementById('" + lblMessage.ClientID + "').scrollIntoView({behavior: 'smooth'});", true);
        }

        private void DisplaySuccessMessage(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "message success-message";
        }
        
        private void DisplayInfoMessage(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "message info-message";
        }

        private void ClearForm()
        {
            txtEventName.Text = "";
            ddlEventCategory.SelectedIndex = 0;
            txtLocation.Text = "";
            txtEventDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtStartTime.Text = "";
            txtEndTime.Text = "";
            txtAttendees.Text = "1";
            txtDescription.Text = "";
            chkTerms.Checked = false;
            // We don't clear the file upload control as it's not possible to do server-side
        }
    }
    
    [Serializable]
    public class BookingFormData
    {
        public string EventName { get; set; }
        public string EventCategory { get; set; }
        public string Location { get; set; }
        public string EventDate { get; set; }
        public string StartTime { get; set; }
        public string EndTime { get; set; }
        public string Attendees { get; set; }
        public string Description { get; set; }
        public bool TermsAccepted { get; set; }
    }
}