<%@ Page Language="C#"  Async="true" %>
<%@ Import Namespace="Google.Apis.Auth.OAuth2" %>
<%@ Import Namespace="Google.Apis.Util.Store" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net.Http" %>
<%@ Import Namespace="System.Threading.Tasks" %>
<%@ Import Namespace="System.Security.Authentication" %>
<%@ Import Namespace="System.Net" %>
<!DOCTYPE html>

<script runat="server">
        protected async void btnGetToken_Click(object sender, EventArgs e)
    {

        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12; // .NET 4.5
        string authCode = txtAuthCode.Text.Trim();

        if (string.IsNullOrEmpty(authCode))
        {
            lblStatus.Text = "Authorization code is required.";
            return;
        }

        try
        {
            string clientId = "CLIENTID";
            string clientSecret = "CLIENTSECRET";
            string redirectUri = "urn:ietf:wg:oauth:2.0:oob";

            var tokenRequest = new HttpClient();
            var requestBody = new System.Collections.Generic.Dictionary<string, string>
            {
                { "code", authCode },
                { "client_id", clientId },
                { "client_secret", clientSecret },
                { "redirect_uri", redirectUri },
                { "grant_type", "authorization_code" }
            };

            var response = await tokenRequest.PostAsync("https://oauth2.googleapis.com/token",
                new FormUrlEncodedContent(requestBody));

            var jsonResponse = await response.Content.ReadAsStringAsync();

            File.WriteAllText(Server.MapPath("~/App_Data/token.json"), jsonResponse);

            lblStatus.Text = "Token received and saved!";
        }
        catch (Exception ex)
        {
            lblStatus.Text = "Error: " + ex.ToString();
        }
    }



</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:TextBox ID="txtAuthCode" runat="server" Width="400px"></asp:TextBox>
 <asp:Button ID="btnGetToken" runat="server" Text="Get Token" OnClick="btnGetToken_Click" />
 
 <br />
 <asp:Label ID="lblStatus" runat="server" ForeColor="Red"></asp:Label>
    </form>
</body>
</html>
