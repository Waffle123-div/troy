using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.UI;
using System.Web.Security;
using System.Web.UI.WebControls;
using global::MySql.Data.MySqlClient;

namespace Booking_system
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify database connection
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["EventBookingDBConnection"].ConnectionString;
                using (MySqlConnection conn = new MySqlConnection(connectionString))
                {
                    conn.Open();
                    System.Diagnostics.Debug.WriteLine("Database connection successful");
                    conn.Close();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(string.Format("DATABASE CONNECTION ERROR: {0}", ex.Message));
                ScriptManager.RegisterStartupScript(this, GetType(), "DbConnectionError", 
                    string.Format("console.error('Database connection error: {0}');", ex.Message.Replace("'", "\\'")), true);
            }

            // Check if user is authenticated
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // Debug authentication state
            System.Diagnostics.Debug.WriteLine(string.Format("User authenticated: {0}", User.Identity.IsAuthenticated));
            System.Diagnostics.Debug.WriteLine(string.Format("Username: {0}", User.Identity.Name));
            System.Diagnostics.Debug.WriteLine(string.Format("Session UserID: {0}", Session["UserID"] != null ? Session["UserID"].ToString() : "NULL"));

            // If not postback, populate user info and bookings
            if (!IsPostBack)
            {
                // Get username from authentication cookie
                string username = User.Identity.Name;
                lblUsername.Text = username;
                lblWelcomeUser.Text = username;
                lblSidebarUsername.Text = username;
                
                // If UserID is not in session, try to retrieve it from database
                if (Session["UserID"] == null && !string.IsNullOrEmpty(username))
                {
                    try
                    {
                        string connectionString = ConfigurationManager.ConnectionStrings["EventBookingDBConnection"].ConnectionString;
                        using (MySqlConnection conn = new MySqlConnection(connectionString))
                        {
                            conn.Open();
                            string query = "SELECT UserID FROM Users WHERE Username = @Username";
                            using (MySqlCommand cmd = new MySqlCommand(query, conn))
                            {
                                cmd.Parameters.AddWithValue("@Username", username);
                                object result = cmd.ExecuteScalar();
                                if (result != null)
                                {
                                    Session["UserID"] = result.ToString();
                                    System.Diagnostics.Debug.WriteLine(string.Format("Retrieved UserID from database: {0}", result));
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine(string.Format("Error retrieving UserID: {0}", ex.Message));
                    }
                }
                
                // Load user's bookings
                LoadBookings();
            }

            // Check if user is not an admin (admins should use AdminPanel.aspx)
            if (Session["Role"] != null && Session["Role"].ToString().Equals("Admin", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("AdminPanel.aspx");
                return;
            }

            // Display success message if it exists in the session
            if (Session["SuccessMessage"] != null)
            {
                string message = Session["SuccessMessage"].ToString();
                ScriptManager.RegisterStartupScript(this, GetType(), "SuccessAlert", 
                    string.Format("alert('{0}');", message.Replace("'", "\\'")), true);
                
                // Clear the message to prevent showing it again on refresh
                Session.Remove("SuccessMessage");
            }
        }

        private void LoadBookingStatistics()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["EventBookingDBConnection"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = @"SELECT 
                                    COUNT(*) as TotalCount,
                                    COUNT(CASE WHEN Status = 'Pending' THEN 1 END) as PendingCount,
                                    COUNT(CASE WHEN Status = 'Approved' THEN 1 END) as ApprovedCount
                                    FROM BookingRequests
                                    WHERE UserID = @UserID";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                        using (MySqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                lblTotalBookings.Text = reader["TotalCount"].ToString();
                                lblPendingBookings.Text = reader["PendingCount"].ToString();
                                lblApprovedBookings.Text = reader["ApprovedCount"].ToString();
                            }
                        }
                    }
                }
                catch (MySqlException ex)
                {
                    // For database schema issues, set default values
                    System.Diagnostics.Debug.WriteLine(string.Format("Database error in statistics: {0}", ex.Message));
                    lblTotalBookings.Text = "0";
                    lblPendingBookings.Text = "0";
                    lblApprovedBookings.Text = "0";
                }
                catch (Exception ex)
                {
                    // For other exceptions
                    System.Diagnostics.Debug.WriteLine(string.Format("Error loading booking statistics: {0}", ex.Message));
                    lblTotalBookings.Text = "?";
                    lblPendingBookings.Text = "?";
                    lblApprovedBookings.Text = "?";
                }
            }
        }

        private void LoadUserBookings()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["EventBookingDBConnection"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
            
                    // Debug Session UserID
                    string userIdValue = Session["UserID"] != null ? Session["UserID"].ToString() : "NULL";
                    System.Diagnostics.Debug.WriteLine(string.Format("Current UserID from Session: {0}", userIdValue));
            
                    // Updated query to match the actual table structure
                    string query = @"SELECT 
                                    RequestID as booking_id,
                                    EventName as venue_name,
                                    EventDate,
                                    CONCAT(StartTime, '') as event_time,
                                    Status as status
                                    FROM BookingRequests
                                    WHERE UserID = @UserID
                                    ORDER BY EventDate DESC";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                        using (MySqlDataAdapter adapter = new MySqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            adapter.Fill(dt);
                            
                            // Debug number of rows returned
                            System.Diagnostics.Debug.WriteLine(string.Format("Query returned {0} rows", dt.Rows.Count));
                            
                            GridView1.DataSource = dt;
                            GridView1.DataBind();
                            
                            // Show no data message if no bookings found
                            if (dt.Rows.Count == 0)
                            {
                                ScriptManager.RegisterStartupScript(this, GetType(), "NoBookings", 
                                    "console.log('No bookings found for this user.');", true);
                            }
                        }
                    }
                }
                catch (MySqlException ex)
                {
                    // For database schema issues, show a friendly message and still display the page
                    System.Diagnostics.Debug.WriteLine(string.Format("Database error: {0}", ex.Message));
                    
                    // Create an empty data table to bind to the grid
                    DataTable emptyTable = new DataTable();
                    emptyTable.Columns.Add("booking_id", typeof(int));
                    emptyTable.Columns.Add("venue_name", typeof(string));
                    emptyTable.Columns.Add("EventDate", typeof(DateTime));
                    emptyTable.Columns.Add("event_time", typeof(string));
                    emptyTable.Columns.Add("status", typeof(string));
                    
                    GridView1.DataSource = emptyTable;
                    GridView1.DataBind();
                    
                    ScriptManager.RegisterStartupScript(this, GetType(), "DatabaseError", 
                        "alert('There was an issue connecting to the booking database. Please contact the administrator. Error: " + 
                        ex.Message.Replace("'", "\\'") + "');", true);
                }
                catch (Exception ex)
                {
                    // For other exceptions
                    System.Diagnostics.Debug.WriteLine(string.Format("Error loading user bookings: {0}", ex.Message));
                    ScriptManager.RegisterStartupScript(this, GetType(), "LoadError", 
                        string.Format("alert('Error loading bookings: {0}');", ex.Message.Replace("'", "\\'")), true);
                }
            }
        }

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
                    return "";
            }
        }

        protected void btnNewBooking_Click(object sender, EventArgs e)
        {
            Response.Redirect("BookingForm.aspx");
        }

        protected void btnViewProfile_Click(object sender, EventArgs e)
        {
            // Implement profile view functionality
            // For now, we'll just show an alert
            ScriptManager.RegisterStartupScript(this, GetType(), "ProfileAlert", 
                "alert('Profile view functionality coming soon!');", true);
        }

        protected void btnCreateTestBooking_Click(object sender, EventArgs e)
        {
            // Version 2: Updated implementation
            if (Session["UserID"] == null)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "NoUserID", 
                    "alert('No UserID in session. Please log out and log back in.');", true);
                return;
            }

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["EventBookingDBConnection"].ConnectionString;
                using (MySqlConnection conn = new MySqlConnection(connectionString))
                {
                    conn.Open();
                    System.Diagnostics.Debug.WriteLine("Test booking: Connection opened successfully");
                    
                    // Simplified insert query
                    string query = @"
                        INSERT INTO BookingRequests (UserID, EventName, EventDate, Status, RequestDate) 
                        VALUES (@UserID, 'Test Event', CURDATE(), 'Pending', NOW())";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                        int result = cmd.ExecuteNonQuery();
                        
                        if (result > 0)
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "TestBookingSuccess", 
                                "alert('Test booking created successfully!');", true);
                            
                            LoadBookings(); // Reload to show the new booking
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "TestBookingError", 
                    string.Format("alert('Error: {0}');", ex.Message.Replace("'", "\\'")), true);
            }
        }

        protected void btnAddTestData_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "NoUserID2", 
                    "alert('No UserID in session. Please log out and log back in.');", true);
                return;
            }

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["EventBookingDBConnection"].ConnectionString;
                using (MySqlConnection conn = new MySqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "INSERT INTO BookingRequests (UserID, EventName, EventDate, Status) VALUES (@UserID, 'Alternate Test', CURDATE(), 'Pending')";
                    
                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                        int result = cmd.ExecuteNonQuery();
                        
                        if (result > 0)
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "TestSuccess2", 
                                "alert('Alternative test booking created successfully!');", true);
                            LoadBookings();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "TestError2", 
                    string.Format("alert('Alternative test error: {0}');", ex.Message.Replace("'", "\\'")), true);
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            FormsAuthentication.SignOut();
            Response.Redirect("Login.aspx");
        }

        protected void btnHome_Click(object sender, EventArgs e)
        {
            // First try to clear the response to ensure redirection works
            Response.Clear();
            
            // Set the status code for redirection
            Response.StatusCode = 302;
            
            // Add the Location header for proper redirection
            Response.AddHeader("Location", "Default.aspx");
            
            // End the response to force immediate redirection
            Response.End();
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "CancelBooking")
            {
                int bookingId = Convert.ToInt32(e.CommandArgument);
                CancelBooking(bookingId);
            }
        }

        private void CancelBooking(int bookingId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["EventBookingDBConnection"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = "UPDATE BookingRequests SET Status = 'Declined' WHERE RequestID = @BookingId AND UserID = @UserId";
                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@BookingId", bookingId);
                        cmd.Parameters.AddWithValue("@UserId", Session["UserID"]);
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            LoadBookingStatistics();
                            LoadUserBookings();
                            ScriptManager.RegisterStartupScript(this, GetType(), "CancelSuccess", 
                                "alert('Booking cancelled successfully!');", true);
                        }
                        else
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "CancelError", 
                                "alert('Unable to cancel booking. Please try again.');", true);
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Log the error
                    System.Diagnostics.Debug.WriteLine(string.Format("Error cancelling booking: {0}", ex.Message));
                    ScriptManager.RegisterStartupScript(this, GetType(), "CancelError", 
                        string.Format("alert('Error cancelling booking: {0}');", ex.Message.Replace("'", "\\'")), true);
                }
            }
        }

        private void LoadBookings()
        {
            LoadBookingStatistics();
            LoadUserBookings();
            
            // Add diagnostic check to verify if any bookings exist
            CheckIfAnyBookingsExist();
        }

        // Diagnostic method to check if there are any bookings in the database
        private void CheckIfAnyBookingsExist()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["EventBookingDBConnection"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT COUNT(*) FROM BookingRequests";
                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        int totalBookings = Convert.ToInt32(cmd.ExecuteScalar());
                        System.Diagnostics.Debug.WriteLine(string.Format("Total bookings in database (all users): {0}", totalBookings));
                        
                        if (totalBookings == 0)
                        {
                            // No bookings exist at all
                            System.Diagnostics.Debug.WriteLine(string.Format("WARNING: No bookings exist in the database at all!"));
                        }
                        
                        // Check table structure 
                        query = "DESCRIBE BookingRequests";
                        cmd.CommandText = query;
                        using (MySqlDataReader reader = cmd.ExecuteReader())
                        {
                            System.Diagnostics.Debug.WriteLine(string.Format("BookingRequests table structure:"));
                            while (reader.Read())
                            {
                                string columnName = reader["Field"].ToString();
                                string dataType = reader["Type"].ToString();
                                System.Diagnostics.Debug.WriteLine(string.Format("Column: {0}, Type: {1}", columnName, dataType));
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine(string.Format("ERROR in diagnostic check: {0}", ex.Message));
                }
            }
        }
    }
} 
