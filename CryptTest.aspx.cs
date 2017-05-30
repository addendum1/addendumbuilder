using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


using System.IO;
using System.Text;
using System.Security.Cryptography;


namespace ContractBuilder1
{
    public partial class CryptTest : System.Web.UI.Page
    {

        string EncryptionKey = "12345678901234567890123456789012";
        string HereSalt = "bca741cf4c9423e8";

        protected void Page_Load(object sender, EventArgs e)
        {


        }


        private string Decrypt(string cipherText, string theSalt)
        {
            byte[] cipherBytes = Convert.FromBase64String(cipherText);
            byte[] saltBytes = Convert.FromBase64String(theSalt);
            
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey,saltBytes);

                encryptor.Mode = CipherMode.CBC;
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                encryptor.Padding = PaddingMode.PKCS7;

                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(cipherBytes, 0, cipherBytes.Length);
                        cs.Close();
                    }
                    
                    cipherText = Encoding.Unicode.GetString(ms.ToArray());
                }
            }
            return cipherText;
        }



    }
}