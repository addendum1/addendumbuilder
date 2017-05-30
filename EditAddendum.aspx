<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditAddendum.aspx.cs" Inherits="ContractBuilder1.EditAddendum" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<title>Edit Addendum</title>

<link href="./styles/defaultStyles.css" type="text/css" rel="stylesheet" />

<script src="./crypt/rollups/aes.js"></script>
<script src="./crypt/rollups/sha256.js"></script>

<script type="text/javascript" src="./scripts/generalUtilityScripts.js"></script>
<script type="text/javascript" src="./scripts/convertNumberToWords.js"></script>
<script type="text/javascript" src="./scripts/Standard2014_Word_Body.js"></script>
<!-- <script type="text/javascript" src="./scripts/ExportFormats/rb_Standard2014_Word_HeaderFooter.js"></script> -->

<script type="text/javascript" src="./scripts/CibulCalendar/CibulCalendar.min.js"></script>
    

<script src="./scripts/downloadify/downloadify.js" type="text/javascript"></script>
<script src="./scripts/downloadify/swfobject.js" type="text/javascript"></script>

<style type="text/css">

    .datePickerIcon {position: relative; top: 3px; cursor: pointer; border: 1px solid white; width: 12px; height: 13px;}
    .datePickerIcon:hover {border: 1px solid #333333;}

      .ccal { width: 18em; font-size: 0.8em; margin-bottom: 5px;}
      .ccal ul { margin: 0; padding: 0!important; text-align: center; }
      .ccal li { list-style-type: none; display: inline-block; width: 13.2%; cursor: pointer; text-align: center; margin:0; }
      .ccal li span { display: inline-block; line-height: 1.8em; }
      .ccal li.calmonth { width: 66%; }
      .ccal li span { padding: 0.1em 0.05em; display: block; }
      .ccal li.calprev span, .ccal li.calnext span { color: #aaa; }
      .ccal .calbody li.selected span { background: #666; color: white; }
      .ccal .calbody li.preselected span { background: #f0f0f0; }
      .ccal * { -moz-user-select: -moz-none; -khtml-user-select: none; -webkit-user-select: none; -ms-user-select: none; user-select: none; }
      .today { font-weight: bold; }
      .calendar-canvas { 
        text-align: center;
        background: white;
        v-moz-box-shadow: 0 3px 4px #999999; 
        -moz-box-shadow: 0 3px 4px #999999; 
        -webkit-box-shadow: 0 3px 4px #999999; 
        box-shadow: 0 1px 2px #999999;
      }

td {
  text-align: left;
  padding: 4px;
  vertical-align: top;
}

button {
  cursor: pointer;
  background: black;
  color: white;
  border: 0px;
  padding: 2px;
}

    .deleteClauseFromTemplateLink {
        color: #BBBBBB;
        font-size: 10px;
        text-decoration: none;
    }

    .deleteClauseFromTemplateLink:hover {
        color: blue;
        font-size: 10px;
        text-decoration: underline;
    }

.fieldLabel {
    color: #3c3c3c;
}

.personNameText {
  width: 890px;
  margin-left: auto;
  margin-right: auto;
  text-align: left;
  font-size: 30px;
  font-weight: bold;
  height: 50px;
  padding: 0px;
  border: 0px;
}

.auditText {
    font-size: 10px;
    color: #999999;
}

.templateEditorTableHeaderText {
    font-family: "Arial Narrow", Arial, Sans-Serif;
    font-weight: normal;
    vertical-align: middle;
    font-style: italic;
}

.ClauseNormal {font-weight: normal; font-family: "Arial Narrow", Arial, Sans-Serif;}
.ClauseBold {font-weight: bold; font-family: "Arial Narrow", Arial, Sans-Serif;}
.ClauseBoldUnderlined {font-weight: bold; text-decoration: underline; font-family: "Arial Narrow", Arial, Sans-Serif;}

.ClauseAmount {width: 45px; text-align: center; font-weight: normal; background: #d7e3bb;}
.ClauseAmount_txt {font-weight: bold; font-family: "Arial Narrow", Arial, Sans-Serif;}

.cl_Normal {font-weight: normal; font-family: "Arial Narrow", Arial, Sans-Serif;}
.cl_Bold {font-weight: bold; font-family: "Arial Narrow", Arial, Sans-Serif;}

.amount_Normal {width: 45px; text-align: center; font-weight: normal; background: #66BaB1;}


#popupMenu_AddClauseInner {
  background: #999999;
  border: 1px solid #333333;
  font-family: Arial, Sans-Serif;
  font-style: italic;
  padding: 8px;
  margin: 0px;
  text-align: center;
}

#popupMenu_RemoveClauseInner {
  background: #999999;
  border: 1px solid #333333;
  font-family: Arial, Sans-Serif;
  font-style: italic;
  padding: 4px;
  margin: 0px;
  text-align: center;
}

#popupMenu_CloseDocumentInner {
  background: #999999;
  border: 1px solid #333333;
  font-family: Arial, Sans-Serif;
  font-style: italic;
  padding: 4px;
  margin: 0px;
  text-align: center;
}

#popupMenu_AssignContractNumber {
  width: 350px;
  background: #999999;
  border: 1px solid #333333;
  font-family: Arial, Sans-Serif;
  padding: 7px;
  margin: 0px;
  text-align: center;
}

#popupMenu_SelectContractDate {
  background: #888888;
  border: 1px solid #333333;
  font-family: Arial, Sans-Serif;
  padding: 7px;
  margin: 0px;
  text-align: center;
}

</style>


    <script type="text/javascript">

        // Global variables
        g_startingClause = 0;
        gXMLDoc = "";
        gTemplateDoc = "";
        g_PersonName = "";
        g_MaxVal = 0;
        g_currentlyEditedClause = 0;
        g_contractNumber = "TBD";

        g_andThenClose = false;

        g_exportToWordInProgress = false;  // associated to the OLD server-based export process
        


        function doOnLoad() {
            var xmlText = document.getElementById("Hidden_DocXML").value;
            if (g_DocID == "MainTemplate") {
                g_DocID = mt_DocID;
                g_DocType = mt_DocType;
                xmlText = document.getElementById("Hidden_AllClauses").value;
            }
            // Unencrypt Person Name
            g_PersonName = unencryptItem(g_PersonEID);
            // Load the XML doc
            xmlText = unencryptItem(xmlText);
            xmlText = xmlText.replace(/\'\'/g, "'");
            if (window.DOMParser) {
                parser = new DOMParser();
                gXMLDoc = parser.parseFromString(xmlText, "text/xml");
            } else {
                // Older Internet Explorer
                gXMLDoc = new ActiveXObject("Microsoft.XMLDOM");
                gXMLDoc.async = false;
                gXMLDoc.loadXML(xmlText);
            }
            // Load the Template doc
            var templateText = document.getElementById("Hidden_AllClauses").value;
            templateText = unencryptItem(templateText);
            templateText = templateText.replace(/\'\'/g, "'");
            if (window.DOMParser) {
                parser = new DOMParser();
                gTemplateDoc = parser.parseFromString(templateText, "text/xml");
            } else {
                // Older Internet Explorer
                gTemplateDoc = new ActiveXObject("Microsoft.XMLDOM");
                gTemplateDoc.async = false;
                gTemplateDoc.loadXML(templateText);
            }
            // Finish up the display
            if (g_DocType=="A_mainTemplate") {
                displayTemplateProperties("N/A");
                var theMsg = 'The Template Editor allows you to edit the master templates of each Clause.<br/><br/>';
                theMsg += 'Please select a Clause from the dropdown list above to begin editing.';
                clearDocumentArea(theMsg);
                var theNodes = gXMLDoc.getElementsByTagName("Addendum");
                var theNode = theNodes[0];
                g_PersonID = theNode.getAttribute("PersonID");
                g_PersonEID = theNode.getAttribute("PersonEID");
                g_PersonYear = theNode.getAttribute("PersonYear");
            } else {
                document.getElementById('btnExportToWord').style.visibility = "visible";
                document.getElementById('btnDeleteExisting').style.visibility = "visible";
                displayDocumentProperties();
                updateClauseTable();
                // Initialize the datepicker control
                var cal = new CibulCalendar(document.getElementById('getContractDate'), {
                    firstDayOfWeek: 0,
                    range: false,
                    onSelect: function (selected) {
                        handleContractDateChange(selected);
                    }
                });
            }
            // If this is a brand new document, finalize a couple of changes and save
            var theNodes = gXMLDoc.getElementsByTagName("Addendum");
            var addendumNode = theNodes[0];
            if (addendumNode.getAttribute("DocID") == "NEW") {
                addendumNode.setAttribute("DocID", g_DocID);
                addendumNode.setAttribute("PersonID", g_PersonID);
                saveDocument();
            }
            // Initialize the downloadify component
            if (g_DocType != "A_mainTemplate") {
                Downloadify.create('downloadify', {
                    filename: function () { return buildWordFilename(); },
                    data: function () { return buildWordDoc(); },
                    dataType: "string",
                    onComplete: function () { return; },
                    onCancel: function () { return; },
                    onError: function () { alert('The system has encountered an error while processing your request.\n\nIf the problem persists, please contact the system administrators.'); },
                    swf: './scripts/downloadify/downloadify1.swf',
                    downloadImage: './img/WordDownload1.png',
                    width: 112,
                    height: 14,
                    transparent: false,
                    append: false
                });
            }            
        }


        function handleContractDateChange(theDate) {
            var theYear = theDate.getFullYear();
            var theMonth = padWithZeros(theDate.getMonth() + 1, 2);
            var theDay = padWithZeros(theDate.getDate(), 2);
            var theVal = theYear + "-" + theMonth + "-" + theDay ;
            document.getElementById("contractDate").value = theVal;
            // Update the xml doc
            var theNodes = gXMLDoc.getElementsByTagName("Addendum");
            var addendumNode = theNodes[0];
            addendumNode.setAttribute("EffectiveDate", theVal);
            hideAllPopups();
            displayDocumentProperties();
        }


        function convertDateToDisplayFormat(lexDate) {
            try {
                var dArr = lexDate.split("-");
                var theYear = dArr[0];
                var theMonth = parseInt(dArr[1],10);
                var theDay = dArr[2];
                var allMonths = new Array("","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
                var wordMonth = allMonths[theMonth];
                return theDay + "-" + wordMonth + "-" + theYear;
            } catch(er) {
                return lexDate;
            }
        }


        function buildWordFilename() {
            var theNodes = gXMLDoc.getElementsByTagName("Addendum");
            var theNode = theNodes[0];
            var theEffectiveDate = theNode.getAttribute("EffectiveDate");
            var theFilename = g_PersonName + " " + g_contractNumber + ", " + convertDateToDisplayFormat(theEffectiveDate) + ".xml";
            return theFilename;
        }


        function getFullMonthForExport(theLexDate) {
            var retMonth = "__________";
            var monthArr = new Array("", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
            try {
                var monthNum = parseInt(theLexDate.split("-")[1],10);
                retMonth = monthArr[monthNum];
            } catch (er) { }
            return retMonth;
        }

        function getDaySuffixForExport(theDy) {
            var retSuffix = "";
            var suffixArr = new Array("", "st","nd","rd","th","th","th","th","th","th","th","th","th","th","th","th","th","th","th","th","th","st","nd","rd","th","th","th","th","th","th","th","st");
            try {
                retSuffix = suffixArr[parseInt(theDy, 10)];
            } catch (er) { }
            return retSuffix;
        }


        function buildWordDoc() {
            var theNodes = gXMLDoc.getElementsByTagName("Addendum");
            var theNode = theNodes[0];
            var theEffectiveDate = theNode.getAttribute("EffectiveDate");
            var dispPersonName = g_PersonName;
            if (g_PersonName.indexOf(",") >= 0) {
                var firstName = trimThis(g_PersonName.split(",")[1]);
                var lastName = trimThis(g_PersonName.split(",")[0]);
                dispPersonName = firstName + " " + lastName;
            }
            // Update the values in the header and footer (stored in separate js file)
            var theYear = new Date().getFullYear();
            try { theYear = theEffectiveDate.substring(0, theEffectiveDate.indexOf("-")); } catch (er) { }
            var theFullMonth = getFullMonthForExport(theEffectiveDate);
            var theDay = "___";
            try { theDay = parseInt(theEffectiveDate.split("-")[2],10); } catch (er) { }
            var theDaySuffix = getDaySuffixForExport(theDay);

            var longDocHeader = document.getElementById('Hidden_ExportTemplateHeader').value;

            longDocHeader = longDocHeader.replace(/!!!YEAR!!!/g, theYear);
            longDocHeader = longDocHeader.replace(/!!!FULLMONTH!!!/g, theFullMonth);
            longDocHeader = longDocHeader.replace(/!!!DAY!!!/g, theDay);

            longDocHeader = longDocHeader.replace(/!!!PLAYERNAME!!!/g, dispPersonName);
            longDocHeader = longDocHeader.replace(/!!!CONTRACTNUMBER!!!/g, g_contractNumber);

            var longDocFooter = document.getElementById('Hidden_ExportTemplateFooter').value;

            longDocFooter = longDocFooter.replace(/!!!YEAR!!!/g, theYear);
            longDocFooter = longDocFooter.replace(/!!!FULLMONTH!!!/g, theFullMonth);
            longDocFooter = longDocFooter.replace(/!!!DAY!!!/g, theDay);
            longDocFooter = longDocFooter.replace(/!!!DAYSUFFIX!!!/g, theDaySuffix);

            longDocFooter = longDocFooter.replace(/!!!COMPANY!!!/g, "Not Specified");
            longDocFooter = longDocFooter.replace(/!!!CREATEDBY!!!/g, "Not Specified");
            longDocFooter = longDocFooter.replace(/!!!LASTMODIFIEDBY!!!/g, "Not Specified");

            longDocFooter = longDocFooter.replace(/!!!STARTINGCLAUSENUMBER!!!/g, g_startingClause);
            
            // Start building the output
            var theOutput = longDocHeader;

            // Loop through each Clause
            var clauseCount = parseInt(g_startingClause,10);
            var theNodes = gXMLDoc.getElementsByTagName("Clause");
            for (var i = 0; i < theNodes.length; i++) {
                var clauseNode = theNodes[i];

                // Add an opening paragraph
                theOutput += '<w:p w:rsidR="00B3718E" w:rsidRPr="00AB07D0" w:rsidRDefault="00B3718E" w:rsidP="00A276C3">';

                // Add the Clause Number
                theOutput += clauseFormatBeforeClause();

                var bulletOn = false;
                // Add each SubClause
                for (var k = 0; k < clauseNode.childNodes.length; k++) {
                    var theSubNode = clauseNode.childNodes[k];
                    if (theSubNode.nodeType !== 1) { continue; }  // we only care about nodes of type Node.ELEMENT_NODE
                    var theClass = theSubNode.getAttribute("Class");
                    var theSubClauseTxt = theSubNode.getAttribute("Txt");
                    var theAmountInWords = "";

                    // If this is the start of a sub-bullet...
                    var isBulletStart = theSubNode.getAttribute("StartBullet");
                    if (isBulletStart == "True") {
                        bulletOn = true;
                        theOutput += "</w:p>";
                        theOutput += '<w:p w:rsidR="00AB07D0" w:rsidRPr="00AB07D0" w:rsidRDefault="00AB07D0" w:rsidP="00A276C3">';
                        theOutput += clauseFormatBeforeBullet();
                    }                    

                    // Add the subclause text
                    switch (theClass)
                    {
                        case "ClauseBold":
                            theOutput += buildClause_Bold(theSubClauseTxt);
                            break;
                        case "ClauseBoldUnderlined":
                            theOutput += buildClause_BoldUnderlined(theSubClauseTxt);
                            break;
                        case "ClauseAmount":
                            theAmountInWords = theSubNode.getAttribute("AmountWords");
                            theOutput += buildClause_Amount(theSubClauseTxt,theAmountInWords);
                            break;
                        default:
                            theOutput += buildClause_Normal(theSubClauseTxt);
                            break;
                    }

                    // Add spaces
                    var theLastChar = theSubClauseTxt.charAt(theSubClauseTxt.length - 1);
                    // If the subclause ends with a period, add 2 spaces
                    if (theLastChar == ".") {
                        theOutput += addSpaces(2);
                    } else {
                        // Get the next node
                        var maxTries = 10;
                        var nextCount = 0;
                        while (nextCount < maxTries) {
                            nextCount++;
                            var nextSubClause = clauseNode.childNodes[k + nextCount];
                            if (nextSubClause != null) {
                                if (nextSubClause.nodeType == 1) {
                                    var firstChar = nextSubClause.getAttribute("Txt").substring(0, 1);
                                    if ((firstChar != ".") && (firstChar != ",")) {
                                        theOutput += addSpaces(1);
                                    }
                                    break;
                                }
                            }
                        }
                    }

                    // If this is the end of a sub-bullet...
                    var isBulletEnd = theSubNode.getAttribute("EndBullet");
                    if (isBulletEnd == "True") {
                        bulletOn = false;
                        theOutput += "</w:p>";
                        theOutput += '<w:p w:rsidR="00B3718E" w:rsidRPr="00AB07D0" w:rsidRDefault="00B3718E" w:rsidP="00A276C3"><w:pPr><w:ind w:left="450"/></w:pPr>';
                    }

                }

                // Close the Clause paragraph
                theOutput += '</w:p>';
                theOutput += clauseFormatAfterClause();

                // Update the counter
                clauseCount = clauseCount + 1;
            }

            // Remove any artifacts of the bulleting process
            var theArtifact = '<w:p w:rsidR="00B3718E" w:rsidRPr="00AB07D0" w:rsidRDefault="00B3718E" w:rsidP="00A276C3"><w:pPr><w:ind w:left="450"/></w:pPr></w:p>';
            theOutput = theOutput.replace(new RegExp(theArtifact, "g"), "");

            theOutput += longDocFooter;
            return theOutput;
        }




  // ## GENERAL/SHARED FUNCTIONS #######################################################################################################################


        function closeDocument() {
          g_andThenClose = true;
          saveDocument();
        }

        function closeDocument_finish() {
            document.location = "./AddendumBuilder.aspx";
        }


        function clearDocumentArea(theMsg) {
            document.getElementById("centeringDiv").innerHTML = '<div style="font-style: italic; text-align: left;"><br/>' + theMsg + '</div>';
        }


        function hideAllPopups() {
            hideAddClausePopup();
            hideRemoveClausePopup();
            hideAssignContractNumberPopup();
            hideSelectContractDatePopup();
            hideCloseDocumentPopup();
        }

        function hideAddClausePopup() {document.getElementById('popupMenu_AddClause').style.display = "none";}

        function hideRemoveClausePopup() { document.getElementById('popupMenu_RemoveClause').style.display = "none"; }

        function hideCloseDocumentPopup() { document.getElementById('popupMenu_CloseDocument').style.display = "none"; }

        function hideAssignContractNumberPopup() { document.getElementById('popupMenu_AssignContractNumber').style.display = "none"; }

        function hideSelectContractDatePopup() { document.getElementById('popupMenu_SelectContractDate').style.display = "none"; }

        function showRemoveClausePopup(event, theClauseNumber, theTitle) {
            var el, x, y;
            el = document.getElementById('popupMenu_RemoveClause');
            if (window.event) {
                x = window.event.clientX + document.documentElement.scrollLeft + document.body.scrollLeft;
                y = window.event.clientY + document.documentElement.scrollTop + document.body.scrollTop;
            } else {
                x = event.clientX + window.scrollX;
                y = event.clientY + window.scrollY;
            }
            x -= 2; y -= 2; y = y + 10;
            el.style.left = x + "px";
            el.style.top = y + "px";

            var theOutput = '<div style="line-height: 25px;">Remove Clause (' + theTitle + ')?</div>';
            theOutput += '<button type="button" onclick="removeClause_Finish(' + theClauseNumber + ');">Remove</button>&nbsp;&nbsp;&nbsp;';
            theOutput += '<button type="button" onclick="hideRemoveClausePopup();">Cancel</button>';
            document.getElementById('popupMenu_RemoveClauseInner').innerHTML = theOutput;

            el.style.display = "block";
        }


        function showCloseDocumentPopup(event) {
            var el, x, y;
            el = document.getElementById('popupMenu_CloseDocument');
            if (window.event) {
                x = window.event.clientX + document.documentElement.scrollLeft + document.body.scrollLeft;
            } else {
                x = event.clientX + window.scrollX;
            }
            x -= 10;
            y = 115;
            el.style.left = x + "px";
            el.style.top = y + "px";
            var theOutput = '<div style="width: 100%; text-align: left; line-height: 24px; font-family: Arial, Sans-Serif; font-size: 12px; font-style: italic;">Close the Document...</div>';
            theOutput += '<button type="button" onclick="closeDocument();">Save and Close</button>&nbsp;&nbsp;&nbsp;';
            theOutput += '<button type="button" onclick="closeDocument_finish();">Close without Saving</button>&nbsp;&nbsp;&nbsp;';
            theOutput += '<button type="button" onclick="hideCloseDocumentPopup();">Cancel</button>';
            document.getElementById('popupMenu_CloseDocumentInner').innerHTML = theOutput;

            el.style.display = "block";
        }


        function assembleClause(clauseNode, clauseNumber, isPreview) {
            var theOutput = "";
            var clauseCount = -1;
            for (var k = 0; k < clauseNode.childNodes.length; k++) {
                var theSubNode = clauseNode.childNodes[k];
                if (theSubNode.nodeType !== 1) { continue; }  // we only care about nodes of type Node.ELEMENT_NODE
                // Make sure the subnode has an ID
                clauseCount = clauseCount + 1;
                var theSubNodeID = clauseNumber + "_" + clauseCount;
                theSubNode.setAttribute("SubClauseID", theSubNodeID);
                // Gather the basics from the subnode
                var theType = theSubNode.getAttribute("Type");
                var theClass = theSubNode.getAttribute("Class");
                var startBullet = theSubNode.getAttribute("StartBullet");
                var endBullet = theSubNode.getAttribute("EndBullet");
                var theTxt = theSubNode.getAttribute("Txt");
                // If this is starting a sub-bullet...
                if (startBullet == "True") { theOutput += "<ul><li>"; }

                // Calculate spaces
                var theTrailingSpaces = "&nbsp;";
                var theLastChar = theTxt.charAt(theTxt.length - 1);
                // If the subclause ends with a period, add 2 spaces
                if (theLastChar == ".") {
                    theTrailingSpaces = "&nbsp;&nbsp;";
                } else {
                    var nextSubClauseNode = clauseNode.childNodes[k + 1];
                    if (typeof (nextSubClauseNode) != "undefined") {
                        if (nextSubClauseNode.nodeType == 1) {
                            var firstChar = nextSubClauseNode.getAttribute("Txt").substring(0, 1);
                            if ((firstChar == ".") && (firstChar == ",")) {
                                theTrailingSpaces = "";
                            }
                        }
                    }
                }

                // Output for AMOUNT
                if (theType == "Amount") {
                    var theSpanID = theType + '_' + clauseNumber + '_' + k;
                    var theAmountTxt = toWords(theTxt) + "Dollars ";
                    theAmountTxt = capitalizeFirstLetterOfEachWord(theAmountTxt);
                    theSubNode.setAttribute("AmountWords", theAmountTxt);
                    theOutput += '<span id="txt_' + theSpanID + '" class="' + theClass + '_txt">' + theAmountTxt + '</span>';
                    var isDisabled = "";
                    var theEvent = ' onblur="handleAmountChange(this,\'' + theSubNodeID + '\',\'' + theTxt + '\');" ';
                    if (isPreview) { isDisabled = ' disabled="true" '; theEvent = ""; }
                    theOutput += '<span style="white-space:nowrap;"><span style="font-weight: bold;"> ($</span><input id="' + theSpanID + '" ' + theEvent + ' ' + isDisabled + ' class="' + theClass + '" value="' + theTxt + '" maxlength="7"/><span style="font-weight: bold;">)</span>' + theTrailingSpaces + '</span>';
                } else {
                    // Anything else treat as TEXT
                    theOutput += '<span class="' + theClass + '">' + theTxt + '</span>' + theTrailingSpaces;
                }
                // If this is ending a sub-bullet...
                if (endBullet == "True") { theOutput += "</li></ul>"; }
            }
            theOutput = theOutput.replace(/\<\/ul\>\<ul\>/g, "");  // remove any unwanted artifacts from sub-bullets
            return theOutput;
        }


        function saveDocument() {
            // Serialize and encrypt the in-memory XML document
            var xmlText = xml2Str(gXMLDoc);
            xmlText = encryptItem(xmlText);
            // Pull a few values from the XML document
            var theNodes = gXMLDoc.getElementsByTagName("Addendum");
            var theNode = theNodes[0];
            var theStatus = theNode.getAttribute("Status");
            var theStartingClause = theNode.getAttribute("StartingClause");
            var theEffectiveDate = theNode.getAttribute("EffectiveDate");
            var theCnNumber = theNode.getAttribute("CnNumber");
            // Assemble all of the parameters
            var paramArr = new Array();
            paramArr.push(g_DocID);
            paramArr.push(theStartingClause);
            paramArr.push(g_PersonID);
            paramArr.push(g_PersonEID);
            paramArr.push(g_PersonYear);
            paramArr.push(theStatus);
            paramArr.push(g_MaxVal);
            paramArr.push(theEffectiveDate);
            paramArr.push(g_DocType);
            paramArr.push(theCnNumber);
            var theParams = paramArr.join("___");
            // Submit the data
            var theFrameDoc = document.getElementById("submitFormFrame").contentWindow;
            theFrameDoc.document.getElementById("Command1").value = "UpdateAddendum";
            theFrameDoc.document.getElementById("Parameters1").value = theParams;
            theFrameDoc.document.getElementById("Data1").value = xmlText;
            document.getElementById("statusMessage").innerHTML = "Saving...&nbsp;&nbsp;&nbsp;";
            setTimeout("document.getElementById('submitFormFrame').contentWindow.saveDocument3();", 15);
        }


        function updateSuccessful() {
            if (g_andThenClose) {
                document.getElementById("statusMessage").innerHTML = '<span style="background: #CCCCCC;">Save was successful... closing document...</span>';
                setTimeout("closeDocument_finish();", 200);
            } else {
                document.getElementById("statusMessage").innerHTML = '<span style="background: #CCCCCC;">Save was successful.</span>';
                setTimeout("clearStatusMessage();", 3000);
            }
        }


        function handleWindowResize() {
            hideAllPopups();
        }



  // ## TEMPLATE/SUBCLAUSE FUNCTIONS #######################################################################################################################

        function displayTemplateProperties(selectThisOptionByUUID) {
            // Load the template properties from the XML doc
            var theNodes = gXMLDoc.getElementsByTagName("Addendum");
            var theNode = theNodes[0];

            var theDocID = theNode.getAttribute("DocID");

            // Build the Properties section
            var theProp = '<br/><div class="personNameText">Template Editor</div>';
            theProp += '<table style="width: 750px; border: 0px; padding: 0px; spacing: 0px; margin: 0px; margin-left: 50px; border-collapse: collapse;">';
            theProp += '<tr>';
            theProp += '<td style="width: 153px; valign="top"><div class="fieldLabel" style="font-style: italic;">Clause to Edit:</div></td>';
            theProp += '<td style="width: 300px;"><select style="width: 300px;" id="editClauseDropdown" size="5" onchange="handleEditClauseDropdownChange(this);">';
            theProp += '<option style="font-style: italic;" value="">Select a clause to edit...</option>';
            var clauseNodes = gXMLDoc.getElementsByTagName("Clause");
            for (var i = 0; i < clauseNodes.length; i++) {
                var theTitle = clauseNodes[i].getAttribute("Title");
                var isSelected = "";
                if (clauseNodes[i].getAttribute("UUID") == selectThisOptionByUUID) {isSelected = ' SELECTED="true"';}
                theProp += '<option value="' + i + '" ' + isSelected + ' >' + theTitle + '</option>';
            }
            theProp += '</select></td>'

            theProp += '<td style="width: 297px; padding: 10px; padding-top: 5px; text-align: left;" valign="middle">';
            theProp += '<span id="templateCopyClauseButton" style="visibility: hidden;"><a href="javascript: void(0);" onclick="template_copyATemplateClause();"><img style="width: 16px; height: 16px; cursor: pointer; margin-right: 5px; border: 0px;" title="Move Up" alt="^" src="./img/copyIcon.png" />Copy Selected Clause</a></span><br/><br/>';
            theProp += '<span id="templateMoveUpButton" style="visibility: hidden;"><a href="javascript: void(0);" onclick="moveClauseUp(g_currentlyEditedClause,\'TEMPLATE\');"><img style="width: 15px; height: 8px; cursor: pointer; margin-right: 5px; border: 0px;" title="Move Up" alt="^" src="./img/arrowUp.png" />Move Clause Up</a></span><br/><br/>';
            theProp += '<span id="templateMoveDownButton" style="visibility: hidden;"><a href="javascript: void(0);" onclick="moveClauseDown(g_currentlyEditedClause,\'TEMPLATE\');"><img style="width: 15px; height: 8px; cursor: pointer; margin-right: 5px; border: 0px;" title="Move Down" alt="^" src="./img/arrowDown.png" />Move Clause Down</a></span><br/>';
            theProp += '</td>';

            theProp += '</tr>';
            theProp += '<tr><td>&nbsp;</td><td>or <a href="javascript:void(0);" onclick="addNewTemplateClause();">Add a New Clause</a></td></tr>';
            theProp += '</table>';
            document.getElementById('documentPropertiesDiv').innerHTML = theProp;
        }

        

        function updateClauseEditorTable() {
            // Start building the clause table
            var theOutput = '<br/><table style="width: 900px; border: 0px; padding: 0px; spacing: 0px; border-collapse: collapse;">';
            // Load the clauses from the XML doc
            var allClauseNodes = gXMLDoc.getElementsByTagName("Clause");
            var theSelectedClauseNode = allClauseNodes[g_currentlyEditedClause];
            var childNodeCount = -1;

            // Add the Title and associated templates fields
            var theTitle = theSelectedClauseNode.getAttribute("Title");
            theOutput += '<tr><td colspan="2" class="fieldLabel" style="font-style: italic; padding-top: 8px;">Clause Title:</td>';
            theOutput += '<td><input onblur="handleSubClauseTitleChange(this);" style="width: 95%;" class="ClauseNormal" type="text" id="ClauseTitle_' + g_currentlyEditedClause + '" value="' + theTitle + '" />';
            theOutput += '<div style="width: 95%; text-align: right;"><a class="deleteClauseFromTemplateLink" href="javascript:void(0);" onclick="showRemoveClausePopup(event, \'' + g_currentlyEditedClause + '\', \'' + theTitle + '\');">Delete this Clause from the Template</a></div>';
            theOutput += '<br/></td></tr>';

            // Build a preview of the Clause
            var thePreview = assembleClause(theSelectedClauseNode, g_currentlyEditedClause, true);
            theOutput += '<tr><td colspan="2" class="fieldLabel" style="font-style: italic;">Clause Preview:</td>';
            theOutput += '<td colspan="2"><div style="width: 458px; word-wrap: break-word; background: white; padding: 6px;">' + thePreview + '</div></td>';
            theOutput += '</tr>';

            theOutput += '<tr><td colspan="8" style="border: 0px; border-bottom: 1px solid #3f3f3f;">&nbsp;</td></tr>';
            theOutput += '<tr><td colspan="8">&nbsp;</td></tr>';

            theOutput += '<tr><td class="templateEditorTableHeaderText" style="width: 75px; text-align: center;">#</td>';
            theOutput += '<td class="templateEditorTableHeaderText" style="width: 100px;">Type</td>';
            theOutput += '<td class="templateEditorTableHeaderText" style="width: 575px;">Text / Default Value</td>';
            theOutput += '<td class="templateEditorTableHeaderText" style="width: 50px;">Style</td>';
            theOutput += '<td class="templateEditorTableHeaderText" style="width: 50px;">Start Bullet?</td>';
            theOutput += '<td class="templateEditorTableHeaderText" style="width: 50px;">End Bullet?</td></tr>';

            // Build the subclause table
            for (var i = 0; i < theSelectedClauseNode.childNodes.length; i++) {
                var subClauseNode = theSelectedClauseNode.childNodes[i];
                if (subClauseNode.nodeType !== 1) { continue; }  // we only care about nodes of type Node.ELEMENT_NODE
                childNodeCount = childNodeCount + 1;
                var subClauseNumber = g_currentlyEditedClause + "_" + childNodeCount;
                subClauseNode.setAttribute("SubClauseID", subClauseNumber);
                // Gather the basics from the subnode
                var theType = subClauseNode.getAttribute("Type");
                var theClass = subClauseNode.getAttribute("Class");
                var startBullet = subClauseNode.getAttribute("StartBullet");
                var endBullet = subClauseNode.getAttribute("EndBullet");
                var theTxt = subClauseNode.getAttribute("Txt");
                theOutput += '<tr>';
                // Number
                theOutput += '<td style="text-align: center;">';
                if (i == 0) {
                    theOutput += '<br/>';
                } else {
                    theOutput += '<img style="width: 15px; height: 8px; cursor: pointer;" title="Move Up" onclick="moveSubClauseUp(\'' + subClauseNumber + '\');" alt="^" src="./img/arrowUp.png" /><br/>';
                }
                theOutput += '<img style="cursor: pointer; width: 10px; height: 10px;" title="Insert a New SubClause" alt="+" src="./img/addIcon.png" onclick="insertSubClause(\'' + subClauseNumber + '\');" onmouseover="this.src=\'./img/addIconOn.png\';" onmouseout="this.src=\'./img/addIcon.png\';" />';
                theOutput += '&nbsp;&nbsp;' + (childNodeCount+1) + '&nbsp;&nbsp;';
                theOutput += '<img style="cursor: pointer; width: 10px; height: 10px;" title="Remove This SubClause" alt="-" src="./img/removeIcon.png" onclick="removeSubClause(\'' + subClauseNumber + '\',\'' + theType + '\');" onmouseover="this.src=\'./img/removeIconOn.png\';" onmouseout="this.src=\'./img/removeIcon.png\';" /><br/>';
                if (i == (theSelectedClauseNode.childNodes.length - 1)) {
                    theOutput += '<br/>';
                } else {
                    theOutput += '<img style="width: 15px; height: 8px; cursor: pointer;" title="Move Down" onclick="moveSubClauseDown(\'' + subClauseNumber + '\');" alt="\/" src="./img/arrowDown.png" />';
                }
                // Type
                theOutput += '<td><br/>';
                theOutput += '<select id="TypeDropdown_' + i + '" onchange="handleSubClauseTypeChange(this,\'' + subClauseNumber + '\');" >';
                if (theType == "Text") { theOutput += '<option value="Text" selected="true">Text</option>'; } else { theOutput += '<option value="Text">Text</option>'; }
                //if (theType == "Yards") { theOutput += '<option value="Yards" selected="true">Yards</option>'; } else { theOutput += '<option value="Yards">Yards</option>'; }
                if (theType == "Amount") { theOutput += '<option value="Amount" selected="true">Amount</option>'; } else { theOutput += '<option value="Amount">Amount</option>'; }
                theOutput += '</select>';
                theOutput += '</td>';
                // Text / Default Value
                theOutput += '<td><br/>';
                theOutput += '<input onblur="handleSubClauseTextChange(this,\'' + subClauseNumber + '\',\'' + theType + '\');" style="width: 95%;" class="' + theClass + '" type="text" id="Value_' + i + '" value="' + theTxt + '" /></td>';
                // Class
                theOutput += '<td><br/>';
                var dropdownDisplay = "inline";
                var spanDisplay = "none";
                if (theType != "Text") { dropdownDisplay = "none"; spanDisplay = "inline";}
                theOutput += '<select onchange="handleSubClauseStyleChange(this,\'' + subClauseNumber + '\');" style="display: ' + dropdownDisplay + ';" id="ClassDropdown_' + i + '">';
                if (theClass == "ClauseNormal") { theOutput += '<option value="ClauseNormal" selected="true">Normal</option>'; } else { theOutput += '<option value="ClauseNormal">Normal</option>'; }
                if (theClass == "ClauseBold") { theOutput += '<option value="ClauseBold" selected="true">Bold</option>'; } else { theOutput += '<option value="ClauseBold">Bold</option>'; }
                if (theClass == "ClauseBoldUnderlined") { theOutput += '<option value="ClauseBoldUnderlined" selected="true">Bold, Underlined</option>'; } else { theOutput += '<option value="ClauseBoldUnderlined">Bold, Underlined</option>'; }
                theOutput += '</select>';
                theOutput += '<span style="display: ' + spanDisplay + ';" id="dispAmountStyle_' + i + '" title="Amounts are automatically styled by the system.">Autostyled</span>';
                theOutput += '</td>';
                // Bullets
                var isStartChecked = "";
                if (startBullet == "True") { isStartChecked = ' checked="true"';}
                theOutput += '<td><br/><input onchange="handleSubClauseBulletChange(this,\'' + subClauseNumber + '\');" id="StartBullet_' + i + '" name="StartBullet_' + i + '" value="True"' + isStartChecked + ' type="checkbox" /></td>';
                var isEndChecked = "";
                if (endBullet == "True") { isEndChecked = ' checked="true"'; }
                theOutput += '<td><br/><input onchange="handleSubClauseBulletChange(this,\'' + subClauseNumber + '\');" id="EndBullet_' + i + '" name="EndBullet_' + i + '" value="True"' + isEndChecked + ' type="checkbox" /></td>';
                theOutput += '</tr>';
                theOutput += '<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>';
            }
            theOutput += '<tr><td>&nbsp;</td><td><a href="javascript:void(0);" onclick="addSubClause();" id="btnAddSubClause" type="button">Add a Row</a></td><td>&nbsp;</td><td>&nbsp;</td></tr>';

            theOutput += "</table>";
            document.getElementById("centeringDiv").innerHTML = theOutput;
        }



        function handleSubClauseBulletChange(theInput, theSubClauseNumber) {
            var theBulletType = "StartBullet";
            if (theInput.id.indexOf("EndBullet") >= 0) { theBulletType = "EndBullet"; }
            var theValue = "False";
            if (theInput.checked) { theValue = "True";}
            var theNodes = gXMLDoc.getElementsByTagName("SubClause");
            for (var i = 0; i < theNodes.length; i++) {
                if (theNodes[i].getAttribute("SubClauseID") == theSubClauseNumber) {
                    theNodes[i].setAttribute(theBulletType, theValue);
                    updateClauseEditorTable();
                    break;
                }
            }
        }

        function handleSubClauseTypeChange(theDropdown, theSubClauseNumber) {
            var theType = theDropdown.options[theDropdown.selectedIndex].value;
            var theNodes = gXMLDoc.getElementsByTagName("SubClause");
            for (var i = 0; i < theNodes.length; i++) {
                if (theNodes[i].getAttribute("SubClauseID") == theSubClauseNumber) {
                    theNodes[i].setAttribute("Type", theType);
                    var theTxt = theNodes[i].getAttribute("Txt");
                    if (theType != "Text") {
                        if ((isNaN(theTxt)) || (parseInt(theTxt) < 1)) { theNodes[i].setAttribute("Txt", "1");}
                    }
                    if (theType == "Text") { theNodes[i].setAttribute("Class", "ClauseNormal"); }
                    if (theType == "Amount") { theNodes[i].setAttribute("Class", "ClauseAmount"); }
                    updateClauseEditorTable();
                    break;
                }
            }
        }

        function handleSubClauseStyleChange(theDropdown,theSubClauseNumber) {
            var theClass = theDropdown.options[theDropdown.selectedIndex].value;
            var theNodes = gXMLDoc.getElementsByTagName("SubClause");
            for (var i = 0; i < theNodes.length; i++) {
                if (theNodes[i].getAttribute("SubClauseID") == theSubClauseNumber) {
                    theNodes[i].setAttribute("Class", theClass);
                    updateClauseEditorTable();
                    break;
                }
            }
        }

        function handleSubClauseTitleChange(theInput) {
            var theTxt = trimThis(theInput.value);
            if (theTxt == "") {
                alert('The Clause Title can not be blank.\n\nPlease enter a value for the Clause Title.');
                setTimeout("document.getElementById('" + theInput.id + "').focus();", 10);
                return false;
            }
            var allClauseNodes = gXMLDoc.getElementsByTagName("Clause");
            var theSelectedClauseNode = allClauseNodes[g_currentlyEditedClause];
            theSelectedClauseNode.setAttribute("Title", theTxt);
            var theUUID = theSelectedClauseNode.getAttribute("UUID");
            displayTemplateProperties(theUUID);
        }

        function handleSubClauseTextChange(theInput, theSubClauseNumber, theType) {
            var theTxt = trimThis(theInput.value);
            // If this is an amount, validate it as a number
            if (theType != "Text") {
                if ((isNaN(theInput.value)) || (parseInt(theInput.value) < 1)) {
                    alert('This field must contain a positive numeric value.\n\nPlease enter only the characters 0 through 9, and do not use commas.');
                    setTimeout('document.getElementById("' + theInput.id + '").focus(); document.getElementById("' + theInput.id + '").select();', 15);
                    return false;
                }
                if (theTxt == "") { theTxt = "1";}
            }
            var theNodes = gXMLDoc.getElementsByTagName("SubClause");
            for (var i = 0; i < theNodes.length; i++) {
                if (theNodes[i].getAttribute("SubClauseID") == theSubClauseNumber) {
                    theNodes[i].setAttribute("Txt", theTxt);
                    updateClauseEditorTable();
                    break;
                }
            }
        }

        function handleEditClauseDropdownChange(theDropdown) {
            var theVal = theDropdown.options[theDropdown.selectedIndex].value;
            document.getElementById("templateCopyClauseButton").style.visibility = "hidden";
            document.getElementById("templateMoveUpButton").style.visibility = "hidden";
            document.getElementById("templateMoveDownButton").style.visibility = "hidden";
            if (theVal == "") {
                clearDocumentArea('Please select a Clause from the dropdown list above to begin editing.');
            } else {
                g_currentlyEditedClause = theVal;
                updateClauseEditorTable();
                document.getElementById("templateCopyClauseButton").style.visibility = "visible";
                // Show the appropriate Move buttons
                if ((theDropdown.options.length-1) != theDropdown.selectedIndex) {
                    document.getElementById("templateMoveDownButton").style.visibility = "visible";
                }
                if (theDropdown.selectedIndex >= 2) {
                    document.getElementById("templateMoveUpButton").style.visibility = "visible";
                }
            }
        }

        function removeSubClause(theSubClauseNumber, theClauseType) {
            // Cannot remove last subclause
            var allClauseNodes = gXMLDoc.getElementsByTagName("Clause");
            var theSelectedClauseNode = allClauseNodes[g_currentlyEditedClause];
            var childNodeCount = -1;
            for (var i = 0; i < theSelectedClauseNode.childNodes.length; i++) {
                var subClauseNode = theSelectedClauseNode.childNodes[i];
                if (subClauseNode.nodeType !== 1) { continue; }  // we only care about nodes of type Node.ELEMENT_NODE
                childNodeCount = childNodeCount + 1;
            }
            if (childNodeCount == 0) {
                alert('You cannot remove the last subclause.\n\nPlease try adding a new row first, then come back and remove the unwanted clause.');
                return false;
            }
            // Verify and remove
            var dispNum = theSubClauseNumber;
            try { dispNum = parseInt((theSubClauseNumber.split("_")[1]), 10) + 1; } catch (er) { dispNum = theSubClauseNumber; }
            var ruSure = confirm('Remove subclause ' + dispNum + '?');
            if (ruSure) {
                var theNodes = gXMLDoc.getElementsByTagName("SubClause");
                for (var i = 0; i < theNodes.length; i++) {
                    if (theNodes[i].getAttribute("SubClauseID") == theSubClauseNumber) {
                        var theParentNode = theNodes[i].parentNode;
                        theParentNode.removeChild(theNodes[i]);
                        setTimeout("updateClauseEditorTable();", 10);
                        break;
                    }
                }
            }
        }

        function insertSubClause(theSubClauseNumber) {
            var theNodes = gXMLDoc.getElementsByTagName("SubClause");
            for (var i = 0; i < theNodes.length; i++) {
                if (theNodes[i].getAttribute("SubClauseID") == theSubClauseNumber) {
                    var newNode = theNodes[i].cloneNode(true);
                    newNode.setAttribute("Type", "Text");
                    newNode.setAttribute("Class", "ClauseNormal");
                    newNode.setAttribute("StartBullet", "False");
                    newNode.setAttribute("EndBullet", "False");
                    newNode.setAttribute("Txt", "");
                    theNodes[i].parentNode.insertBefore(newNode, theNodes[i]);
                    updateClauseEditorTable();
                    break;
                }
            }
        }

        function addSubClause() {
            var allClauseNodes = gXMLDoc.getElementsByTagName("Clause");
            var theSelectedClauseNode = allClauseNodes[g_currentlyEditedClause];
            var childNodeCount = -1;
            for (var i = 0; i < theSelectedClauseNode.childNodes.length; i++) {
                var subClauseNode = theSelectedClauseNode.childNodes[i];
                if (subClauseNode.nodeType !== 1) { continue; }  // we only care about nodes of type Node.ELEMENT_NODE
                childNodeCount = childNodeCount + 1;
            }
            if (childNodeCount >= 0) {
                var subClauseNumber = theSelectedClauseNode.childNodes[childNodeCount].getAttribute("SubClauseID");
                insertSubClause(subClauseNumber);
                moveSubClauseDown(subClauseNumber);
            }
        }


        function addNewTemplateClause() {
            var allClauseNodes = gXMLDoc.getElementsByTagName("Clause");
            var theLastClause = allClauseNodes[allClauseNodes.length - 1];
            var theClauseNum = theLastClause.getAttribute("ClauseID");
            insertTemplateClause(theClauseNum);
        }


        function insertTemplateClause(theClauseNumber) {
            var theNodes = gXMLDoc.getElementsByTagName("Clause");
            for (var i = 0; i < theNodes.length; i++) {
                if (theNodes[i].getAttribute("ClauseID") == theClauseNumber) {
                    var newNode = theNodes[i].cloneNode(true);
                    newNode.setAttribute("Title", "New Clause");
                    newNode.setAttribute("MaxVal", "0");
                    var theUUID = generateUUID();
                    newNode.setAttribute("UUID", theUUID);
                    theNodes[i].parentNode.insertBefore(newNode, theNodes[i]);
                    // Remove all SubClauses
                    while (newNode.hasChildNodes()) {
                        newNode.firstChild.remove();
                    }
                    // Add a clean SubClause node
                    var newel = gXMLDoc.createElement('SubClause');
                    newel.setAttribute("Type", "Text");
                    newel.setAttribute("Class", "ClauseNormal");
                    newel.setAttribute("StartBullet", "False");
                    newel.setAttribute("EndBullet", "False");
                    newel.setAttribute("Txt", "TBD");
                    newNode.appendChild(newel);
                    moveClauseDown(theClauseNumber,'');
                    displayTemplateProperties(theUUID);
                    handleEditClauseDropdownChange(document.getElementById("editClauseDropdown"));
                    break;
                }
            }
        }


        function moveSubClauseUp(theSubClauseNumber) {
            var theNodes = gXMLDoc.getElementsByTagName("SubClause");
            // Get the selected node
            for (var i = 0; i < theNodes.length; i++) {
                if (theNodes[i].getAttribute("SubClauseID") == theSubClauseNumber) {
                    var theNode = theNodes[i];
                    break;
                }
            }
            // Get the node just before it
            var prevNode = theNode.previousSibling;
            if (prevNode == null) { return; }
            // Swap the nodes
            theNode.parentNode.insertBefore(theNode, prevNode);
            // Update the display
            updateClauseEditorTable();
        }


        function moveSubClauseDown(theSubClauseNumber) {
            var theNodes = gXMLDoc.getElementsByTagName("SubClause");
            // Get the selected node
            for (var i = 0; i < theNodes.length; i++) {
                if (theNodes[i].getAttribute("SubClauseID") == theSubClauseNumber) {
                    var theNode = theNodes[i];
                    break;
                }
            }
            // Get the node just before it
            var nextNode = theNode.nextSibling;
            if (nextNode == null) { return; }
            // Swap the nodes
            nextNode.parentNode.insertBefore(nextNode, theNode);
            // Update the display
            updateClauseEditorTable();
        }


        function template_copyATemplateClause() {
            var isOK = confirm("Create a copy the selected Clause?");
            if (isOK) {
                addClause_Finish(g_currentlyEditedClause, "TEMPLATE");
            }
        }



  // ## DOCUMENT/ADDENDUM FUNCTIONS #######################################################################################################################

        function displayDocumentProperties() {
            // Load the document properties from the XML doc
            var theNodes = gXMLDoc.getElementsByTagName("Addendum");
            var theNode = theNodes[0];

            var theDocID = theNode.getAttribute("DocID");
            var thePersonEID = theNode.getAttribute("PersonEID");
            var thePersonName = g_PersonName;
            var thePersonYear = theNode.getAttribute("PersonYear");
            var theStatus = theNode.getAttribute("Status");
            var theStartingClause = theNode.getAttribute("StartingClause");
            g_startingClause = theStartingClause;
            var theEffectiveDate = theNode.getAttribute("EffectiveDate");
            g_contractNumber = theNode.getAttribute("CnNumber");

            // Build the Properties section
            var theProp = '<br/><div class="personNameText">' + thePersonName + '</div>';
            theProp += '<table style="margin: 0px; margin-left: 50px;">';
            theProp += '<tr>';
            theProp += '<td><span class="fieldLabel">Agreement Status:</span><br/><select id="statusDropdown" style="width: 110px;" onchange="handleStatusChange(this);">';
            if (theStatus == "Draft") { theProp += '<option value="Draft" SELECTED="true">Draft</option>'; } else { theProp += '<option value="Draft">Draft</option>'; }
            if (theStatus == "Signed") { theProp += '<option value="Signed" SELECTED="true">Signed</option>'; } else { theProp += '<option value="Signed">Signed</option>'; }
            theProp += '</select></td>';
            theProp += '<td style="padding-left: 8px;"><span class="fieldLabel">Starting Clause #:</span><br/><input onblur="handleStartingClauseChange(this);" style="width: 100px;" maxlength="5" value="' + theStartingClause + '"/></td>';
            theProp += '<td style="padding-left: 8px;"><span class="fieldLabel">Contract Date:</span><br/>';
            theProp += '  <span id="dispContractDate" style="line-height: 22px; font-weight: bold;">' + convertDateToDisplayFormat(theEffectiveDate) + '</span>';
            theProp += '  <img onclick="showAssignContractDatePopup(event);" src="./img/datePickerIcon.png" title="Select Contract Date" class="datePickerIcon" />&nbsp;&nbsp;'
            theProp += '  <input style="display: none;" id="contractDate" style="width: 130px;" value="' + theEffectiveDate + '"/>';
            theProp += '</td>';
            if (g_contractNumber == "Not Assigned") {
                theProp += '<td style="padding-left: 8px;"><span class="fieldLabel">Contract #:</span><br/><a href="javascript: void(0);" onclick="showAssignContractNumberPopup(event);">Assign Contract #</a></td>';
            } else {
                theProp += '<td style="padding-left: 8px;"><span class="fieldLabel">Contract #:</span><br/><span id="currentlyAssignedContractNumber" style="line-height: 22px; font-weight: bold;">' + g_contractNumber + '</span>&nbsp;&nbsp;&nbsp;<a href="javascript: void(0);" style="position: relative; top: -1px;" onclick="contractNumber_ReleaseContractNumber();">Remove Contract #</a></td>';
            }
            theProp += '</tr>';
            theProp += '<tr><td colspan="4" class="auditText">Created by ' + g_CreatedBy + ' on ' + convertDateToDisplayFormat(g_CreatedDate) + ', Last Updated by ' + g_LastUpdatedBy + ' on ' + convertDateToDisplayFormat(g_LastUpdatedDate) + '</td></tr>';
            theProp += '</table>';
            document.getElementById('documentPropertiesDiv').innerHTML = theProp;
        }


        function updateClauseTable() {
            hideAllPopups();
            // Start building the clause table
            var theOutput = '<br/><table style="width: 900px; border: 0px; padding: 0px; spacing: 0px; border-collapse: collapse;">';
            // Load the clauses from the XML doc
            var theNodes = gXMLDoc.getElementsByTagName("Clause");
            for (var i = 0; i < theNodes.length; i++) {
                var clauseNode = theNodes[i];
                var clauseNumber = parseInt(g_startingClause, 10) + i;
                clauseNode.setAttribute("ClauseID", clauseNumber);
                var theTitle = clauseNode.getAttribute("Title");
                theOutput += '<tr>';
                theOutput += '<td style="width: 75px; text-align: center;">';

                if (i == 0) {
                    theOutput += '<br/>';
                } else {
                    theOutput += '<img style="width: 15px; height: 8px; cursor: pointer;" title="Move Up" onclick="moveClauseUp(\'' + clauseNumber + '\',\'\');" alt="^" src="./img/arrowUp.png" /><br/>';
                }
                theOutput += '<img style="cursor: pointer; width: 10px; height: 10px;" title="Insert a New Clause" alt="+" src="./img/addIcon.png" onclick="showAddClausePopup(event, \'' + clauseNumber + '\');" onmouseover="this.src=\'./img/addIconOn.png\';" onmouseout="this.src=\'./img/addIcon.png\';" />';
                theOutput += '&nbsp;&nbsp;' + clauseNumber + '&nbsp;&nbsp;';
                theOutput += '<img style="cursor: pointer; width: 10px; height: 10px;" title="Remove This Clause" alt="-" src="./img/removeIcon.png" onclick="showRemoveClausePopup(event,\'' + clauseNumber + '\',\'' + theTitle + '\');" onmouseover="this.src=\'./img/removeIconOn.png\';" onmouseout="this.src=\'./img/removeIcon.png\';" /><br/>';

                if (i == (theNodes.length-1)) {
                    theOutput += '<br/>';
                } else {
                    theOutput += '<img style="width: 15px; height: 8px; cursor: pointer;" title="Move Down" onclick="moveClauseDown(\'' + clauseNumber + '\',\'\');" alt="\/" src="./img/arrowDown.png" />';
                }

                theOutput += '<td style="width: 190px;"><br/>';
                theOutput += theTitle + '</td>';
                theOutput += '<td style="width: 30px; background: white;"><br/>' + clauseNumber + '</td>';
                theOutput += '<td style="width: 605px; background: white;"><br/>';

                // Call a function to loop through each subclause
                theOutput += assembleClause(clauseNode,i,false);


                theOutput += '</td>';

                theOutput += '</tr>';
                theOutput += '<tr><td>&nbsp;</td><td>&nbsp;</td><td style="background: white;">&nbsp;</td><td style="background: white;">&nbsp;</td></tr>';
            }
            theOutput += '<tr><td>&nbsp;</td><td><a href="javascript: void(0);" id="btnAddClause" type="button"  onclick="showAddClausePopup(event, \'' + (clauseNumber + 1) + '\');">Add a Clause</a></td><td style="background: white;">&nbsp;</td><td style="background: white;">&nbsp;</td></tr>';
            
            theOutput += "</table>";
            document.getElementById("centeringDiv").innerHTML = theOutput;
        }


        function handleAmountChange(theInput, theSubNodeID, theOriginalValue) {
            hideAllPopups();
            theInput.value = trimThis(theInput.value);
            if ((isNaN(theInput.value)) || (parseInt(theInput.value) < 1)) {
                alert('This field must contain a positive numeric value.\n\nPlease enter only the characters 0 through 9, and do not use commas.');
                theInput.value = theOriginalValue;
                setTimeout('document.getElementById("' + theInput.id + '").focus(); document.getElementById("' + theInput.id + '").select();', 15);
                return false;
            }
            var theInputID = theInput.id;
            // Update the corresponding text
            var theNumberToWords = toWords(theInput.value) + "Dollars ";
            theNumberToWords = capitalizeFirstLetterOfEachWord(theNumberToWords);
            document.getElementById("txt_" + theInputID).innerHTML = theNumberToWords;
            // Update the amount value in the XML doc
            var theNodes = gXMLDoc.getElementsByTagName("SubClause");
            for (var i = 0; i < theNodes.length; i++) {
                if (theNodes[i].getAttribute("SubClauseID") == theSubNodeID) {
                    theNodes[i].setAttribute("Txt", theInput.value);
                    theNodes[i].setAttribute("AmountWords", theNumberToWords);
                    break;
                }
            }
        }

        function handleStatusChange(theDropdown) {
            var theNodes = gXMLDoc.getElementsByTagName("Addendum");
            var theNode = theNodes[0];
            var theVal = theDropdown.options[theDropdown.selectedIndex].value;
            theNode.setAttribute("Status", theVal);
        }

        function handleStartingClauseChange(theClauseInput) {
            // Validate that this is a number
            theClauseInput.value = trimThis(theClauseInput.value);
            if ((isNaN(theClauseInput.value)) || (theClauseInput.value == "")) {
                alert('The Starting Clause # must be a numeric value.');
                theClauseInput.value = g_startingClause;
                theClauseInput.focus();
                return;
            }
            // Update the XML document
            var theNodes = gXMLDoc.getElementsByTagName("Addendum");
            var theNode = theNodes[0];
            var theVal = theClauseInput.value;
            theNode.setAttribute("StartingClause", theVal);
            // Update the numbering
            if (theClauseInput.value != g_startingClause) {
                g_startingClause = parseInt(theClauseInput.value, 10);
                updateClauseTable();
            }
        }


        function removeClause_Finish(theClauseNumber) {
            // Remove the selected Clause
            var theNodes = gXMLDoc.getElementsByTagName("Clause");
            for (var i = 0; i < theNodes.length; i++) {
                if (theNodes[i].getAttribute("ClauseID") == theClauseNumber) {
                    var theParentNode = theNodes[i].parentNode;
                    if (g_DocType != "A") {
                        theParentNode.removeChild(theNodes[i]);
                        updateClauseTable();  // necessary to renumber the clauses
                        // Reset everything
                        g_currentlyEditedClause = 0;
                        document.getElementById("centeringDiv").innerHTML = "&nbsp;";
                        displayTemplateProperties("N/A");
                        var theMsg = 'The Template Editor allows you to edit the master templates of each Clause.<br/><br/>';
                        theMsg += 'Please select a Clause from the dropdown list above to begin editing.';
                        clearDocumentArea(theMsg);
                        break;
                    } else {
                        theParentNode.removeChild(theNodes[i]);
                        setTimeout("updateClauseTable();", 10);
                        break;
                    }
                }
            }
        }



        function moveClauseUp(theClauseNumber, theClauseType) {
            if (theClauseType == "TEMPLATE") {
                var theIndex = document.getElementById("editClauseDropdown").selectedIndex;
                if (theIndex <= 1) { return; }  // can't move up from the top slot
                updateClauseTable();  // preps the xmldoc if the page was just loaded
            }
            var theNodes = gXMLDoc.getElementsByTagName("Clause");
            // Get the selected node
            for (var i = 0; i < theNodes.length; i++) {
                if (theNodes[i].getAttribute("ClauseID") == theClauseNumber) {
                    var theNode = theNodes[i];
                    var theSelectedNodeUUID = theNode.getAttribute("UUID");
                    break;
                }
            }
            // Get the node just before it
            var prevNode = theNode.previousSibling;
            if (prevNode == null) { return; }
            // Swap the nodes
            theNode.parentNode.insertBefore(theNode, prevNode);
            // Update the display
            updateClauseTable();
            if (theClauseType == "TEMPLATE") {
                displayTemplateProperties(theSelectedNodeUUID);
                handleEditClauseDropdownChange(document.getElementById("editClauseDropdown"));
            }
        }

        function moveClauseDown(theClauseNumber, theClauseType) {
            if (theClauseType == "TEMPLATE") {
                var theIndex = document.getElementById("editClauseDropdown").selectedIndex;
                var theOptionsLength = document.getElementById("editClauseDropdown").options.length;
                if (theIndex == theOptionsLength) { return; }  // can't move down from the bottom slot
                updateClauseTable();  // preps the xmldoc if the page was just loaded
            }
            var theNodes = gXMLDoc.getElementsByTagName("Clause");
            // Get the selected node
            for (var i = 0; i < theNodes.length; i++) {
                if (theNodes[i].getAttribute("ClauseID") == theClauseNumber) {
                    var theNode = theNodes[i];
                    var theSelectedNodeUUID = theNode.getAttribute("UUID");
                    break;
                }
            }
            // Get the node just before it
            var nextNode = theNode.nextSibling;
            if (nextNode == null) { return; }
            // Swap the nodes
            nextNode.parentNode.insertBefore(nextNode, theNode);
            // Update the display
            updateClauseTable();
            if (theClauseType == "TEMPLATE") {
                displayTemplateProperties(theSelectedNodeUUID);
                handleEditClauseDropdownChange(document.getElementById("editClauseDropdown"));
            }
        }


        function archiveExisting() {
            alert('This functionality is coming soon.');
        }

        function OLDexportToWord() {
            var isOK = confirm("Export this document to Microsoft Word?\n\n(Warning: This action will save any changes to the document.)");
            if (isOK) {
                g_exportToWordInProgress = true;
                saveDocument();
            } else {
                window.focus();
            }
        }

        function OLDexportToWord_Finish() {
            window.open('./ExportToWord.aspx?DocID=' + g_DocID);
        }

        function showAddClausePopup(event, theClauseNumber) {
            var el, x, y;
            el = document.getElementById('popupMenu_AddClause');
            if (window.event) {
                x = window.event.clientX + document.documentElement.scrollLeft + document.body.scrollLeft;
                y = window.event.clientY + document.documentElement.scrollTop + document.body.scrollTop;
            } else {
                x = event.clientX + window.scrollX;
                y = event.clientY + window.scrollY;
            }
            x -= 2; y -= 2; y = y + 10;
            el.style.left = x + "px";
            el.style.top = y + "px";

            var theOutput = '<div style="line-height: 25px;">Select a Clause to add:</div>';
            theOutput += '<select id="addClausePopupDropdown">';
            theOutput += '<option value="">Select...</option>';

            var theNodes = gTemplateDoc.getElementsByTagName("Clause");
            for (var i = 0; i < theNodes.length; i++) {
                var clauseNode = theNodes[i];
                var theTitle = clauseNode.getAttribute("Title");
                var theClauseID = clauseNode.getAttribute("ClauseID");
                theOutput += '<option value="' + theClauseID + '">' + theTitle + '</option>';
            }

            theOutput += '</select><br/><br/>';
            theOutput += '<button type="button" onclick="addClause_Finish(' + theClauseNumber + ',\'\');">Add Clause</button>&nbsp;&nbsp;&nbsp;';
            theOutput += '<button type="button" onclick="hideAddClausePopup();">Cancel</button>';
            document.getElementById('popupMenu_AddClauseInner').innerHTML = theOutput;

            el.style.display = "block";
        }

        function addClause_Finish(whereToAddIt,theClauseType) {
            // See if the user selected a Clause to add
            if (theClauseType == "TEMPLATE") {
                var theDropdown = document.getElementById("editClauseDropdown");
                var theErrMsg = 'Please select a Clause from the list before clicking "Copy Selected Clause."';
            } else {
                var theDropdown = document.getElementById("addClausePopupDropdown");
                var theErrMsg = 'Please select a Clause from the list before clicking "Add Clause."';
            }
            var theSelectedClauseNum = theDropdown.options[theDropdown.selectedIndex].value;
            if (theSelectedClauseNum == "") {
                alert(theErrMsg);
                return false;
            }
            // Find the place where we need to insert the Clause
            var cNodes = gXMLDoc.getElementsByTagName("Clause");
            var insertionPointNode = "";
            var isLast = false;
            for (var i = 0; i < cNodes.length; i++) {
                if (cNodes[i].getAttribute("ClauseID") == whereToAddIt) {
                    insertionPointNode = cNodes[i];
                }
            }
            if (insertionPointNode == "") { insertionPointNode = cNodes[cNodes.length - 1]; isLast = true; }
            // Find the TEMPLATE Clause that we need to copy, and copy it to the main document
            var theNodes = gTemplateDoc.getElementsByTagName("Clause");
            for (var i = 0; i < theNodes.length; i++) {
                if (theNodes[i].getAttribute("ClauseID") == theSelectedClauseNum) {
                    var newNode = theNodes[i].cloneNode(true);
                    if (theClauseType == "TEMPLATE") {
                        newNode.setAttribute("UUID", generateUUID());
                        var theOldTitle = theNodes[i].getAttribute("Title");
                        newNode.setAttribute("Title", theOldTitle + " (Copy)");
                    } else {
                        newNode.setAttribute("TemplateUUID", theNodes[i].getAttribute("UUID"));
                        newNode.removeAttribute("UUID");
                    }
                    insertionPointNode.parentNode.insertBefore(newNode, insertionPointNode);
                    updateClauseTable();
                    if (theClauseType == "TEMPLATE") {
                        displayTemplateProperties(newNode.getAttribute("UUID"));
                        handleEditClauseDropdownChange(document.getElementById('editClauseDropdown'));
                    }
                    if (isLast) { moveClauseUp(whereToAddIt,theClauseType); }
                    break;
                }
            }
        }



    </script>
</head>


<body style="background-image:url('./img/BackgroundGray1.png');" onload="doOnLoad();" onresize="handleWindowResize();">
<form id="form1" runat="server">
<div class="headerContainer">
 <div class="header">
  <div id="forCentering1" style="width: 960px; margin-left: auto; margin-right: auto;">
    <img src="./img/Logo1.png" style="float: left; width: 76px; height: 75px;"/>
    <div class="headerTitle">&nbsp;&nbsp;Addendum Builder</div>
  </div>  <!-- end forCentering1 -->
 </div>  <!-- end header -->
 <div id="theButtonRow" style="background: black; width: 1000px; text-align: left; margin-left: auto; margin-right: auto; padding: 0px; padding-top: 2px; padding-bottom: 2px; border: 0px;">
  <div style="display: inline-block; width: 50px;">&nbsp;</div>
  <button id="btnSave" type="button" onclick="saveDocument();">Save</button>
  &nbsp;&nbsp;
  <button id="btnCancel" type="button" onclick="showCloseDocumentPopup(event);">Close</button>
  &nbsp;&nbsp;
  <span id="downloadify" style="position: relative; top: 3px; margin: 0px; padding: 0px; border: 0px;">&nbsp;</span>
  &nbsp;
  <button id="btnDeleteExisting" style="visibility: hidden;" type="button" onclick="archiveExisting();">Archive</button>
  &nbsp;&nbsp;
  <button id="btnExportToWord" style="visibility: hidden; display: none;" type="button" onclick="OLDexportToWord();">Old Export to Word</button>
  &nbsp;&nbsp;
  <button id="btnTEST"  style="visibility: hidden; display: none;" type="button" onclick="buildWordDoc();">TEST</button>
  &nbsp;&nbsp;
</div>  <!-- end theButtonRow div -->
<div id="statusMessage" style="width: 960px; text-align: center; line-height: 22px; font-style: italic; background: transparent; margin-left: auto; margin-right: auto;">&nbsp;</div>
</div>  <!-- end headerContainer div -->
<div class="mainContainer">
    <div id="topSpacer" style="height: 110px; padding: 0px; margin: 0px; border: 0px;">&nbsp;</div>
<div class="innerContainer">

<div id="documentPropertiesDiv" style="width: 100%; text-align: left;">
    Loading document properties...
</div> <!-- end documentPropertiesDiv -->

<br />

<div id="centeringDiv" style="width: 90%; text-align: center; margin-left: auto; margin-right: auto; border: 0px; border-top: 1px solid #0c0c0c;">
    Loading the document...
</div> <!-- end centeringDiv -->
      

<br/><br/><br/>

  <div id="adminArea" style="text-align: center; visibility: hidden;">
    <textarea runat="server" id="Hidden_DocXML" cols="80" name="S1" rows="3"></textarea><br />
    <textarea runat="server" id="Hidden_AllClauses" cols="80" name="S2" rows="3"></textarea><br/>
    <textarea runat="server" id="Hidden_ExportTemplateHeader" cols="80" name="Hidden_ExportTemplateHeader" rows="3"></textarea><br/>
    <textarea runat="server" id="Hidden_ExportTemplateFooter" cols="80" name="Hidden_ExportTemplateFooter" rows="3"></textarea><br/>
    <iframe id="submitFormFrame" src="./SubmitData.aspx" style="width: 800px; height: 25px; background: white;"></iframe><br />
    <iframe id="lookupCnNumbersFrame" src="" style="width: 800px; height: 25px; background: white;"></iframe><br />
    <iframe id="keepAliveFrame" src="./KeepAlive.aspx" style="width: 800px; height: 25px; background: white;"></iframe><br />

  </div>  <!-- END adminArea div -->


    <!-- POPUPS -->

      <div id="popupMenu_RemoveClause" style="display: none; position: absolute; left: 100px; top: 250px; font-size: 12px; z-index: 99;">
        <div id="popupMenu_RemoveClauseInner">
            &nbsp;
        </div>
      </div>


      <div id="popupMenu_AddClause" style="display: none; position: absolute; left: 100px; top: 250px; font-size: 12px; z-index: 99;">
        <div id="popupMenu_AddClauseInner">
            &nbsp;
        </div>
      </div>

      <div id="popupMenu_AssignContractNumber" style="display: none; position: absolute; left: 100px; top: 250px; font-size: 12px; z-index: 99;">
        <div id="popupMenu_AssignContractNumberInner">
            &nbsp;
        </div>
      </div>

      <div id="popupMenu_SelectContractDate" style="display: none; position: absolute; left: 100px; top: 250px; font-size: 12px; z-index: 99;">
        <div id="popupMenu_SelectContractDateInner">
            <div id="getContractDate"></div><br />
            <button type="button" onclick="hideSelectContractDatePopup();">Cancel</button><br />
        </div>
      </div>

      <div id="popupMenu_CloseDocument" style="display: none; position: fixed; left: 100px; top: 250px; font-size: 12px; z-index: 150;">
        <div id="popupMenu_CloseDocumentInner">
            &nbsp;
        </div>
      </div>

    <!-- END POPUPS -->

    <script type="text/javascript">


        function showAssignContractNumberPopup(event) {
            var el, x, y;
            el = document.getElementById('popupMenu_AssignContractNumber');
            if (window.event) {
                x = window.event.clientX + document.documentElement.scrollLeft + document.body.scrollLeft;
                y = window.event.clientY + document.documentElement.scrollTop + document.body.scrollTop;
            } else {
                x = event.clientX + window.scrollX;
                y = event.clientY + window.scrollY;
            }
            x -= 2; y -= 2; y = y + 10;
            el.style.left = x + "px";
            el.style.top = y + "px";
            var theOutput = "<br/><br/>Retrieving Contract Numbers... Please wait...<br/><br/>";
            theOutput += '<button type="button" onclick="hideAssignContractNumberPopup();">Cancel</button>';
            el.innerHTML = theOutput;
            el.style.display = "block";
            // Start the cn number lookup
            document.getElementById("lookupCnNumbersFrame").contentWindow.location = "./ContractNumbersLookup.aspx?date=" + new Date();
        }

        function contractNumbersRetrievedSuccessfully(theArr, theLastInt) {
            var nextSuggestion = "OTTC-" + padWithZeros((theLastInt + 1), 5);
            var theOutput = "";
            theOutput += '<table style="width: 100%;">';
            theOutput += '<tr><td colspan="5" style="font-weight: bold;">Contract Numbers Assigned Most Recently:'
            for (var i = 0; i < theArr.length; i++) {
                var theCnNum = theArr[i][0];
                var thePersonEID = unencryptItem(theArr[i][1]);
                var theDate = theArr[i][2];
                var theStatus = theArr[i][3];
                var theDocID = theArr[i][4];
                theOutput += '<tr><td>' + theCnNum + ':</td><td>' + thePersonEID + '</td><td>' + theStatus + '</td><td>' + theDate + '</td></tr>';
            }
            theOutput += '</table>';
            theOutput += '<br/>';
            theOutput += '<div style="font-size: 15px; line-height: 20px; font-weight: bold; margin: 0px; margin-top: 5px; margin-bottom: 12px;">Suggested Contract Number:&nbsp;&nbsp;';
            theOutput += '<span id="nextCnNumberSuggestion" style="background: white; padding: 5px;">' + nextSuggestion + '</span>';
            theOutput += '</div><br/>';
            theOutput += '<button type="button" onclick="contractNumber_AcceptSuggestion();">Accept Suggestion</button>&nbsp;&nbsp;&nbsp;';
            theOutput += '<button type="button" onclick="contractNumber_SkipNumber();">Skip this Number</button>&nbsp;&nbsp;&nbsp;';
            theOutput += '<button type="button" onclick="hideAssignContractNumberPopup();">Cancel</button>';
            theOutput += '<br/><br/>';
            document.getElementById('popupMenu_AssignContractNumber').innerHTML = theOutput;

        }

        function contractNumber_AcceptSuggestion() {
            var theNum = trimThis(document.getElementById("nextCnNumberSuggestion").innerHTML);
            var isOK = confirm("Permanently assign Contract Number " + theNum + "?\n\nNote: This will save changes to your document.");
            if (!isOK) { return false; }
            // Assign the cn number
            var theNodes = gXMLDoc.getElementsByTagName("Addendum");
            var addendumNode = theNodes[0];
            addendumNode.setAttribute("CnNumber", theNum);
            g_contractNumber = theNum;
            hideAllPopups();
            displayDocumentProperties();
            saveDocument();
        }

        function contractNumber_ReleaseContractNumber() {
            var theNum = trimThis(document.getElementById("currentlyAssignedContractNumber").innerHTML);
            var isOK = confirm("Remove the Contract Number (" + theNum + ") from this Addendum?\n\nNote: This will save changes to your document.");
            if (!isOK) { return false; }
            // Assign the cn number
            var theNodes = gXMLDoc.getElementsByTagName("Addendum");
            var addendumNode = theNodes[0];
            addendumNode.setAttribute("CnNumber", "Not Assigned");
            g_contractNumber = "Not Assigned";
            hideAllPopups();
            displayDocumentProperties();
            saveDocument();
        }

        function contractNumber_SkipNumber() {
            var theNum = trimThis(document.getElementById("nextCnNumberSuggestion").innerHTML);
            var lastNum = parseInt((theNum.split('-')[1]), 10);
            var nextSuggestion = "OTTC-" + padWithZeros((lastNum + 1), 5);
            document.getElementById("nextCnNumberSuggestion").innerHTML = nextSuggestion;
            document.getElementById("nextCnNumberSuggestion").style.background = "yellow";
            setTimeout("document.getElementById('nextCnNumberSuggestion').style.background = 'white';", 400);
        }

        function showAssignContractDatePopup(event) {
            var el, x, y;
            el = document.getElementById('popupMenu_SelectContractDate');
            if (window.event) {
                x = window.event.clientX + document.documentElement.scrollLeft + document.body.scrollLeft;
                y = window.event.clientY + document.documentElement.scrollTop + document.body.scrollTop;
            } else {
                x = event.clientX + window.scrollX;
                y = event.clientY + window.scrollY;
            }
            x -= 2; y -= 2; y = y + 10;
            el.style.left = x + "px";
            el.style.top = y + "px";
            el.style.display = "block";
        }


    </script>



</div>  <!-- END innerContainer -->
</div>  <!-- END mainContainer -->




<div id="databaseResults" style="display: none;" runat="server">&nbsp;</div>


    </form>



</body>
</html>
