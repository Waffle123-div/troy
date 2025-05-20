using System;
using System.Data;
using global::MySql.Data.MySqlClient;
using System.Configuration;
using System.Web.Security;
using System.Web;

namespace Booking_system
{
    public partial class AdminLogin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Clear any existing session if it's not a postback
            if (!IsPostBack)
            {
                Session.Clear();
                FormsAuthentication.SignOut();

                // Check if username was passed from regular login
                if (!string.IsNullOrEmpty(Request.QueryString["username"]))
                {
                    txtAdminUsername.Text = Request.QueryString["username"];
                    // Focus on password field
                    txtAdminPassword.Focus();
                }

                // Check for unauthorized access
                if (!string.IsNullOrEmpty(Request.QueryString["unauthorized"]))
                {
                    lblMessage.Text = "You need admin credentials to access the Admin Panel.";
                }
            }

            // If already authenticated as admin, redirect to admin panel
            if (User.Identity.IsAuthenticated && Session["Role"] != null && 
                Session["Role"].ToString().Equals("Admin", StringComparison.OrdinalIgnoreCase) && 
                Session["UserID"] != null)
            {
                Response.Redirect("AdminPanel.aspx", true); // Force end response
                return;
            }
        }

        protected void btnAdminLogin_Click(object sender, EventArgs e)
        {
            string username = txtAdminUsername.Text.Trim();
            string password = txtAdminPassword.Text.Trim();

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                lblMessage.Text = "Please enter both username and password.";
                return;
            }

            // For testing - quick admin login
            if (username.Equals("admin", StringComparison.OrdinalIgnoreCase))
            {
                // Clear any existing authentication/session
                FormsAuthentication.SignOut();
                Session.Clear();
                
                // Set new authentication and session
                Session["UserID"] = "1";
                Session["Username"] = "admin";
                Session["Role"] = "Admin";
                
                // Create and set authentication ticket
                FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
                    1,                                  // version
                    username,                           // username
                    DateTime.Now,                       // issue time
                    DateTime.Now.AddMinutes(30),        // expiration
                    false,                              // persistent
                    "Admin",                            // user data - stores the role
                    FormsAuthentication.FormsCookiePath // cookie path
                );
                
                // Encrypt the ticket
                string encTicket = FormsAuthentication.Encrypt(ticket);
                
                // Create the cookie
                HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encTicket);
                Response.Cookies.Add(authCookie);
                
                // Force redirect to admin panel
                Response.Redirect("AdminPanel.aspx", true);
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["EventBookingDBConnection"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                string query = "SELECT UserID, Username, Role FROM Users WHERE Username = @Username AND Password = @Password AND Role = 'Admin'";
                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Password", password); // In production, use proper password hashing

                    try
                    {
                        conn.Open();
                        using (MySqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Clear any existing authentication/session
                                FormsAuthentication.SignOut();
                                Session.Clear();
                                
                                // Set session variables
                                Session["UserID"] = reader["UserID"].ToString();
                                Session["Username"] = reader["Username"].ToString();
                                Session["Role"] = reader["Role"].ToString();
                                
                                // Create and set authentication ticket
                                FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
                                    1,                                  // version
                                    username,                           // username
                                    DateTime.Now,                        // issue time
                                    DateTime.Now.AddMinutes(30),         // expiration
                                    false,                               // persistent
                                    "Admin",                             // user data - stores the role
                                    FormsAuthentication.FormsCookiePath  // cookie path
                                );
                                
                                // Encrypt the ticket
                                string encTicket = FormsAuthentication.Encrypt(ticket);
                                
                                // Create the cookie
                                HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encTicket);
                                Response.Cookies.Add(authCookie);
                                
                                // Force redirect to admin panel
                                Response.Redirect("AdminPanel.aspx", true);
                            }
                            else
                            {
                                lblMessage.Text = "Invalid administrator credentials.";
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        lblMessage.Text = "Database error during login. Please try again.";
                        // Log the error
                        System.Diagnostics.Debug.WriteLine("Login error: " + ex.Message);
                    }
                }
            }
        }
    }
} 
