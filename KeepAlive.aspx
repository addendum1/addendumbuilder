<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="KeepAlive.aspx.cs" Inherits="ContractBuilder1.KeepAlive" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Keep Alive</title>

    <script type="text/javascript">

        function keepAlive_submit() {
            var kpText = new Date().toString();
            document.getElementById("kpText").value = kpText;
            document.forms[0].submit();
        }

        function doOnLoad() {
            setTimeout("keepAlive_submit();", 90000);
        }

    </script>

</head>
<body onload="doOnLoad();">
    <form id="form1" runat="server">
    <div>
    <input id="kpText" />
    </div>
    </form>
</body>
</html>
