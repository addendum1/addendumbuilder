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
    public partial class EditAddendum : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Make sure the right cookies are in place
            if (LoginHandler.AreTheRightCookiesPresent() == false) { Response.Redirect("./Logout.aspx", true); return; }

            // Get the database connection string
            string sdwConnectionString = ConfigurationManager.ConnectionStrings["connection187"].ConnectionString;
            SqlConnection sdwDBConnection = new SqlConnection(sdwConnectionString);   // Create a connection
            sdwDBConnection.Open();  // Open the DB connection

            // Lookup the Export Template
            // Note: Currently there is only one export template in the DB, this could be expanded in the future
            string exportFormatQuery = string.Empty;
            exportFormatQuery += "SELECT * FROM ExportTemplates";
            SqlCommand queryCommandEXP = new SqlCommand(exportFormatQuery, sdwDBConnection);  // Create a SqlCommand object
            SqlDataReader queryCommandReaderEXP = queryCommandEXP.ExecuteReader();
            DataTable dataTableEXP = new DataTable();
            dataTableEXP.Load(queryCommandReaderEXP);
            string ExportTemplateID = string.Empty;
            string ExportTemplateTitle = string.Empty;
            string ExportTemplateHeader = string.Empty;
            string ExportTemplateFooter = string.Empty;
            for (int i = 0; i < dataTableEXP.Rows.Count; i++)
            {
                ExportTemplateID = dataTableEXP.Rows[i]["Id"].ToString().Trim();
                ExportTemplateTitle = dataTableEXP.Rows[i]["Title"].ToString().Trim();
                ExportTemplateHeader = dataTableEXP.Rows[i]["Header"].ToString().Trim();
                ExportTemplateFooter = dataTableEXP.Rows[i]["Footer"].ToString().Trim();
            }
            // Assign the ExportTemplate XML to two hidden textarea fields
            Hidden_ExportTemplateHeader.Value = ExportTemplateHeader;
            Hidden_ExportTemplateFooter.Value = ExportTemplateFooter;

            // Is a doc id specified in the URL?
            string theDocID = Request.QueryString["DocID"];
            if (theDocID == null) { theDocID = "NEW"; }

            // Lookup the Main Template document (holds all clauses)
            string mainTemplateQuery = string.Empty;
            mainTemplateQuery += "SELECT * FROM Docs WHERE (DocType = 'A_mainTemplate')";
            // Do the lookup
            SqlCommand queryCommandT = new SqlCommand(mainTemplateQuery, sdwDBConnection);  // Create a SqlCommand object
            SqlDataReader queryCommandReaderT = queryCommandT.ExecuteReader();
            DataTable dataTableT = new DataTable();
            dataTableT.Load(queryCommandReaderT);
            string templateDocID = string.Empty;
            string templatePersonID = string.Empty;
            string templateActiveDate = string.Empty;
            string templateStatus = string.Empty;
            string templateMaxVal = string.Empty;
            string templateDocType = string.Empty;
            string templateXML = string.Empty;
            for (int i = 0; i < dataTableT.Rows.Count; i++)
            {
                templateDocID = dataTableT.Rows[i]["Id"].ToString().Trim();
                templatePersonID = dataTableT.Rows[i]["PeepID"].ToString().Trim();
                templateActiveDate = dataTableT.Rows[i]["ActiveAsOf"].ToString().Trim();
                templateStatus = dataTableT.Rows[i]["Status"].ToString().Trim();
                templateMaxVal = dataTableT.Rows[i]["MaxVal"].ToString().Trim();
                templateDocType = dataTableT.Rows[i]["DocType"].ToString().Trim();
                templateXML = dataTableT.Rows[i]["DocXML"].ToString().Trim();
            }
            // Assign the Template XML to a hidden textarea field
            Hidden_AllClauses.Value = templateXML;

            // Lookup the document details
            // Setup variables
            string thePersonID = string.Empty;
            string theActiveDate = string.Empty;
            string theStatus = string.Empty;
            string theMaxVal = string.Empty;
            string theDocType = string.Empty;
            string theXML = string.Empty;
            string thePersonName = string.Empty;
            string thePersonYear = string.Empty;
            // Audit properties
            string theCreatedDate = "TBD";
            string theCreatedBy = "TBD";
            string theLastUpdatedDate = "TBD";
            string theLastUpdatedBy = "TBD";

            if (theDocID != "MainTemplate")
            {
                string docDetailsQuery = string.Empty;
                docDetailsQuery += "SELECT * FROM Docs WHERE (Id = '" + theDocID + "')";
                // Do the lookup
                SqlCommand queryCommand1 = new SqlCommand(docDetailsQuery, sdwDBConnection);  // Create a SqlCommand object
                SqlDataReader queryCommandReader1 = queryCommand1.ExecuteReader();
                DataTable dataTable1 = new DataTable();
                dataTable1.Load(queryCommandReader1);
                for (int i = 0; i < dataTable1.Rows.Count; i++)
                {
                    theDocID = dataTable1.Rows[i]["Id"].ToString().Trim();
                    thePersonID = dataTable1.Rows[i]["PeepID"].ToString().Trim();
                    theActiveDate = dataTable1.Rows[i]["ActiveAsOf"].ToString().Trim();
                    theStatus = dataTable1.Rows[i]["Status"].ToString().Trim();
                    theMaxVal = dataTable1.Rows[i]["MaxVal"].ToString().Trim();
                    theDocType = dataTable1.Rows[i]["DocType"].ToString().Trim();
                    theXML = dataTable1.Rows[i]["DocXML"].ToString().Trim();

                    theCreatedDate = dataTable1.Rows[i]["CreatedDate"].ToString().Trim();
                    theCreatedBy = dataTable1.Rows[i]["CreatedBy"].ToString().Trim();
                    theLastUpdatedDate = dataTable1.Rows[i]["LastUpdatedDate"].ToString().Trim();
                    theLastUpdatedBy = dataTable1.Rows[i]["LastUpdatedBy"].ToString().Trim();
                }
                // Close the connection
                sdwDBConnection.Close();
                // Assign the DOC XML to a hidden textarea field
                Hidden_DocXML.Value = theXML;

                // Build the QUERY to lookup the Person name based on the PeepID
                string query2 = "SELECT PersonEID, Year FROM Peeps WHERE Id = '" + thePersonID + "'";
                sdwDBConnection.Open();
                // Do the lookup
                SqlCommand queryCommand2 = new SqlCommand(query2, sdwDBConnection);  // Create a SqlCommand object
                SqlDataReader queryCommandReader2 = queryCommand2.ExecuteReader();
                DataTable dataTable2 = new DataTable();
                dataTable2.Load(queryCommandReader2);
                for (int i = 0; i < dataTable2.Rows.Count; i++)
                {
                    thePersonName = dataTable2.Rows[i]["PersonEID"].ToString().Trim();
                    thePersonYear = dataTable2.Rows[i]["Year"].ToString().Trim();
                }

            }

            // Close the connection
            sdwDBConnection.Close();



            // Write the results into a javascript array for use by the client
            String theOutput = string.Empty;
            theOutput += "\r\n\r\n<script type=\"text/javascript\">\r\n\r\n";

            theOutput += "g_UserID = '" + Session["UserID"] + "'\r\n";

            theOutput += "g_PersonID = '" + thePersonID + "'\r\n";
            theOutput += "g_PersonEID = '" + thePersonName + "'\r\n";
            theOutput += "g_PersonYear = '" + thePersonYear + "'\r\n\r\n";
            theOutput += "g_DocID = '" + theDocID + "'\r\n";
            theOutput += "g_DocType = '" + theDocType + "'\r\n\r\n";
            theOutput += "mt_DocID = '" + templateDocID + "'\r\n";
            theOutput += "mt_DocType = '" + templateDocType + "'\r\n\r\n";

            theOutput += "g_CreatedDate = '" + theCreatedDate + "'\r\n";
            theOutput += "g_CreatedBy = '" + theCreatedBy + "'\r\n";
            theOutput += "g_LastUpdatedDate = '" + theLastUpdatedDate + "'\r\n";
            theOutput += "g_LastUpdatedBy = '" + theLastUpdatedBy + "'\r\n";

            // Drop in the current date
            theOutput += "g_todaysDate = '" + getTodaysDate() + "';";

            // LASTLY --- OUTPUT the results to the page
            theOutput += "\r\n\r\n";
            theOutput += "</script>\r\n\r\n";
            databaseResults.InnerHtml = theOutput;


        }

        protected string getTodaysDate()
        {
            string theTodaysDate = "";
            DateTime dt = DateTime.Now;
            int theYear = dt.Year;
            int theMonth = dt.Month;
            int theDay = dt.Day;
            theTodaysDate += theYear + "-";
            if (theMonth <= 9) { theTodaysDate += "0" + theMonth.ToString(); } else { theTodaysDate += theMonth.ToString(); }
            theTodaysDate += "-";
            if (theDay <= 9) { theTodaysDate += "0" + theDay.ToString(); } else { theTodaysDate += theDay.ToString(); }
            return theTodaysDate;
        }
    }
}