using System;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Specialized;
using System.Collections;

public partial class AuthDiagnostic : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        LoadAuthenticationInfo();
        LoadSessionInfo();
        LoadCookieInfo();
        LoadRequestInfo();
    }

    private void LoadAuthenticationInfo()
    {
        litAuthenticated.Text = User.Identity.IsAuthenticated.ToString();
        litUsername.Text = User.Identity.IsAuthenticated ? User.Identity.Name : "(not authenticated)";
        litAuthType.Text = User.Identity.IsAuthenticated ? User.Identity.AuthenticationType : "(n/a)";
    }

    private void LoadSessionInfo()
    {
        litSessionRole.Text = Session["Role"] != null ? Session["Role"].ToString() : "(not set)";
        litSessionUsername.Text = Session["Username"] != null ? Session["Username"].ToString() : "(not set)";

        // Get all session keys
        StringBuilder sb = new StringBuilder();
        foreach (string key in Session.Keys)
        {
            sb.AppendFormat("{0}: {1}\r\n", key, Session[key]);
        }
        litAllSessionKeys.Text = sb.ToString().Length > 0 ? sb.ToString() : "(no session keys)";
    }

    private void LoadCookieInfo()
    {
        HttpCookie authCookie = Request.Cookies[FormsAuthentication.FormsCookieName];
        litAuthCookie.Text = (authCookie != null).ToString();
        
        if (authCookie != null)
        {
            litCookieValue.Text = authCookie.Value;
            try
            {
                FormsAuthenticationTicket ticket = FormsAuthentication.Decrypt(authCookie.Value);
                if (ticket != null)
                {
                    litCookieExpiration.Text = ticket.Expiration.ToString();
                }
                else
                {
                    litCookieExpiration.Text = "Unable to decrypt ticket";
                }
            }
            catch (Exception ex)
            {
                litCookieExpiration.Text = "Error: " + ex.Message;
            }
        }
        else
        {
            litCookieValue.Text = "(no cookie)";
            litCookieExpiration.Text = "(no cookie)";
        }
    }

    private void LoadRequestInfo()
    {
        litCurrentUrl.Text = Request.Url.ToString();
        litUserAgent.Text = Request.UserAgent;
        litClientIP.Text = Request.UserHostAddress;
    }

    protected void btnSetAdmin_Click(object sender, EventArgs e)
    {
        // Set session variables
        Session["Role"] = "Admin";
        Session["Username"] = "admin";
        
        // Set authentication cookie
        FormsAuthentication.SetAuthCookie("admin", false);
        
        // Refresh the page to show the new values
        Response.Redirect(Request.Url.ToString());
    }

    protected void btnClearSession_Click(object sender, EventArgs e)
    {
        Session.Clear();
        FormsAuthentication.SignOut();
        Response.Redirect(Request.Url.ToString());
    }

    protected void btnGoDashboard_Click(object sender, EventArgs e)
    {
        Response.Redirect("Dashboard.aspx");
    }

    protected void btnGoAdmin_Click(object sender, EventArgs e)
    {
        Response.Redirect("AdminPanel.aspx");
    }

    protected void btnGoLogin_Click(object sender, EventArgs e)
    {
        Response.Redirect("Login.aspx");
    }
} 