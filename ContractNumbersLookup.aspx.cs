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

namespace ContractBuilder1
{
    public partial class ContractNumbersLookup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // LOOKUP EXISTING DOCUMENTS
            // Get the database connection string
            string sdwConnectionString = ConfigurationManager.ConnectionStrings["connection187"].ConnectionString;
            SqlConnection sdwDBConnection = new SqlConnection(sdwConnectionString);   // Create a connection
            sdwDBConnection.Open();
            // Create the query
            string docDetailsQuery = string.Empty;
            docDetailsQuery += "SELECT TOP 5 Docs.Id, Docs.ActiveAsOf, Docs.CnNum, Docs.Status, Peeps.PersonEID ";
            docDetailsQuery += "FROM Docs INNER JOIN Peeps ";
            docDetailsQuery += "ON Docs.PeepID=Peeps.Id ";
            docDetailsQuery += "WHERE (Docs.CnNum!='') ";
            docDetailsQuery += "ORDER BY Docs.CnNum DESC ";
            // Do the lookup
            SqlCommand queryCommand1 = new SqlCommand(docDetailsQuery, sdwDBConnection);  // Create a SqlCommand object
            SqlDataReader queryCommandReader1 = queryCommand1.ExecuteReader();
            DataTable dataTable1 = new DataTable();
            dataTable1.Load(queryCommandReader1);

            // Write the results into a javascript array for use by the client
            String theOutput = string.Empty;
            theOutput += "cnArr = new Array(); // global \r\n";
            theOutput += "function doOnLoad() {\r\n";
            for (int i = 0; i < dataTable1.Rows.Count; i++)
            {
                string theCnNum = dataTable1.Rows[i]["CnNum"].ToString().Trim();
                string thePersonEID = dataTable1.Rows[i]["PersonEID"].ToString().Trim();
                string theActiveDate = dataTable1.Rows[i]["ActiveAsOf"].ToString().Trim();
                string theStatus = dataTable1.Rows[i]["Status"].ToString().Trim();
                string theDocID = dataTable1.Rows[i]["ID"].ToString().Trim();
                theOutput += "cnArr.push(new Array('" + theCnNum + "','" + thePersonEID + "','" + theActiveDate + "','" + theStatus + "','" + theDocID + "'));\r\n";
            }
            theOutput += "var lastNum = parseInt((cnArr[0][0].split('-')[1]),10); \r\n";
            theOutput += "cnArr.reverse();\r\n";
            theOutput += "setTimeout('parent.contractNumbersRetrievedSuccessfully(cnArr,' + lastNum + ');',10);\r\n";
            theOutput += "} // end function \r\n";
            // Close the connection
            sdwDBConnection.Close();

            // LASTLY --- OUTPUT the results to the page
            string theFinalOutput = "\r\n\r\n<script type=\"text/javascript\">\r\n\r\n";
            theFinalOutput += theOutput + "\r\n\r\n";
            theFinalOutput += "\r\n</script>\r\n\r\n";
            databaseResults.InnerHtml = theFinalOutput;
        }
    }
}