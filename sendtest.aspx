<%@ Page Language="C#" Async="true" %>

<!DOCTYPE html>

<script runat="server">
    protected async void Page_Load(Object Src, EventArgs E)
    {
        try
        {
            string recipient = "emailto@domain.com";
            string senderemail = "emailfrom@domain.com";
            string sendername = "Senders Name";
            string subject = "Trying to use auth on emails";
            string message = "Trying to use auth on emails to send a message";
            await GmailServiceHelper.SendEmailAsync(senderemail, sendername, recipient, subject, message);

            lblStatus.Text = "Email Sent Successfully!";
        }
        catch (Exception ex)
        {
            lblStatus.Text = "Error: " + ex.Message;
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Literal ID="lblStatus" runat="server"></asp:Literal>
        </div>
    </form>
</body>
</html>
