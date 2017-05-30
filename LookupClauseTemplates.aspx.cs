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
    public partial class LookupClauseTemplates : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Get the database connection string
            string sdwConnectionString = ConfigurationManager.ConnectionStrings["connection187"].ConnectionString;
            SqlConnection sdwDBConnection = new SqlConnection(sdwConnectionString);   // Create a connection

            // Set a default Title
            string theTitle = new DateTime().ToString();

            // Is a position specified in the URL?
            string thePosition = Request.QueryString["Position"];
            if (thePosition == null) { thePosition = "QB"; }

            // Is a doc id specified in the URL?
            string theDocID = Request.QueryString["DocID"];
            if (theDocID == null) { theDocID = "NEW"; }

            // Create a SUBQUERY for NEW docs that we will use a bit later
            string theSubQuery = " (SELECT ClauseTemplateID";
            theSubQuery += "        FROM   PositionTemplates";
            theSubQuery += "        WHERE  (Position = '" + thePosition + "')))";

            // If this is an EXISTING document then lookup the document details
            if (theDocID != "NEW")
            {
                 sdwDBConnection.Open();
                // Create the query
                string docDetailsQuery = string.Empty;
                docDetailsQuery += "SELECT Title, Position FROM Documents WHERE (DocID = '" + theDocID + "')";
                // Do the lookup
                SqlCommand queryCommand1 = new SqlCommand(docDetailsQuery, sdwDBConnection);  // Create a SqlCommand object
                SqlDataReader queryCommandReader1 = queryCommand1.ExecuteReader();
                DataTable dataTable1 = new DataTable();
                dataTable1.Load(queryCommandReader1);
                for (int i = 0; i < dataTable1.Rows.Count; i++)
                {
                    theTitle = dataTable1.Rows[i]["Title"].ToString().Trim();
                    thePosition = dataTable1.Rows[i]["Position"].ToString().Trim();
                }
                // Close the connection
                sdwDBConnection.Close();
                // Update the SUBQUERY to use the EXISTING doc instead
                theSubQuery = string.Empty;
                theSubQuery = "  (SELECT ClauseTemplateID";
                theSubQuery += " FROM    DocumentClauses";
                theSubQuery += " WHERE   (DocID = '" + theDocID + "')))";
            }

            
            // Build the QUERY to lookup all Clause Nodes associated with this document
            string query2 = "SELECT ClauseNodes.ID, ClauseNodes.ParentClauseID, ClauseNodes.SortOrder, ClauseNodes.Type, ClauseNodes.Txt, ClauseNodes.FontWeight, ClauseNodes.StartBullet, ClauseNodes.EndBullet, ClauseTemplates.Title, ClauseTemplates.PlayerPositions";
            query2 += " FROM ClauseNodes INNER JOIN";
            query2 += "   ClauseTemplates ON ClauseNodes.ParentClauseID = ClauseTemplates.ID";
            query2 += " WHERE (ClauseNodes.ParentClauseID IN";
            query2 += theSubQuery;
            query2 += " ORDER BY ClauseNodes.ParentClauseID, ClauseNodes.SortOrder";

            sdwDBConnection.Open();
            // Do the lookup
            SqlCommand queryCommand2 = new SqlCommand(query2, sdwDBConnection);  // Create a SqlCommand object
            SqlDataReader queryCommandReader2 = queryCommand2.ExecuteReader();
            DataTable dataTable2 = new DataTable();
            dataTable2.Load(queryCommandReader2);

            // Write the results into a javascript array for use by the client
            String theOutput = string.Empty;
            theOutput += "\r\n\r\n";
            theOutput += "// theDocID = '" + theDocID + "';\r\n";
            theOutput += "// theTitle = '" + theTitle + "';\r\n";
            theOutput += "// thePosition = '" + thePosition + "';\r\n";
            theOutput += "\r\n\r\n";
            theOutput += "// cArr key:\r\n";
            theOutput += "// cArr[\"ClauseID\"][\"SortOrder\"] = \r\n";
            theOutput += "//   0: SortOrder\r\n";
            theOutput += "//   1: Type\r\n";
            theOutput += "//   2: Txt\r\n";
            theOutput += "//   3: FontWeight\r\n";
            theOutput += "//   4: ID\r\n";
            theOutput += "//   5: ParentClauseID\r\n";
            theOutput += "//   6: StartBullet\r\n";
            theOutput += "//   7: EndBullet\r\n";
            theOutput += "//   8: N/A\r\n\r\n";

            theOutput += "var cArr = new Array();\r\n";

            // Print out the data
            string theClauseID = string.Empty;
            for (int i = 0; i < dataTable2.Rows.Count; i++)
            {
                string theNextClauseID = dataTable2.Rows[i]["ParentClauseID"].ToString().Trim();
                if (theNextClauseID != theClauseID)
                {
                    theClauseID = theNextClauseID;
                    theOutput += "cArr[\"" + theClauseID + "\"] = new Array();\r\n";
                    theOutput += "cArr[\"" + theClauseID + "\"][\"Title\"] = \"" + dataTable2.Rows[i]["Title"].ToString().Trim() + "\";\r\n";
                    theOutput += "cArr[\"" + theClauseID + "\"][\"PlayerPositions\"] = \"" + dataTable2.Rows[i]["PlayerPositions"].ToString().Trim() + "\";\r\n";
                }
                
                string theClauseSortOrder = dataTable2.Rows[i]["SortOrder"].ToString().Trim();
                theOutput += "cArr[\"" + theClauseID + "\"][\"" + theClauseSortOrder + "\"] = new Array(";

                theOutput += "\"" + theClauseSortOrder + "\",";
                theOutput += "\"" + dataTable2.Rows[i]["Type"].ToString().Trim() + "\",";
                theOutput += "\"" + dataTable2.Rows[i]["Txt"].ToString().Trim() + "\",";
                theOutput += "\"" + dataTable2.Rows[i]["FontWeight"].ToString().Trim() + "\",";
                theOutput += "\"" + dataTable2.Rows[i]["ID"].ToString().Trim() + "\",";
                theOutput += "\"" + dataTable2.Rows[i]["ParentClauseID"].ToString().Trim() + "\",";
                theOutput += "\"" + dataTable2.Rows[i]["StartBullet"].ToString().Trim() + "\",";
                theOutput += "\"" + dataTable2.Rows[i]["EndBullet"].ToString().Trim() + "\",";

                theOutput += "\"\");\r\n";
            }
            theOutput += "\r\n\r\n";
            // Close the connection
            sdwDBConnection.Close();


            // Lookup the SORT ORDER
            sdwDBConnection.Open();
            // Create the query
            string sortOrderQuery = string.Empty;
            // Sort Order lookup query for a NEW document
            sortOrderQuery += "SELECT ClauseTemplateID FROM PositionTemplates WHERE (Position = '" + thePosition + "') ORDER BY SortOrder";
            if (theDocID != "NEW")
            {
                // Sort Order lookup query for an EXISTING document
                sortOrderQuery = string.Empty;
                sortOrderQuery += "SELECT ClauseTemplateID FROM DocumentClauses WHERE (DocID = '" + theDocID + "') ORDER BY SortOrder";
            }
            // Do the lookup
            SqlCommand queryCommand3 = new SqlCommand(sortOrderQuery, sdwDBConnection);  // Create a SqlCommand object
            SqlDataReader queryCommandReader3 = queryCommand3.ExecuteReader();
            DataTable dataTable3 = new DataTable();
            dataTable3.Load(queryCommandReader3);
            // Add the output
            theOutput += "// Sort array\r\n";
            theOutput += "sortArr = new Array(";
            for (int i = 0; i < dataTable3.Rows.Count; i++)
            {
                theOutput += "'" + dataTable3.Rows[i]["ClauseTemplateID"].ToString().Trim() + "'";
                if (i < (dataTable3.Rows.Count - 1)) { theOutput += ","; }
            }
            theOutput += ");";
            theOutput += "\r\n\r\n";

            // LASTLY --- OUTPUT the results to the page
            databaseResults.InnerHtml = theOutput;

            
        }
    }
}