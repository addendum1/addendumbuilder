<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Welcome.aspx.cs" Inherits="ContractBuilder1.Welcome" %>
<%@ Import Namespace="System.Web.Security" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Welcome</title>

    <script src="./crypt/rollups/aes.js"></script>
    <script src="./crypt/rollups/sha256.js"></script>


    <script type="text/javascript">
        function getUIDandPass() {
            var theU = document.getElementById("GetUserID").value;
            if (theU == "") { alert('The User ID cannot be blank.'); return false;}
            var theP = document.getElementById("GetUserPass").value;
            if (theP == "") { alert('Your password cannot be blank.'); return false; }
            var theTP = document.getElementById("GetTeamPass").value;
            if (theTP == "") { alert('The team password cannot be blank.'); return false; }

            hashAndCopy(theU, "UserID");
            hashAndCopy(theP, "UserPass");
            hashAndCopy(theTP, "TeamPass");

            createCookie("PTUserID", document.getElementById("GetUserID").value, 1);

            document.getElementById("Action").value = "Login";
            document.getElementById("GetUserID").value = "";
            document.getElementById("GetUserPass").value = "";
            document.getElementById("GetTeamPass").value = "";

            document.forms[0].submit();
        }

        function hashAndCopy(theVal,theFieldname) {
            var theHash = CryptoJS.SHA256(theVal);
            document.getElementById(theFieldname).value = theHash;
        }


        function createCookie(name, value, days) {
            if (days) {
                var date = new Date();
                date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
                var expires = "; expires=" + date.toGMTString();
            }
            else var expires = "";
            document.cookie = name + "=" + value + expires + "; path=/";
        }

        function readCookie(name) {
            var nameEQ = name + "=";
            var ca = document.cookie.split(';');
            for (var i = 0; i < ca.length; i++) {
                var c = ca[i];
                while (c.charAt(0) == ' ') c = c.substring(1, c.length);
                if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
            }
            return null;
        }

        function eraseCookie(name) {
            createCookie(name, "", -1);
        }


        function doOnLoad() {
            try {
                if (document.activeElement) {
                    var actElm = document.activeElement;
                    if ((actElm.id == "GetUserPass") || (actElm.id == "GetTeamPass")) {
                        // if the user is inputting a password, do nothing
                    } else {
                        // otherwise focus the name field
                        document.getElementById("GetUserID").focus();
                    }
                }
            } catch (er) { }
        }


    </script>

</head>
<body onload="doOnLoad();" style="font-family: Arial, sans-serif; font-size: 12px;">
    <form id="form1" runat="server">
        <br /><br /><br />
    <div style="width: 320px; padding: 20px; padding-top: 0px; padding-bottom: 0px; background: #CCCCCC; border: 1px solid #222222; margin-left: auto; margin-right: auto;">
        <h2>Welcome</h2>
    <table style="width: 100%;">
      <tr>
        <td style="width: 120px; font-weight: bold;">Your User ID:</td>
        <td style="width: 200px;"><asp:TextBox ID="GetUserID" runat="server" style="width: 190px;" /></td>
      </tr>
      <tr style="display: none;">
        <td style="width: 120px; font-weight: bold;">Hashed User ID:</td>
        <td style="width: 200px;"><asp:TextBox ID="UserID" runat="server" style="width: 190px;" /></td>
      </tr>
      <tr>
        <td style="font-weight: bold;">Your Password:</td>
        <td><asp:TextBox ID="GetUserPass" TextMode="Password" style="width: 190px;" runat="server" /></td>
      </tr>
      <tr style="display: none;">
        <td style="font-weight: bold;">Hashed User Password:</td>
        <td><asp:TextBox ID="UserPass" style="width: 190px;" runat="server" /></td>
      </tr>
      <tr>
        <td style="font-weight: bold;">Team Password:</td>
        <td><asp:TextBox ID="GetTeamPass" TextMode="Password" style="width: 190px;" runat="server" /></td>
      </tr>
      <tr style="display: none;">
        <td style="font-weight: bold;">Hashed Team Password:</td>
        <td><asp:TextBox ID="TeamPass" style="width: 190px;" runat="server" /></td>
      </tr>
      <tr style="display: none;">
        <td style="font-weight: bold;">Action:</td>
        <td><asp:TextBox ID="Action" style="width: 190px;" runat="server" /></td>
      </tr>
      <tr>
          <td>&nbsp;</td>
          <td><button type="button" onclick="getUIDandPass();">Submit</button></td>
      </tr>
    </table>
    <p>
      <asp:Label ID="Msg" ForeColor="red" runat="server" />
    </p>
    </div>
    </form>

    <script type="text/javascript">
        try {
            document.getElementById("GetTeamPass").addEventListener("keydown", function (e) {
                if (!e) { var e = window.event; }
                // Enter is pressed
                if (e.keyCode == 13) { getUIDandPass(); }
            }, false);
        } catch (er) { }

    </script>

</body>
</html>
