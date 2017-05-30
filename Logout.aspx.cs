using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Web.Security;

namespace ContractBuilder1
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Remove cookies associated with Login
            LoginHandler.RemoveAllLoginCookies();
            FormsAuthentication.SignOut();
            Response.Redirect("./Welcome.aspx", false);

        }
    }
}