<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddendumBuilder.aspx.cs" Inherits="ContractBuilder1.AddendumBuilder" EnableViewState="False" ValidateRequest="false" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<title>Addendum Builder - Home</title>

<link href="./styles/defaultStyles.css" type="text/css" rel="stylesheet" />

<script src="./crypt/rollups/aes.js"></script>
<script src="./crypt/rollups/sha256.js"></script>
<script type="text/javascript" src="./scripts/generalUtilityScripts.js"></script>


<style type="text/css">

.navButton {
    width: 212px;
    height: 28px;
    padding: 0px;
    padding-top: 12px;
    margin: 0px;
    margin-left: 13px;
    font-family: Arial, sans-serif;
    font-size: 13px;
    font-weight: bold;
    background: transparent;
    color: #afafaf;
    border: 1px solid transparent;
    position: relative;
    top: 7px;
    vertical-align: middle;
}

.navButton:hover {
    cursor: pointer;
    border: 1px solid transparent;
    color: white;
}

.navButtonYear {
    width: 212px;
    height: 26px;
    padding: 0px;
    padding-top: 8px;
    margin: 0px;
    margin-left: 13px;
    font-family: Arial, sans-serif;
    font-size: 13px;
    font-weight: bold;
    background: transparent;
    color: #afafaf;
    border: 1px solid transparent;
    position: relative;
    top: 7px;
}

.navButtonYear:hover {
    cursor: pointer;
    border: 1px solid transparent;
    color: white;
}


.createNewAddendum {
  display: inline-block;
  line-height: 1;
  padding: 7px 10px;
  -moz-border-radius: 8px;
  -webkit-border-radius: 8px;
  -khtml-border-radius: 8px;
  border-radius: 8px;

  width: 430px;
  text-align: center;
  background-color: #b8202c;
  margin: 0px;
  margin-top: 2px;
}


.goButton {
  display: inline-block;
  line-height: 1;
  padding: 7px 10px;
  -moz-border-radius: 8px;
  -webkit-border-radius: 8px;
  -khtml-border-radius: 8px;
  border-radius: 8px;

  text-align: center;
  background-color: #fcfcfc;
  cursor: pointer;
  margin: 0px;
  margin-bottom: 2px;
}

.goButton_hover {
  display: inline-block;
  line-height: 1;
  padding: 7px 10px;
  -moz-border-radius: 8px;
  -webkit-border-radius: 8px;
  -khtml-border-radius: 8px;
  border-radius: 8px;

  text-align: center;
  background-color: #0c0c0c;
  color: white;
  cursor: pointer;
  margin: 0px;
  margin-bottom: 2px;
}

.btn_CreateNew_Text {
  text-align: center;
  vertical-align: middle;
  font-size: 17px;
  text-decoration: none;
  color: #ffffff;
}

.btn_EditExisting_off {
  margin-right: 20px;
  width: 100px;
  padding: 3px;
  text-align: center;
  font-size: 12px;
  text-decoration: none;
  background: #CCCCCC;
  color: #999999;
  cursor: text;
}

.btn_EditExisting_on {
  margin-right: 20px;
  width: 100px;
  padding: 3px;
  text-align: center;
  font-size: 12px;
  text-decoration: none;
  background: black;
  cursor: pointer;
}

td {
 text-align: left;
 font-size: 12px;
 color: black;
 font-family: Arial, Sans-Serif;
 padding: 3px;
}


.existingTable_header {width: 600px; border-collapse: collapse;}

.existingTableContainer {width: 600px; height: 250px; overflow-x: hidden; overflow-y: scroll;}

.existingTable        {width: 600px; margin-left: auto; margin-right: auto; border-collapse: collapse;}

.col_1_header {width: 300px; color: white;}
.col_1        {width: 300px; cursor: pointer;}

.col_2_header {width: 100px; color: white; text-align: center;}
.col_2        {width: 100px; cursor: pointer; text-align: center;}

.col_3_header {width: 100px; color: white; text-align: left;}
.col_3        {width: 100px; cursor: pointer; text-align: left;}

.col_4_header {width: 100px; color: white; text-align: center;}
.col_4        {width: 100px; cursor: pointer; text-align: center;}

.col_5_header {width: 25px; color: white; text-align: center;}
.col_5        {width: 25px; cursor: pointer; text-align: center;}


.headerRow {
  color: white;
  background: #b8202c;
  -webkit-touch-callout: none;
  -webkit-user-select: none;
  -khtml-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
}

.aRow {
  -webkit-touch-callout: none;
  -webkit-user-select: none;
  -khtml-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
}

.initialClausesTable {width: 100%;}

#initialClausesContainer {width: 412px; max-height: 250px; overflow-x: hidden; overflow-y: scroll;}

.initialClauseCell {
    width: 100%;
    background: white;
}

.CreateAddendumButton {
    font-size: 15px;
    width: 70px;
    font-weight: bold;
}

</style>




<script type="text/javascript">

    // Global variables
    g_selectedRowID = "NA";
    gTemplateDoc = "";
    g_defaultStartingClauseNumberForNewAddendum = "32";

    function isEncryptionOK() {
        var templateText = document.getElementById("Hidden_AllClauses").value;
        try {
            var testDoc = "";
            templateText = unencryptItem(templateText);
            if (window.DOMParser) {
                parser = new DOMParser();
                testDoc = parser.parseFromString(templateText, "text/xml");
            } else {
                // Older Internet Explorer
                testDoc = new ActiveXObject("Microsoft.XMLDOM");
                testDoc.async = false;
                testDoc.loadXML(templateText);
            }
            return true;
        } catch(er) {
            return false;
        }
    }

    function doLogout(isSilent) {
        if (isSilent) {
            window.location = "./Logout.aspx";
            return;
        }
    }

    function doOnLoad() {
        // Check encryption
        if (isEncryptionOK() == false) {
            alert('The Team Password that you entered was incorrect.\n\nYou will be redirected back to the login page to try again.');
            setTimeout("doLogout(true);", 15);
            return false;
        }
            // Adjust a few buttons
            //document.getElementById("btnEditExisting").style.cursor = 'text';
            toggleEditButtons(false);
            // Select the year
            var theYear = document.getElementById("Hidden_SelectedYear").value;
            var theSelect = document.getElementById("yearDropdown");
            for (var i = 0; i < theSelect.options.length; i++) {
                if (theSelect.options[i].text == theYear) { theSelect.selectedIndex = i; break;}
            }
            document.getElementById("dispYear1").innerHTML = theYear;
            // Unencrypt people in pArr
            var pSortArr = new Array();
            for (var i in pArr) {
                var theKey = i;
                pArr[i] = unencryptItem(pArr[i]);
                pSortArr.push(pArr[i] + "^|^" + theKey);
            }
            // Sort the people array
            pSortArr.sort();
            pArr = new Array();
            for (var k = 0; k < pSortArr.length; k++) {
                var tmpArr = pSortArr[k].split("^|^");
                var theName = tmpArr[0];
                var theKey = tmpArr[1];
                pArr[theKey] = theName;
            }
            // Load EXISTING documents into the table
            updateExistingDocsTable();
            // Populate the options for the CREATE NEW area
            updateOptionsForCreateNew();
            // Make sure the "New Person" area is displaying correctly
            handlePersonChange(document.getElementById("personDropdown"));
            // Show a section
            showSection('EditExisting_Area');
            //showSection('CreateNew_Area');
        }





        function updateOptionsForCreateNew() {
            // Populate the people dropdown
            var theSelect = document.getElementById("personDropdown");
            theSelect.options.length = 2;
            for (var j in pArr) {
                var opt = document.createElement("option");
                opt.text = pArr[j];
                opt.value = j;
                theSelect.appendChild(opt);
            }
            // Load the Template Doc
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
            // Populate the Clause Selection table from the Template Doc
            var allClauseNodes = gTemplateDoc.getElementsByTagName("Clause");
            var theOutput = '<table class="initialClausesTable">';
            for (var i = 0; i < allClauseNodes.length; i++) {
                var theUUID = allClauseNodes[i].getAttribute("UUID");
                theOutput += '<tr><td class="initialClauseCell">';
                theOutput += '<input type="checkbox" id="cb_' + theUUID + '" name="clauseCheckboxGroup" value="' + theUUID + '"/>';
                theOutput += allClauseNodes[i].getAttribute("Title");
                theOutput += '</td></tr>';
            }
            theOutput += "</table>";
            document.getElementById("initialClauseSelectionArea").innerHTML = theOutput;
        }


        function updateExistingDocsTable() {
            // Write out the table rows
            var theOutput = '<table class="existingTable">';
            var docCount = 0;
            for (var i in pArr) {
                docCount = docCount + 1;
                var thePerson = pArr[i];
                for(var k in docArr[i]) {
                    var theActiveDate = docArr[i][k]['ActiveDate'];
                    var theStatus = docArr[i][k]['Status'];
                    var theCnNum = docArr[i][k]['CnNum'];
                    theOutput += '<tr id="existing_' + i + "_" + k + '" class="aRow" onclick="selectRow(this);" onmouseover="highlightThisRow(this);" onmouseout="unhighlightThisRow(this);">';
                    theOutput += '<td class="col_1">' + pArr[i] + '</td>';
                    theOutput += '<td class="col_2">' + theStatus + '</td>';
                    theOutput += '<td class="col_3">' + theActiveDate + '</td>';
                    theOutput += '<td class="col_4">' + theCnNum + '</td>';
                    theOutput += '<td class="col_5">&nbsp;</td>';
                    theOutput += '</tr>';
                }
            }
            if (docCount == 0) {
                theOutput += '<tr><td colspan="4"><span style="color: #999999;">There are no existing addendums for the selected Roster Year.</span></td></tr>';
            }
            theOutput += '</table>';
            document.getElementById('existingTable').innerHTML = theOutput;
        }

        function handleYearChange(theSelect) {
            var theYear = theSelect.options[theSelect.selectedIndex].value;
            document.getElementById("Hidden_SelectedYear").value = theYear;
            document.forms["form1"].submit();
        }

        function selectYear(theVal) {
            var yd = document.getElementById('yearDropdown');
            yd.selectedIndex = theVal;
            handleYearChange(yd);
        }


        function highlightThisRow(theRow) {
            if (theRow.id != g_selectedRowID) {
                //theRow.style.background = "#f8f987";
                theRow.style.background = "#f9ffb3";
            }
        }

        function unhighlightThisRow(theRow) {
            if (theRow.id != g_selectedRowID) {
                theRow.style.background = "transparent";
            }
        }

        function selectRow(theRow) {
            var selectedBackgroundColor = "yellow";
            if (theRow.id == g_selectedRowID) {
                theRow.style.background = "transparent";
                g_selectedRowID = "NA";
            } else {
                if (g_selectedRowID != "NA") { document.getElementById(g_selectedRowID).style.background = "transparent"; }
                theRow.style.background = selectedBackgroundColor;
                g_selectedRowID = theRow.id;
            }
            if (g_selectedRowID != "NA") {
                toggleEditButtons(true);
            } else {
                toggleEditButtons(false);
            }
        }

        function toggleEditButtons(isOn) {
            if (isOn) {
                document.getElementById("btnEditExisting").disabled = false;
                document.getElementById("btnEditExisting").className = 'btn_EditExisting_on';
            } else {
                document.getElementById("btnEditExisting").disabled = true;
                document.getElementById("btnEditExisting").className = 'btn_EditExisting_off';
            }
        }


        function validate_CreateNewForm() {
            // Validate the Person
            var thePersonField = document.getElementById("personDropdown");
            if (thePersonField.selectedIndex == 0) {
                alert('Please select a Player.\n\nIf the Player is not listed, select "New Player."');
                return false;
            }
            // If a New Person, validate the additional fields
            var thePersonID = thePersonField.options[thePersonField.selectedIndex].value;
            if (thePersonID == "NEW_NEW_NEW") {
                var thePersonNameField = document.getElementById("PersonName");
                thePersonNameField.value = trimThis(thePersonNameField.value);
                if (thePersonNameField.value == "") {
                    alert('Please specify a name for the New Player.');
                    thePersonNameField.focus();
                    return false;
                }
            }
            // Make sure at least one Year is selected
            var isOK = false;
            for (var i = 0; i < document.getElementById("form1").PersonYears.length; i++) {
                if (document.getElementById("form1").PersonYears[i].checked) {
                    isOK = true;
                }
            }
            if (isOK == false) {
                alert('Please select at least one Year that the Player will be expected to be with the team.');
                return false;
            }
            // Make sure at least one Clause is selected
            var isOK = false;
            if (typeof (document.getElementById("form1").clauseCheckboxGroup.length) == "undefined") {   // if there is only one clause
                if (document.getElementById("form1").clauseCheckboxGroup.checked) { isOK = true; }
            } else {
                for (var i = 0; i < document.getElementById("form1").clauseCheckboxGroup.length; i++) {
                    if (document.getElementById("form1").clauseCheckboxGroup[i].checked) {
                        isOK = true;
                    }
                }
            }
            if (isOK == false) {
                alert('Please select at least one Clause.');
                return false;
            }
            return true;
        }


        function createNewAddendum() {
            window.focus();
            // Validate the form
            var isOK = validate_CreateNewForm();
            if (!isOK) { return false;}
            submitNewAddendum();
            return;

          //  document.location = "./EditAddendum.aspx?DocID=NEW&Position=" + thePosition;
        }


        function handlePersonChange(theSelect) {
            var thePerson = theSelect.options[theSelect.selectedIndex].value;
            if (thePerson == "NEW_NEW_NEW") {
                document.getElementById("NewPlayerArea").style.display = "block";
                document.getElementById("NewPlayerArea").focus();
                return;
            } else {
                document.getElementById("NewPlayerArea").style.display = "none";
                return;
            }
        }

        function updateNewPersonName() {
            var firstName = trimThis(document.getElementById("PersonFirstName").value);
            document.getElementById("PersonFirstName").value = firstName;
            var lastName = trimThis(document.getElementById("PersonLastName").value);
            document.getElementById("PersonLastName").value = lastName;
            var fullName = "";
            if((lastName!="") && (firstName!="")) {
                fullName = lastName + ", " + firstName;
            } else {
                if(firstName != "" ) {fullName = firstName;}
                if(lastName != "") {fullName = lastName;}
            }
            document.getElementById("PersonName").value = fullName;
        }

        function editExisting() {
            var selectedID = g_selectedRowID.split("_")[2];
            document.location = "./EditAddendum.aspx?DocID=" + selectedID;
        }

        function copyExisting() {
            alert('This functionality is coming soon.');
        }

        function deleteExisting() {
            alert('This functionality is coming soon.');
        }


        function editMainTemplate() {
            if (g_canEditTemplate == "True") {
                document.location = "./EditAddendum.aspx?DocID=MainTemplate";
            } else {
                alert('You are not authorized to edit the template.\n\nTo request access to edit the template, please contact the primary account holder or the system administrator.');
            }
        }


        function showSection(theSection) {
            var allSections = new Array('EditExisting_Area', 'CreateNew_Area', 'EditTemplate_Area');
            for (var i = 0; i < allSections.length; i++) {
                document.getElementById(allSections[i]).style.display = "none";
            }
            document.getElementById(theSection).style.display = "block";
        }



        function submitNewAddendum() {
            // Load the Template Doc into a new document
            var newDoc = "";
            var templateText = document.getElementById("Hidden_AllClauses").value;
            templateText = unencryptItem(templateText);
            templateText = templateText.replace(/\'\'/g, "'");
            if (window.DOMParser) {
                parser = new DOMParser();
                newDoc = parser.parseFromString(templateText, "text/xml");
            } else {
                // Older Internet Explorer
                newDoc = new ActiveXObject("Microsoft.XMLDOM");
                newDoc.async = false;
                newDoc.loadXML(templateText);
            }
            // Remove any nodes that the user didn't select
            newDoc.documentElement.setAttribute("DocType", "A");
            var theNodes = newDoc.getElementsByTagName("Clause");
            for (var i = (theNodes.length-1); i >= 0; i--) {
                var clauseNode = theNodes[i];
                var clauseUUID = clauseNode.getAttribute("UUID");
                if (document.getElementById("cb_" + clauseUUID).checked == false) {
                    clauseNode.parentNode.removeChild(clauseNode);
                }
            }
            // Update attributes in the Addendum node
            var addendumNode = newDoc.getElementsByTagName("Addendum");
            // Handle the Person ID fields
            var thePersonID = "-1";
            var thePersonEID = document.getElementById("personDropdown").options[document.getElementById("personDropdown").selectedIndex].value;
            if (thePersonEID == "NEW_NEW_NEW") {
                thePersonID = "-2";
                thePersonEID = encryptItem(document.getElementById("PersonName").value);
            }
            addendumNode[0].setAttribute("PersonEID", thePersonEID);
            addendumNode[0].setAttribute("PersonID", "-1");
            addendumNode[0].setAttribute("StartingClause", g_defaultStartingClauseNumberForNewAddendum);
            // Update other values
            theCnNumber = "Not Assigned";
            var personYear = "";
            var personYearField = document.getElementById("form1").PersonYears;
            for (var i = 0; i < personYearField.length; i++) {
                if (personYearField[i].checked) {
                    if(personYear!="") {personYear += ",";}
                    personYear += personYearField[i].value;
                }
            }
            var effectiveDate = getTodaysDateAsSortableNumber();
            addendumNode[0].setAttribute("DocID", "NEW");
            addendumNode[0].setAttribute("PersonYear", personYear);
            addendumNode[0].setAttribute("Status", "Draft");
            addendumNode[0].setAttribute("EffectiveDate", effectiveDate);
            addendumNode[0].setAttribute("CreatedDate", effectiveDate);
            addendumNode[0].setAttribute("CnNumber", theCnNumber);
            // Assemble all of the parameters
            var paramArr = new Array();
            paramArr.push("NEW");  //docid
            paramArr.push(g_defaultStartingClauseNumberForNewAddendum); // starting clause
            paramArr.push(thePersonID);
            paramArr.push(thePersonEID);
            paramArr.push(personYear);
            paramArr.push("Draft");  // status
            paramArr.push("0");  // maxval
            paramArr.push(effectiveDate);
            paramArr.push("A");  // doctype
            paramArr.push(theCnNumber);  // CnNumber
            var theParams = paramArr.join("___");
            // Submit the data
            var theFrameDoc = document.getElementById("submitFormFrame").contentWindow;
            theFrameDoc.document.getElementById("Command1").value = "CreateNewAddendum";
            theFrameDoc.document.getElementById("Parameters1").value = theParams;
            var theXmlString = xml2Str(newDoc);
            theFrameDoc.document.getElementById("Data1").value = encryptItem(theXmlString);
            document.getElementById("statusMessage").innerHTML = '<span style="background: white;">Processing...&nbsp;&nbsp;&nbsp;</span>';
            setTimeout("document.getElementById('submitFormFrame').contentWindow.saveDocument3();", 15);

        }

        function createNew_Successful(theDocID) {
            document.getElementById("statusMessage").innerHTML = "Opening...&nbsp;&nbsp;&nbsp;";
            document.location = "./EditAddendum.aspx?DocID=" + theDocID;
        }


</script>

</head>









<body style="background-image:url('./img/BackgroundGray1.png');" onload="doOnLoad();">
    <form id="form1" runat="server">


<div class="headerContainer">
 <div class="header">
  <div id="forCentering1" style="width: 960px; margin-left: auto; margin-right: auto;">
    <img src="./img/Logo1.png" style="float: left; width: 76px; height: 75px;"/>
    <div class="headerTitle">&nbsp;&nbsp;Addendum Builder</div>
  </div>  <!-- end forCentering1 -->
 </div>  <!-- end header -->
 <div id="statusMessage" style="width: 960px; text-align: center; line-height: 22px; font-style: italic; background: transparent; margin-left: auto; margin-right: auto;">&nbsp;</div>
 </div>  <!-- end headerContainer div -->

<div class="mainContainer">
    <div id="topSpacer" style="height: 83px; padding: 0px; margin: 0px; border: 0px;">&nbsp;</div>
<div class="innerContainer">

<br/><br/>

<div id="centeringDiv" style="width: 100%; text-align: center;">


<table id="mainBodyLayout" style="width: 100%;">

    <tr>
        <td style="width: 20%; overflow: auto; vertical-align: top; text-align: center; background-image:url('./img/navMenuBG1.png'); background-repeat:no-repeat; background-position: 17px 10px;">
            <div id="navCreateNew" class="navButton" onclick="showSection('CreateNew_Area');">Create New</div>
            <div id="navEditExisting" class="navButton" onclick="showSection('EditExisting_Area');">View / Edit Existing</div>
            <div id="nav_2014" class="navButtonYear" onclick="selectYear(1);">2014</div>
            <div id="nav_2015" class="navButtonYear" onclick="selectYear(2);">2015</div>
            <div id="nav_2016" class="navButtonYear" onclick="selectYear(3);">2016</div>
            <div id="nav_2017" class="navButtonYear" onclick="selectYear(4);">2017</div>
            <div id="navEditTemplate" class="navButton" onclick="showSection('EditTemplate_Area');">Template Editor</div>
            <div style="visibility:hidden;"><br /><br />&nbsp;Roster Year:&nbsp;
                <select id="yearDropdown" onchange="handleYearChange(this);">
                <option value="2013">2013</option>
                <option value="2014">2014</option>
                <option value="2015">2015</option>
                <option value="2016">2016</option>
                <option value="2017">2017</option>
                <option value="2018">2018</option>
                <option value="2019">2019</option>
                <option value="2020">2020</option>
                <option value="2021">2021</option>
                <option value="2022">2022</option>
                <option value="2023">2023</option>
                </select>
            </div>
  <br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
        </td>
        <td style="width: 80%; overflow: auto; vertical-align: top;">


<!-- start CreateNew_Area -->
<div id="CreateNew_Area" style="display: none; margin-left: 50px;">
<div style="font-size: 24px;">Create a New Addendum</div><br /><br />
<table class="createNewAddendum">
  <tr>
    <td class="btn_CreateNew_Text">1. Select a Player:&nbsp;&nbsp;</td>
    <td>
      <select id="personDropdown" onchange="handlePersonChange(this);" style="width: 220px;">
        <option style="font-style: italic;" value="">Select...</option>
        <option value="NEW_NEW_NEW">New Player</option>
      </select>
    </td>
  </tr>
</table><br />
<div id="NewPlayerArea" style="width: 430px; display: none;">
  <table style="width: 100%;">
    <tr>
        <td style="width: 157px; text-align: right;"><br />Player Name:</td>
        <td style="width: 273px;"><br />
            <input id="PersonFirstName" placeholder="First Name" onchange="updateNewPersonName();" style="margin-left: 12px; width: 105px;" type="text" maxlength="124" value="" /><input id="PersonLastName" placeholder="Last Name" onchange="updateNewPersonName();" style="margin-left: 2px; width: 105px;" type="text" maxlength="124" value="" />
            <br />
            <input id="PersonName" style="display: none; margin-left: 12px; width: 218px;" type="text" maxlength="250" value="" />

        </td>
    </tr>
    <tr>
        <td style="width: 157px; text-align: right; vertical-align: top;"><br />Expected Year(s)<br />with the Team:</td>
        <td style="width: 273px;">
            <table style="margin-left: 6px; margin-top: 10px;">
                <tr><td>
                    <input name="PersonYears" type="checkbox" value="2014" checked="checked" />2014<br />
                    <input name="PersonYears" type="checkbox" value="2015" />2015<br />
                    <input name="PersonYears" type="checkbox" value="2016" />2016<br />
                </td><td>
                    <input name="PersonYears" type="checkbox" value="2017" />2017<br />
                    <input name="PersonYears" type="checkbox" value="2018" />2018<br />
                    <input name="PersonYears" type="checkbox" value="2019" />2019<br />
                </td></tr>
            </table>
        </td>
    </tr>
  </table>
</div>
<br />
<table class="createNewAddendum" style="background-color: #f8f8f8; color: black;">
    <tr><td><span class="btn_CreateNew_Text" style="color: black;">2. Start with these Clauses:</span></td></tr>
    <tr>
        <td style="width: 100%;">
            <div id="initialClausesContainer">
                <div id="initialClauseSelectionArea">&nbsp;</div>
            </div>
        </td>
    </tr>
    <tr>
        <td>
            <br /><br /><span class="btn_CreateNew_Text" style="color: black;">3. Create the Addendum:</span>&nbsp;&nbsp;<button class="CreateAddendumButton" type="button" onclick="createNewAddendum();">Go >></button>
        </td>
    </tr>
</table>
</div> <!-- end CreateNew_Area -->


<!-- start EditExisting_Area -->
<div id="EditExisting_Area" style="display: none; margin-left: 50px;">
<table class="existingTable_header">

  <tr><td colspan="3" style="font-size: 24px;">Existing Addendums - <span id="dispYear1">&nbsp;</span></td></tr>

  <tr><td colspan="3" style="font-size: 5px;">&nbsp;</td></tr>

  <tr class="headerRow"><td class="col_1_header">&nbsp;Addendum</td><td class="col_2_header">&nbsp;Status</td><td class="col_3_header">Contract Date</td><td class="col_4_header">Contract&nbsp;#</td><td class="col_5_header">&nbsp;</td></tr>

</table>
<div id="existingTable" class="existingTableContainer">
&nbsp;
</div> <!-- end existingTableContainer -->
<div id="editButtonText" style="width: 600px; text-align: center;">
  <br/>
  <button id="btnEditExisting" type="button" disabled="true" onclick="editExisting();">View/Edit</button>
  &nbsp;&nbsp;
</div>
</div><!-- end EditExisting_Area -->


<!-- start EditTemplate_Area -->
<div id="EditTemplate_Area" style="display: none; margin-left: 50px;">
<table class="existingTable_header">
  <tr><td style="font-size: 24px;">Template Editor</td></tr>
      <tr><td style="font-size: 5px;">&nbsp;</td></tr>
      <tr><td><button id="btnEditMainTemplate" type="button" onclick="editMainTemplate();">Edit Main Template</button></td></tr>
</table>
</div>  <!-- end EditTemplate_Area -->


        </td>
    </tr>

</table>


</div> <!-- end centeringDiv -->


<br/><br/>

<div id="adminArea" style="text-align: center; visibility: hidden;">
    <textarea runat="server" id="Hidden_AllClauses" cols="80" name="S2" rows="3"></textarea><br/>
    <iframe id="submitFormFrame" src="./SubmitData.aspx" style="width: 800px; height: 45px; background: white;"></iframe><br />
    <iframe id="keepAliveFrame" src="./KeepAlive.aspx" style="width: 800px; height: 25px; background: white;"></iframe><br />
</div>

  </div>  <!-- END adminArea div -->

    <asp:HiddenField ID="Hidden_SelectedYear" runat="server" />
    <br/><br/>


</div>  <!-- END innerContainer -->
</div>  <!-- END mainContainer -->



<div id="databaseResults" style="display: none;" runat="server">&nbsp;</div>


    </form>
</body>
</html>
