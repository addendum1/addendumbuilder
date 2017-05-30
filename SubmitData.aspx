<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SubmitData.aspx.cs" Inherits="ContractBuilder1.SubmitData" validateRequest="false" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    
    
    <style type="text/css">
        .Text1 {
            width: 606px;
        }
        .TextArea1 {
            height: 320px;
            width: 614px;
        }
    </style>


   <%-- <script type="text/javascript" src="./scripts/jquery-1.10.0.js"></script>--%>


    <script type="text/javascript">
        
            function saveDocument3() {
                document.forms["form1"].submit();
            }


            function doOnLoad() {
                var theResponse = document.getElementById("Command1").value;
                eval(theResponse);
                document.getElementById("Command1").value = "";
            }

    </script>


</head>
<body onload="doOnLoad();">
    <form id="form1" runat="server">
    
        <input class="Text1" id="Command1" name="Command1" type="text" runat="server" />

            <br />
    
        <input class="Text1" id="Parameters1" name="Command2" type="text" runat="server" /><br/>
        <textarea class="TextArea1" id="Data1" name="Data1" runat="server"></textarea>
            <br/>
        <div id="responseArea" runat="server">
            &nbsp;
        </div>


        <%--<br /><br />
        <button type="button" onclick="saveDocument3();">TEST Submit</button>


        <br /><br />
        <asp:Button ID="submitButton" runat="server" OnClick="submitButton_Click" Text="Submit" />--%>

        <br /><br />
        <br /><br />
    </form>
</body>
</html>
