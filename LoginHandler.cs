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

namespace ContractBuilder1
{
    class LoginHandler
    {

        public static bool AreTheRightCookiesPresent()
        {
            string PTUName = string.Empty;
            string UName = string.Empty;
            string TPass = string.Empty;
            
            if (HttpContext.Current.Request.Cookies["PTUserID"] != null)
            {
                PTUName = HttpContext.Current.Request.Cookies["PTUserID"].Value;
            }
            else
            {
                return false;
            }


            if (HttpContext.Current.Request.Cookies["UserID"] != null)
            {
                UName = HttpContext.Current.Request.Cookies["UserID"].Value;
            }
            else
            {
                return false;
            }

            if (HttpContext.Current.Request.Cookies["TeamPass"] != null)
            {
                TPass = HttpContext.Current.Request.Cookies["TeamPass"].Value;
            }
            else
            {
                return false;
            }

            return true;
        }


        public static bool RemoveAllLoginCookies()
        {
            // Remove cookies associated to Login
            if (HttpContext.Current.Request.Cookies["PTUserID"] != null)
            {
                HttpContext.Current.Request.Cookies["PTUserID"].Expires = System.DateTime.Now.AddDays(-1);
            }

            if (HttpContext.Current.Request.Cookies["UserID"] != null)
            {
                HttpContext.Current.Request.Cookies["UserID"].Expires = System.DateTime.Now.AddDays(-1);
            }

            if (HttpContext.Current.Request.Cookies["TeamPass"] != null)
            {
                HttpContext.Current.Request.Cookies["TeamPass"].Expires = System.DateTime.Now.AddDays(-1);
            }
            
            return true;
        }



        private static readonly HashSet<char> _base64Characters = new HashSet<char>() { 
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/', 
    '='
};

        public static bool IsBase64String(string value)
        {
            if (string.IsNullOrEmpty(value))
            {
                return false;
            }
            else if (value.Any(c => !_base64Characters.Contains(c)))
            {
                return false;
            }

            try
            {
                System.Convert.FromBase64String(value);
                return true;
            }
            catch (System.FormatException)
            {
                return false;
            }
        }

    }
}