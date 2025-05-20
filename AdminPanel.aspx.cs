using System;
using System.Data;
using System.Configuration;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
// Direct MySQL references
using global::MySql.Data.MySqlClient;

// Ensure MySQL types are loaded through MySqlBasePage

// Force reference to MySQL types with a class outside the namespace
#pragma warning disable 0169 // Disable unused field warning
public class MySqlTypes
{
    // Static reference types to force loading of MySQL assembly
    private static readonly Type ConnectionType = typeof(MySql.Data.MySqlClient.MySqlConnection);
    private static readonly Type CommandType = typeof(MySql.Data.MySqlClient.MySqlCommand);
    private static readonly Type ParameterType = typeof(MySql.Data.MySqlClient.MySqlParameter);
    private static readonly Type DataReaderType = typeof(MySql.Data.MySqlClient.MySqlDataReader);
    private static readonly Type DataAdapterType = typeof(MySql.Data.MySqlClient.MySqlDataAdapter);
}
#pragma warning restore 0169

namespace Booking_system
{
    public partial class AdminPanel : System.Web.UI.Page
    {
        // Controls are declared in the designer file

        protected void Page_Load(object sender, EventArgs e)
        {
            
            // Check if session variables exist for admin role
            if (Session["UserID"] == null || Session["Role"] == null || 
                !Session["Role"].ToString().Equals("Admin", StringComparison.OrdinalIgnoreCase))
            {
                // Not an admin, redirect to the admin login page
                Response.Redirect("AdminLogin.aspx?unauthorized=true");
                return;
            }

            // Display any success message that might be in the session
            if (Session["SuccessMessage"] != null)
            {
                string message = Session["SuccessMessage"].ToString();
                ScriptManager.RegisterStartupScript(this, GetType(), "SuccessAlert", 
                    string.Format("alert('{0}');", message.Replace("'", "\\'")), true);
                
                // Clear the message to prevent showing it again on refresh
                Session.Remove("SuccessMessage");
            }

            litAdminName.Text = Session["Username"].ToString();

            if (!IsPostBack)
            {
                LoadBookingStatistics();
                LoadBookingRequests();
            }

            // In Page_Load, populate the sidebar admin name
            litSidebarAdminName.Text = litAdminName.Text;
        }

        private void LoadBookingStatistics()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["EventBookingDBConnection"].ConnectionString;
            using (MySqlConnection conn = DirectMySqlAccess.GetConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = @"SELECT 
                                    COUNT(CASE WHEN Status = 'Pending' THEN 1 END) as PendingCount,
                                    COUNT(CASE WHEN Status = 'Approved' THEN 1 END) as ApprovedCount,
                                    COUNT(CASE WHEN Status = 'Declined' THEN 1 END) as DeclinedCount
                                    FROM BookingRequests";

                    using (MySqlCommand cmd = DirectMySqlAccess.CreateCommand(query, conn))
                    {
                        using (MySqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                litPendingCount.Text = reader["PendingCount"].ToString();
                                litApprovedCount.Text = reader["ApprovedCount"].ToString();
                                litDeclinedCount.Text = reader["DeclinedCount"].ToString();
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Log the error
                    System.Diagnostics.Debug.WriteLine(string.Format("Error loading statistics: {0}", ex.Message));
                }
            }
        }

        private void LoadBookingRequests()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["EventBookingDBConnection"].ConnectionString;
            using (global::MySql.Data.MySqlClient.MySqlConnection conn = DirectMySqlAccess.GetConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string statusFilter = "Pending"; // Default to showing pending requests
                    if (ddlStatusFilter != null && ddlStatusFilter.SelectedValue != "All")
                    {
                        statusFilter = ddlStatusFilter.SelectedValue;
                    }
                    
                    string query = @"SELECT r.RequestID as EventID, r.EventName, r.EventDate, r.StartTime, r.EndTime, 
                                    r.NumberOfAttendees, r.Location, r.Status, r.Notes, u.Username
                                    FROM BookingRequests r
                                    JOIN Users u ON r.UserID = u.UserID";

                    if (statusFilter != "All")
                    {
                        query += " WHERE r.Status = @Status";
                    }
                    query += " ORDER BY r.RequestDate DESC";

                    using (global::MySql.Data.MySqlClient.MySqlCommand cmd = DirectMySqlAccess.CreateCommand(query, conn))
                    {
                        if (statusFilter != "All")
                        {
                            cmd.Parameters.AddWithValue("@Status", statusFilter);
                        }

                        using (global::MySql.Data.MySqlClient.MySqlDataAdapter adapter = new global::MySql.Data.MySqlClient.MySqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            adapter.Fill(dt);
                            gvBookings.DataSource = dt;
                            gvBookings.DataBind();
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Log the error
                    System.Diagnostics.Debug.WriteLine(string.Format("Error loading booking requests: {0}", ex.Message));
                    
                    // Show error in UI
                    ScriptManager.RegisterStartupScript(this, GetType(), "LoadError", 
                        string.Format("alert('Error loading booking requests: {0}');", ex.Message.Replace("'", "\\'")), true);
                }
            }
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadBookingRequests();
        }

        protected void gvBookings_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Approve" || e.CommandName == "Decline")
            {
                int requestId = Convert.ToInt32(e.CommandArgument);
                string status = e.CommandName == "Approve" ? "Approved" : "Declined";
                
                GridViewRow row = ((Button)e.CommandSource).NamingContainer as GridViewRow;
                TextBox notesTextBox = (TextBox)row.FindControl("txtNotes");
                string notes = notesTextBox != null ? notesTextBox.Text.Trim() : string.Empty;

                UpdateBookingStatus(requestId, status, notes);
                LoadBookingStatistics();
                LoadBookingRequests();
            }
        }

        private void UpdateBookingStatus(int requestId, string status, string notes)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["EventBookingDBConnection"].ConnectionString;
            using (global::MySql.Data.MySqlClient.MySqlConnection conn = DirectMySqlAccess.GetConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    
                    // Use direct SQL update
                    string updateQuery = "UPDATE BookingRequests SET Status = @Status, Notes = @Notes WHERE RequestID = @RequestID";
                    using (global::MySql.Data.MySqlClient.MySqlCommand cmd = DirectMySqlAccess.CreateCommand(updateQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Status", status);
                        cmd.Parameters.AddWithValue("@Notes", notes);
                        cmd.Parameters.AddWithValue("@RequestID", requestId);
                        cmd.ExecuteNonQuery();
                    }

                    // Show success message
                    ScriptManager.RegisterStartupScript(this, GetType(), "UpdateSuccess", 
                        string.Format("alert('Booking request successfully {0}!');", status.ToLower()), true);
                }
                catch (Exception ex)
                {
                    // Show error message
                    ScriptManager.RegisterStartupScript(this, GetType(), "UpdateError", 
                        string.Format("alert('Error updating booking status: {0}');", ex.Message.Replace("'", "\\'")), true);
                    
                    // Log the error
                    System.Diagnostics.Debug.WriteLine(string.Format("Error updating booking status: {0}", ex.Message));
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            FormsAuthentication.SignOut();
            Response.Redirect("AdminLogin.aspx");
        }

        // Add GetStatusBadgeClass method to support the badge styling in the GridView
        protected string GetStatusBadgeClass(string status)
        {
            switch (status.ToLower())
            {
                case "approved":
                    return "badge-success";
                case "pending":
                    return "badge-warning";
                case "declined":
                case "cancelled":
                    return "badge-danger";
                default:
                    return "badge-info";
            }
        }
    }
} 

