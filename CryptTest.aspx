<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CryptTest.aspx.cs" Inherits="ContractBuilder1.CryptTest" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Crypt Test</title>

    
    <script src="./crypt/rollups/aes.js"></script>
    <script src="./crypt/rollups/sha256.js"></script>



    <script>

        g_passKey = "";

        function clearAll() {
            document.getElementById("theKey").value = "";
            document.getElementById("theHashedKey").value = "";
            //document.getElementById("theEncryptedKey").value = "";

            document.getElementById("theMessage").value = "";
            document.getElementById("theEncryptedResult").value = "";
            document.getElementById("theUnencryptedResult").value = "";
        }

        function hashTheKey() {
            var theMsg = document.getElementById("theKey").value;
            var theHash = CryptoJS.SHA256(theMsg);
            document.getElementById("theHashedKey").value = theHash;
        }

        function encryptTheHashedKey() {
            var theMsg = document.getElementById("theHashedKey").value;
            theMsg = encryptItem(theMsg);
            document.getElementById("theEncryptedKey").value = theMsg;
        }

        function storeTheEncryptedKey() {
            theMsg = document.getElementById("theEncryptedKey").value;
            createCookie("usrKey", theMsg, 1);
        }

        function getEncryptedKeyFromCookie() {
            var theMsg = readCookie("usrKey");
            if (theMsg == null) { alert('Cookie could not be read'); return false; }
            document.getElementById("theRetrievedEncryptedKey").value = theMsg;
        }

        function unencryptRetrievedKey() {
            var theMsg = document.getElementById("theRetrievedEncryptedKey").value;
            theMsg = decryptItem(theMsg);
            document.getElementById("theRetrievedUnencryptedKey").value = theMsg;
        }



        function encryptItem(theMsg) {
            var thePassKey = document.getElementById("theHashedKey").value;
            var encrypted = CryptoJS.AES.encrypt(theMsg, thePassKey);
            //alert(encrypted.key);        // 74eb593087a982e2a6f5dded54ecd96d1fd0f3d44a58728cdcd40c55227522223
            //alert(encrypted.iv);         // 7781157e2629b094f0e3dd48c4d786115
            //jalert(encrypted.salt);       // 7a25f9132ec6a8b34
            //alert(encrypted.ciphertext);
            return encrypted.toString();
        }

        function decryptItem(theMsg) {
            var thePassKey = document.getElementById("theHashedKey").value;
            var decrypted = CryptoJS.AES.decrypt(theMsg, thePassKey);
            decrypted = decrypted.toString(CryptoJS.enc.Utf8);
            return decrypted;
        }


        function test1() {
            var theMsg = document.getElementById("theMessage").value;
            var encTxt = encryptItem(theMsg);
            document.getElementById("theEncryptedResult").value = encTxt;
        }


        function test2() {
            var theMsg = document.getElementById("theEncryptedResult").value;
            var decTxt = decryptItem(theMsg);
            document.getElementById("theUnencryptedResult").value = decTxt;
        }


        function doOnLoad() {
            clearAll();
            document.getElementById("theKey").value = "bosco";
            g_passKey = "bosco";
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




    </script>

</head>
<body onload="doOnLoad();" style="background: #999999;">
    <form id="form1" runat="server">
    <div>
    <br />

        <button type="button" onclick="clearAll();">Clear All</button>

        <br /><br />

        User-supplied Key:<br />
        <input type="text" id="theKey"/><br />
        <button type="button" onclick="hashTheKey();">Hash the Key</button>
        <br /><br />

        Hashed Key:<br />
        <textarea id="theHashedKey" cols="150" rows="1"></textarea><br />
        <br />

        Message:<br />
        <textarea id="theMessage" cols="150" rows="4"></textarea><br />
        <button type="button" onclick="test1();">Encrypt</button>
        <br /><br />

        Encypted Result:<br />
        <textarea id="theEncryptedResult" cols="150" rows="4"></textarea><br />
        <button type="button" onclick="test2();">Unencrypt</button>
        <br /><br />

        And unencrypted back again:<br />
        <textarea id="theUnencryptedResult" cols="150" rows="4"></textarea>
        <br /><br />

    </div>
    </form>
</body>
</html>
