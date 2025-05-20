using System;
using System.Data;
using global::MySql.Data.MySqlClient;
using System.Configuration;
using System.Web.Security;

public partial class AdminRegistration : System.Web.UI.Page
{
    // This is the secret key required for admin registration
    private const string ADMIN_REGISTRATION_KEY = "admin123"; // Change this to a more secure key in production

    protected void Page_Load(object sender, EventArgs e)
    {
        // If user is already authenticated as admin, redirect to admin panel
        if (User.Identity.IsAuthenticated && Session["Role"] != null && 
            Session["Role"].ToString().Equals("Admin", StringComparison.OrdinalIgnoreCase))
        {
            Response.Redirect("AdminPanel.aspx");
        }
    }

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        // Clear previous messages
        lblMessage.Text = "";
        lblSuccess.Text = "";

        // Verify the admin registration key
        if (txtSecretKey.Text.Trim() != ADMIN_REGISTRATION_KEY)
        {
            lblMessage.Text = "Invalid admin registration key.";
            return;
        }

        string username = txtUsername.Text.Trim();
        string email = txtEmail.Text.Trim();
        string password = txtPassword.Text;

        // Check if username already exists
        if (UserExists(username))
        {
            lblMessage.Text = "Username already exists. Please choose another one.";
            return;
        }

        // Register the admin user
        if (RegisterAdmin(username, email, password))
        {
            lblSuccess.Text = "Admin registration successful! You can now log in.";
            ClearForm();
        }
        else
        {
            lblMessage.Text = "An error occurred during registration. Please try again.";
        }
    }

    private bool UserExists(string username)
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EventBookingDBConnection"].ConnectionString;
        using (MySqlConnection conn = new MySqlConnection(connectionString))
        {
            string query = "SELECT COUNT(*) FROM Users WHERE Username = @Username";
            using (MySqlCommand cmd = new MySqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@Username", username);
                try
                {
                    conn.Open();
                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    return count > 0;
                }
                catch (Exception ex)
                {
                    // Log the error
                    System.Diagnostics.Debug.WriteLine("Error checking if user exists: " + ex.Message);
                    return false;
                }
            }
        }
    }

    private bool RegisterAdmin(string username, string email, string password)
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EventBookingDBConnection"].ConnectionString;
        using (MySqlConnection conn = new MySqlConnection(connectionString))
        {
            // In production, use a secure password hashing method
            string query = "INSERT INTO Users (Username, Email, Password, Role, CreatedDate) VALUES (@Username, @Email, @Password, 'Admin', NOW())";
            using (MySqlCommand cmd = new MySqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Password", password); // Use password hashing in production
                
                try
                {
                    conn.Open();
                    int result = cmd.ExecuteNonQuery();
                    return result > 0;
                }
                catch (Exception ex)
                {
                    // Log the error
                    System.Diagnostics.Debug.WriteLine("Error registering admin: " + ex.Message);
                    return false;
                }
            }
        }
    }

    private void ClearForm()
    {
        txtUsername.Text = "";
        txtEmail.Text = "";
        txtPassword.Text = "";
        txtConfirmPassword.Text = "";
        txtSecretKey.Text = "";
    }
} 
