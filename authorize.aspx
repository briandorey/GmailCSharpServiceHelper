<%@ Page Language="C#" %>
<%@ Import Namespace="Google.Apis.Auth.OAuth2" %>
<%@ Import Namespace="System" %>
<script runat="server">
    protected void Page_Load(Object Src, EventArgs E)
    {
        string clientId = "ClientID";

        string redirectUri = "urn:ietf:wg:oauth:2.0:oob"; // For manual flow
        string scope = "https://www.googleapis.com/auth/gmail.send https://www.googleapis.com/auth/gmail.insert";

        var authorizationUrl = "https://accounts.google.com/o/oauth2/v2/auth" +
            "?client_id=" + clientId +
            "&response_type=code" +
            "&scope=" + scope + "" +
            "&redirect_uri=" + redirectUri +
            "&access_type=offline";

        lblStatus.Text = "<a href=" + authorizationUrl + " target='_blank'>Click here to authorize</a>";
    }
</script>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:Literal ID="lblStatus" runat="server"></asp:Literal>
    </form>
</body>
</html>