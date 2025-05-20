using System;
using System.Data;
using System.Web.UI;
using System.Web.Security;
using System.Web.UI.WebControls;
using global::MySql.Data.MySqlClient;
using System.Configuration;

namespace Booking_system
{
    public partial class Default : System.Web.UI.Page
    {
        // These control declarations should match the ones in the designer file
        public TextBox txtName;
        public TextBox txtEmail;
        public TextBox txtSubject;
        public TextBox txtMessage;
        public Label lblMessage;
        public Button btnSubmit;
        public LinkButton btnLogout;
        public Repeater rptApprovedEvents;
        public Panel pnlNoEvents;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Allow all users to view the home page, regardless of authentication status
            // No redirects needed - users can stay on the homepage when logged in
            
            // Ensure controls are initialized if they're not being found automatically
            if (txtName == null) txtName = FindControl("txtName") as TextBox;
            if (txtEmail == null) txtEmail = FindControl("txtEmail") as TextBox;
            if (txtSubject == null) txtSubject = FindControl("txtSubject") as TextBox;
            if (txtMessage == null) txtMessage = FindControl("txtMessage") as TextBox;
            if (lblMessage == null) lblMessage = FindControl("lblMessage") as Label;
            if (btnSubmit == null) btnSubmit = FindControl("btnSubmit") as Button;
            if (btnLogout == null) btnLogout = FindControl("btnLogout") as LinkButton;
            if (rptApprovedEvents == null) rptApprovedEvents = FindControl("rptApprovedEvents") as Repeater;
            if (pnlNoEvents == null) pnlNoEvents = FindControl("pnlNoEvents") as Panel;

            if (!IsPostBack)
            {
                // Load approved events for display on the home page
                LoadApprovedEvents();
            }
        }
        
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Log the user out
            FormsAuthentication.SignOut();
            Session.Clear();
            Session.Abandon();
            
            // Redirect to home page
            Response.Redirect("Default.aspx");
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
                
                // Scroll back to the contact form to see the message
                ScriptManager.RegisterStartupScript(this, GetType(), "scrollToContact", 
                    "document.getElementById('contact-us').scrollIntoView();", true);
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

        private void LoadApprovedEvents()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["EventBookingDBConnection"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = @"SELECT 
                                      br.RequestID, 
                                      br.EventName, 
                                      br.EventDate, 
                                      br.StartTime, 
                                      br.EndTime, 
                                      br.Location, 
                                      br.Description,
                                      u.Username as OrganizerName
                                    FROM BookingRequests br
                                    JOIN Users u ON br.UserID = u.UserID
                                    WHERE br.Status = 'Approved'
                                    ORDER BY br.EventDate ASC
                                    LIMIT 6";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        DataTable dt = new DataTable();
                        using (MySqlDataAdapter adapter = new MySqlDataAdapter(cmd))
                        {
                            adapter.Fill(dt);
                        }

                        if (dt.Rows.Count > 0)
                        {
                            rptApprovedEvents.DataSource = dt;
                            rptApprovedEvents.DataBind();
                            pnlNoEvents.Visible = false;
                        }
                        else
                        {
                            // No events found, show the message panel
                            pnlNoEvents.Visible = true;
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Log the error but don't show it to users
                    System.Diagnostics.Debug.WriteLine("Error loading events: " + ex.Message);
                    
                    // In case of error, show the no events panel
                    pnlNoEvents.Visible = true;
                }
            }
        }

        protected string FormatEventDateTime(object eventDate, object startTime, object endTime)
        {
            try
            {
                DateTime date = Convert.ToDateTime(eventDate);
                string dateStr = date.ToString("dddd, MMMM d, yyyy");

                string timeStr = "";
                if (startTime != DBNull.Value && endTime != DBNull.Value)
                {
                    // We need to format startTime and endTime, which may be TimeSpan or DateTime
                    string start = startTime.ToString();
                    string end = endTime.ToString();

                    // Try to convert to TimeSpan if it's a DateTime
                    TimeSpan startTs;
                    TimeSpan endTs;

                    if (TimeSpan.TryParse(start, out startTs) && TimeSpan.TryParse(end, out endTs))
                    {
                        timeStr = string.Format("{0:hh\\:mm tt} - {1:hh\\:mm tt}", startTs, endTs);
                    }
                    else
                    {
                        // Try as DateTime
                        DateTime startDt;
                        DateTime endDt;
                        if (DateTime.TryParse(start, out startDt) && DateTime.TryParse(end, out endDt))
                        {
                            timeStr = string.Format("{0:h:mm tt} - {1:h:mm tt}", startDt, endDt);
                        }
                        else
                        {
                            // Just use the raw values if we can't parse
                            timeStr = string.Format("{0} - {1}", start, end);
                        }
                    }
                }

                return dateStr + (string.IsNullOrEmpty(timeStr) ? "" : " | " + timeStr);
            }
            catch
            {
                return "";
            }
        }
    }
} 
