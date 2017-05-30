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
    public partial class AddendumBuilder : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Make sure the right cookies are in place
            if (LoginHandler.AreTheRightCookiesPresent() == false) { Response.Redirect("./Logout.aspx", true); return; }

            // See which YEAR the user is looking at
            string theYear = DateTime.Now.Year.ToString();
            if (DateTime.Now.Month == 12) { theYear = (DateTime.Now.Year + 1).ToString(); }
            if (Hidden_SelectedYear.Value == "") { Hidden_SelectedYear.Value = theYear; }
            Hidden_SelectedYear.Value = Hidden_SelectedYear.Value.Substring(0, 4);
            theYear = Hidden_SelectedYear.Value;
            // LOOKUP EXISTING DOCUMENTS
            // Get the database connection string
            string sdwConnectionString = ConfigurationManager.ConnectionStrings["connection187"].ConnectionString;
            SqlConnection sdwDBConnection = new SqlConnection(sdwConnectionString);   // Create a connection
            sdwDBConnection.Open();
            // Create the query
            string docDetailsQuery = string.Empty;
            docDetailsQuery += "SELECT Docs.Id, Docs.ActiveAsOf, Docs.MaxVal, Docs.CnNum, Docs.Status, Peeps.PersonEID ";
            docDetailsQuery += "FROM Docs INNER JOIN Peeps ";
            docDetailsQuery += "ON Docs.PeepID=Peeps.Id ";
            docDetailsQuery += "WHERE (Docs.DocType='A') AND (Peeps.Year LIKE '%" + theYear + "%') ";
            docDetailsQuery += "ORDER BY Peeps.PersonEID, Docs.ActiveAsOf";
            // Do the lookup
            SqlCommand queryCommand1 = new SqlCommand(docDetailsQuery, sdwDBConnection);  // Create a SqlCommand object
            SqlDataReader queryCommandReader1 = queryCommand1.ExecuteReader();
            DataTable dataTable1 = new DataTable();
            dataTable1.Load(queryCommandReader1);

            // Write the results into a javascript array for use by the client
            String thePersonOutput = string.Empty;
            thePersonOutput += "var pArr = new Array();\r\n";
            String theOutput = string.Empty;
            theOutput += "var docArr = new Array();\r\n";
            string theLastPerson = "---NONE!!---";
            for (int i = 0; i < dataTable1.Rows.Count; i++)
            {
                string thePersonEID = dataTable1.Rows[i]["PersonEID"].ToString().Trim();
                if (thePersonEID != theLastPerson)
                {
                    thePersonOutput += "pArr['" + thePersonEID + "'] = '" + thePersonEID + "';\r\n";
                    theOutput += "\r\ndocArr['" + thePersonEID + "'] = new Array();\r\n";
                    theLastPerson = thePersonEID;
                }
                string theDocID = dataTable1.Rows[i]["ID"].ToString().Trim();
                string theActiveDate = dataTable1.Rows[i]["ActiveAsOf"].ToString().Trim();
                string theMaxVal = dataTable1.Rows[i]["MaxVal"].ToString().Trim();
                string theCnNum = dataTable1.Rows[i]["CnNum"].ToString().Trim();
                string theStatus = dataTable1.Rows[i]["Status"].ToString().Trim();
                //theCreationDate = theCreationDate.Substring(0, theCreationDate.IndexOf(' '));
                //string theCreator = dataTable1.Rows[i]["Creator"].ToString().Trim();
                //string theLastUpdatedDate = dataTable1.Rows[i]["LastUpdated"].ToString().Trim();
                //string theLastUpdatedBy = dataTable1.Rows[i]["LastUpdatedBy"].ToString().Trim();
                //string theSORTCreatedDate = string.Empty;
                //string theSORTLastUpdatedDate = string.Empty;

                theOutput += "docArr['" + thePersonEID + "']['" + theDocID + "'] = new Array();\r\n";
                theOutput += "docArr['" + thePersonEID + "']['" + theDocID + "']['DocID'] = '" + theDocID + "';\r\n";
                theOutput += "docArr['" + thePersonEID + "']['" + theDocID + "']['ActiveDate'] = '" + theActiveDate + "';\r\n";
                theOutput += "docArr['" + thePersonEID + "']['" + theDocID + "']['MaxVal'] = '" + theMaxVal + "';\r\n";
                theOutput += "docArr['" + thePersonEID + "']['" + theDocID + "']['CnNum'] = '" + theCnNum + "';\r\n";
                theOutput += "docArr['" + thePersonEID + "']['" + theDocID + "']['Status'] = '" + theStatus + "';\r\n";
                //theOutput += "'" + theCreator + "',";
                //theOutput += "'" + theLastUpdatedDate + "',";
                //theOutput += "'" + theLastUpdatedBy + "',";
                //theOutput += "'" + theSORTCreatedDate + "',";
                //theOutput += "'" + theSORTLastUpdatedDate + "')";

            }

            // Drop in the current date
            string theTodaysDate = "";
            DateTime dt = DateTime.Now;
            int todaysYear = dt.Year;
            int theMonth = dt.Month;
            int theDay = dt.Day;
            theTodaysDate += todaysYear + "-";
            if (theMonth <= 9) { theTodaysDate += "0" + theMonth.ToString(); } else { theTodaysDate += theMonth.ToString(); }
            theTodaysDate += "-";
            if (theDay <= 9) { theTodaysDate += "0" + theDay.ToString(); } else { theTodaysDate += theDay.ToString(); }
            theOutput += "\r\n\r\ng_todaysDate = '" + theTodaysDate + "';\r\n";

            // Add permissions
            string canEditTemplate = "False";
            if (System.Web.HttpContext.Current.Session["Permissions_EditTemplate"] != null)
            {
                canEditTemplate = Session["Permissions_EditTemplate"].ToString();
            }
            theOutput += "\r\n\r\ng_canEditTemplate = '" + canEditTemplate + "';\r\n";

            string theFinalOutput = "\r\n\r\n<script type=\"text/javascript\">\r\n\r\n";
            theFinalOutput += thePersonOutput + "\r\n\r\n";
            theFinalOutput += theOutput + "\r\n\r\n";
            theFinalOutput += "var g_Year = '" + theYear + "';\r\n";
            theFinalOutput += "\r\n</script>\r\n\r\n";


            // Lookup the Main Template document (holds all clauses)
            string mainTemplateQuery = string.Empty;
            mainTemplateQuery += "SELECT * FROM Docs WHERE (DocType = 'A_mainTemplate')";
            // Do the lookup
            SqlCommand queryCommandT = new SqlCommand(mainTemplateQuery, sdwDBConnection);  // Create a SqlCommand object
            SqlDataReader queryCommandReaderT = queryCommandT.ExecuteReader();
            DataTable dataTableT = new DataTable();
            dataTableT.Load(queryCommandReaderT);
            //string templateDocID = string.Empty;
            //string templatePersonID = string.Empty;
            //string templateActiveDate = string.Empty;
            //string templateStatus = string.Empty;
            //string templateRost = string.Empty;
            //string templateMaxVal = string.Empty;
            //string templateDocType = string.Empty;
            string templateXML = string.Empty;
            for (int i = 0; i < dataTableT.Rows.Count; i++)
            {
                //templateDocID = dataTableT.Rows[i]["Id"].ToString().Trim();
                //templatePersonID = dataTableT.Rows[i]["PeepID"].ToString().Trim();
                //templateActiveDate = dataTableT.Rows[i]["ActiveAsOf"].ToString().Trim();
                //templateStatus = dataTableT.Rows[i]["Status"].ToString().Trim();
                //templateRost = dataTableT.Rows[i]["Rost"].ToString().Trim();
                //templateMaxVal = dataTableT.Rows[i]["MaxVal"].ToString().Trim();
                //templateDocType = dataTableT.Rows[i]["DocType"].ToString().Trim();
                templateXML = dataTableT.Rows[i]["DocXML"].ToString().Trim();
            }
            // Assign the Template XML to a hidden textarea field
            Hidden_AllClauses.Value = templateXML;



            // Close the connection
            sdwDBConnection.Close();

            // LASTLY --- OUTPUT the results to the page
            databaseResults.InnerHtml = theFinalOutput;
        }
    }
}