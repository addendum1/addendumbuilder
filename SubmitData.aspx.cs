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

namespace ContractBuilder1
{
    public partial class SubmitData : System.Web.UI.Page
    {

        Int32 g_newDocID = -1;
        string g_PlainTextUserID = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Make sure the right cookies are in place
            if (LoginHandler.AreTheRightCookiesPresent() == false) { Response.Redirect("./Logout.aspx", true); return; }
            g_PlainTextUserID = HttpContext.Current.Request.Cookies["PTUserID"].Value;

            string theCommand = Command1.Value;
            string theParams = Parameters1.Value;
            if (theCommand != "")
            {
                if (theCommand == "UpdateAddendum")
                {
                    string theID = theParams.Substring(0,theParams.IndexOf("___"));
                    // Make sure the ID is numeric
                    if (IsInteger(theID))
                    {
                        string theData = Data1.Value;
                        theData = theData.Replace("'", "''");  // Double up any single-quotes so that the value can be passed to SQL Server
                        updateAddendum(theParams, theData);
                    }
                }

                if (theCommand == "CreateNewAddendum")
                {
                   string theData = Data1.Value;
                   theData = theData.Replace("'", "''");  // Double up any single-quotes so that the value can be passed to SQL Server
                   bool isOK = CreateNewAddendum(theParams, theData);
                   if (isOK) {
                       Command1.Value = "parent.createNew_Successful('" + g_newDocID + "');";
                       Data1.Value = g_newDocID.ToString();
                   } else {
                       g_newDocID = -1;
                       Command1.Value = "parent.updateFailed();";
                   }
                   //updateAddendum(theParams, theData);
                }



                responseArea.InnerHtml = theCommand;
            }

        }


        protected bool CreateNewAddendum(string theParams, string theXML)
        {
            // Parse out the parameters
            string[] theParamArr = Regex.Split(theParams, @"___");

            string theDocID = theParamArr[0];
            string theStartingClause = theParamArr[1];
            Int32 thePersonID = Convert.ToInt32(theParamArr[2]);
            string thePersonEID = theParamArr[3];
            string thePersonYear = theParamArr[4];
            string theStatus = theParamArr[5];
            Int32 theMaxVal = Convert.ToInt32(theParamArr[6]);
            string theEffectiveDate = theParamArr[7];
            string theDocType = theParamArr[8];
            string theCnNumber = theParamArr[9];
            // Get the database connection string
            string sdwConnectionString = ConfigurationManager.ConnectionStrings["connection187"].ConnectionString;
            SqlConnection sdwDBConnection = new SqlConnection(sdwConnectionString);   // Create a connection
            sdwDBConnection.Open();

            // Insert a new Person if we need to
            if (thePersonID == -2)
            {
                // -2 indicates a NEW user so we have to INSERT it into the database
                string insertPersonSql = "INSERT INTO Peeps (PersonEID, Year) ";
                insertPersonSql += "VALUES ('" + thePersonEID + "','" + thePersonYear + "') ";
                SqlCommand InsertPersonCmd = new SqlCommand(insertPersonSql, sdwDBConnection);
                int theInsertedID = InsertPersonCmd.ExecuteNonQuery();
                // Change thePersonID to -1 to trigger the next section
                thePersonID = -1;
            }
            // Lookup the PersonID if we need to
            if (thePersonID == -1)
            {
                // -1 indicates an existing user, we just need to lookup the ID
                string lookupPeepsIDQuery = string.Empty;
                lookupPeepsIDQuery += "SELECT Id ";
                lookupPeepsIDQuery += "FROM Peeps ";
                lookupPeepsIDQuery += "WHERE PersonEID = '" + thePersonEID + "' ";
                SqlCommand queryCommand1 = new SqlCommand(lookupPeepsIDQuery, sdwDBConnection);  // Create a SqlCommand object
                SqlDataReader queryCommandReader1 = queryCommand1.ExecuteReader();
                DataTable dataTable1 = new DataTable();
                dataTable1.Load(queryCommandReader1);
                if (dataTable1.Rows.Count != 1) {
                    return false;
                } else {
                    for (int i = 0; i < dataTable1.Rows.Count; i++)
                    {
                        thePersonID = Convert.ToInt32(dataTable1.Rows[i]["Id"]);
                    }
                }
            }
            // Insert the new document
            string insertDocSql = "INSERT INTO Docs (PeepID, ActiveAsOf, Status, DocXML, MaxVal, DocType, CreatedDate, CreatedBy, LastUpdatedDate, LastUpdatedBy, CnNum) ";
            insertDocSql += "OUTPUT INSERTED.Id ";
            insertDocSql += "VALUES (";
            insertDocSql += "" + thePersonID.ToString() + ",";
            insertDocSql += "'" + theEffectiveDate + "',";
            insertDocSql += "'" + theStatus + "',";
            insertDocSql += "'" + theXML + "',";
            insertDocSql += "" + theMaxVal.ToString() + ",";
            insertDocSql += "'" + theDocType + "',";
            insertDocSql += "'" + theEffectiveDate + "',";  // created date
            insertDocSql += "'" + g_PlainTextUserID + "',";  // created by
            insertDocSql += "'" + theEffectiveDate + "',";  // last updated date
            insertDocSql += "'" + g_PlainTextUserID + "',";  // last updated by
            insertDocSql += "'" + theCnNumber + "')";
            SqlCommand InsertDocCmd = new SqlCommand(insertDocSql, sdwDBConnection);
            // Execute the query
            SqlDataReader reader2 = InsertDocCmd.ExecuteReader();
            DataTable dataTable2 = new DataTable();
            dataTable2.Load(reader2);

            // The query should return the ID of the newly inserted document
            try { g_newDocID = Convert.ToInt32(dataTable2.Rows[0].ItemArray[0]); } catch {return false;}
            
            // Close the connection
            sdwDBConnection.Close();

            // Check the results
            if (g_newDocID >= 0)  {return true;} else {return false;}
        }




        protected void updateAddendum(string theParams,string theXML)
        {
            // Parse out the parameters
            string[] theParamArr = Regex.Split(theParams, @"___");

            string theDocID = theParamArr[0];
            string theStartingClause = theParamArr[1];
            Int32 thePersonID = Convert.ToInt32(theParamArr[2]);
            string thePersonEID = theParamArr[3];
            string thePersonYear = theParamArr[4];
            string theStatus = theParamArr[5];
            Int32 theMaxVal = Convert.ToInt32(theParamArr[6]);
            string theEffectiveDate = theParamArr[7];
            string theDocType = theParamArr[8];
            string theCnNumber = theParamArr[9];
            // Get the database connection string
            string sdwConnectionString = ConfigurationManager.ConnectionStrings["connection187"].ConnectionString;
            SqlConnection sdwDBConnection = new SqlConnection(sdwConnectionString);   // Create a connection
            sdwDBConnection.Open();
            // Create the query
            string updateSql = "UPDATE Docs " + "SET ";
            updateSql += "PeepID = @thePersonID, ";
            updateSql += "ActiveAsOf = @theEffectiveDate, ";
            updateSql += "Status = @theStatus, ";
            updateSql += "DocXML = @theDocXML, ";
            updateSql += "MaxVal = @theMaxVal, ";
            updateSql += "DocType = @theDocType, ";
            updateSql += "LastUpdatedDate = @theLastUpdatedDate, ";
            updateSql += "LastUpdatedBy = @theLastUpdatedBy, ";
            updateSql += "CnNum = @theCnNumber ";
            updateSql += "WHERE Id = @theDocID";
            SqlCommand UpdateCmd = new SqlCommand(updateSql, sdwDBConnection);
            // Define Parameters
            UpdateCmd.Parameters.Add("@thePersonID", SqlDbType.Int);
            UpdateCmd.Parameters.Add("@theEffectiveDate", SqlDbType.NVarChar, 50);
            UpdateCmd.Parameters.Add("@theStatus", SqlDbType.NVarChar, 50);
            UpdateCmd.Parameters.Add("@theDocXML", SqlDbType.NVarChar, -1);
            UpdateCmd.Parameters.Add("@theMaxVal", SqlDbType.Int);
            UpdateCmd.Parameters.Add("@theDocType", SqlDbType.NVarChar, 50);
            UpdateCmd.Parameters.Add("@theLastUpdatedDate", SqlDbType.NVarChar, 50);
            UpdateCmd.Parameters.Add("@theLastUpdatedBy", SqlDbType.NVarChar, 50);
            UpdateCmd.Parameters.Add("@theDocID", SqlDbType.Int);
            UpdateCmd.Parameters.Add("@theCnNumber", SqlDbType.NVarChar, 50);
            // Assign values
            UpdateCmd.Parameters["@thePersonID"].Value = thePersonID;
            UpdateCmd.Parameters["@theEffectiveDate"].Value = theEffectiveDate;
            UpdateCmd.Parameters["@theStatus"].Value = theStatus;
            UpdateCmd.Parameters["@theDocXML"].Value = theXML;
            UpdateCmd.Parameters["@theMaxVal"].Value = theMaxVal;
            UpdateCmd.Parameters["@theDocType"].Value = theDocType;
            UpdateCmd.Parameters["@theLastUpdatedDate"].Value = getTodaysDate();
            string lastUpdatedByValue = g_PlainTextUserID;
            UpdateCmd.Parameters["@theLastUpdatedBy"].Value = lastUpdatedByValue;
            UpdateCmd.Parameters["@theDocID"].Value = theDocID;
            UpdateCmd.Parameters["@theCnNumber"].Value = theCnNumber;
            // Execute the query
            int recordsUpdated = UpdateCmd.ExecuteNonQuery();
            // Check the results
            if (recordsUpdated > 0)
            {
                Command1.Value = "parent.updateSuccessful();";
                Data1.Value = recordsUpdated.ToString();
            }
            else
            {
                Command1.Value = "parent.updateFailed();";
                Data1.Value = recordsUpdated.ToString();
            }
            // Close the connection
            sdwDBConnection.Close();
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

        public static bool IsInteger(string theValue)
        {
            try
            {
                Convert.ToInt32(theValue);
                return true;
            }
            catch
            {
                return false;
            }
        } //IsInteger


        protected void submitButton_Click(object sender, EventArgs e)
        {

            
        }


    }
}