using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Configuration;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

using System.Web.Security;



namespace ContractBuilder1
{
    public partial class Welcome : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            // Make sure the user is submitting the form for login
            string theAction = Action.Text;
            if (theAction != "Login") { return; }

            // Gather values
            string plainTextUserID = HttpContext.Current.Request.Cookies["PTUserID"].Value;
            string theU = UserID.Text.Trim();
            string theP = UserPass.Text.Trim();
            string theTP = TeamPass.Text.Trim();
            if ((plainTextUserID=="") || (theU == "") || (theP == "") || (theTP == ""))
            {
                Msg.Text = "Fill in all fields, then try again.";
                return;
            }

            // Make sure the values are base64 strings (avoid sql injection)
            if ((LoginHandler.IsBase64String(theU)) && (LoginHandler.IsBase64String(theP)) && (LoginHandler.IsBase64String(theTP))) {
                // Lookup the username / password
                string sdwConnectionString = ConfigurationManager.ConnectionStrings["connection187"].ConnectionString;
                SqlConnection sdwDBConnection = new SqlConnection(sdwConnectionString);   // Create a connection
                sdwDBConnection.Open();
                // Create the query
                string docDetailsQuery = string.Empty;
                docDetailsQuery += "SELECT * ";
                docDetailsQuery += "FROM SystemUsers ";
                docDetailsQuery += "WHERE (HashedUserID='" + theU + "') AND (HashedUserPW='" + theP + "') ";
                // Do the lookup
                SqlCommand queryCommand1 = new SqlCommand(docDetailsQuery, sdwDBConnection);  // Create a SqlCommand object
                SqlDataReader queryCommandReader1 = queryCommand1.ExecuteReader();
                DataTable dataTable1 = new DataTable();
                dataTable1.Load(queryCommandReader1);
                // Check the result
                if (dataTable1.Rows.Count == 1)
                {
                    string canEditTemplate = dataTable1.Rows[0]["EditTemplate"].ToString().Trim();
                    createLoginCookie(theU,theTP,canEditTemplate);
                    return;
                } else {
                    Msg.Text = "The username / password combination is not valid; please try again.";
                    return;
                }
                
            }
            else
            {
                Msg.Text = "Invalid login, please try again.  If the problem persists, please contact the system administrators.";
                return;
            }

        }


        protected void createLoginCookie(string userName, string teamPass, string canEditTemplate)
        {
            Response.Cookies["UserID"].Value = userName;
            Response.Cookies["UserID"].Expires = DateTime.Now.AddDays(1);
            Response.Cookies["TeamPass"].Value = teamPass;
            Response.Cookies["TeamPass"].Expires = DateTime.Now.AddDays(1);
            Session["Permissions_EditTemplate"] = canEditTemplate;
            FormsAuthentication.RedirectFromLoginPage (userName, true);
            return;
        }


        


    }
}