
// Global variables
g_thePassKey = readCookie("TeamPass");


function encryptItem(theItem) {
  var encrypted = CryptoJS.AES.encrypt(theItem, g_thePassKey);
  return encrypted.toString();
}


function unencryptItem(theItem) {
  var decrypted = CryptoJS.AES.decrypt(theItem, g_thePassKey);
  decrypted = decrypted.toString(CryptoJS.enc.Utf8);
  return decrypted;
}




function updateFailed() {
  alert('An error occurred while attempting to process your request.\n\nPlease try your request again in a few minutes.  If the problem persists, contact the support resource associated to this product.');
  try {
    document.getElementById("statusMessage").innerHTML = "Error encountered - please try again in a few minutes.";
    setTimeout("clearStatusMessage();", 3000);
  } catch(er) {}
}

function clearStatusMessage() {
  document.getElementById("statusMessage").innerHTML = "&nbsp;";
}


function getTodaysDateAsSortableNumber() {
  if(typeof(g_todaysDate)!="undefined") {return g_todaysDate;}
  var dt= new Date();
  var theYear = dt.getFullYear();
  var theMonth = dt.getMonth() + 1;
  if (theMonth <= 9) { theMonth = "0" + theMonth; }
  var theDay = dt.getDate();
  if(theDay<=9) {theDay = "0" + theDay;}
  todaysDate = theYear + "-" + theMonth + "-" + theDay;
  return todaysDate;
}


function trimThis(str) {
  try {
     str = str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
  } catch (er) { };
     return str;
}


function xml2Str(xmlNode) {
  try {
     // Gecko- and Webkit-based browsers (Firefox, Chrome), Opera.
     return (new XMLSerializer()).serializeToString(xmlNode);
  } catch (e) {
     try {
        // Older Internet Explorer.
        return xmlNode.xml;
     } catch (e) {
        //Other browsers without XML Serializer
        return "ERROR ERROR ERROR";
     }
  }
  return false;
}



function generateUUID() {
  var d = new Date().getTime();
  var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
     var r = (d + Math.random() * 16) % 16 | 0;
     d = Math.floor(d / 16);
     return (c == 'x' ? r : (r & 0x7 | 0x8)).toString(16);
     });
  return uuid;
};


function padWithZeros(number, length) {
  // Add leading zeros to a positive number
  var str = '' + number;
  while (str.length < length) {
    str = '0' + str;
  }
  return str;
}



function getLongString(f) {
  return f.toString().
    replace(/^[^\/]+\/\*!?/, '').
    replace(/\*\/[^\/]+$/, '');
}


function capitalizeFirstLetterOfEachWord(str) {
    str = str.toLowerCase();
    var pieces = str.split(" ");
    for ( var i = 0; i < pieces.length; i++ )
    {
        var j = pieces[i].charAt(0).toUpperCase();
        pieces[i] = j + pieces[i].substr(1);
    }
    return pieces.join(" ");
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


