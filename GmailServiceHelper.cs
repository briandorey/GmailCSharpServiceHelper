using Google.Apis.Auth.OAuth2;
using Google.Apis.Gmail.v1;
using Google.Apis.Services;
using MimeKit;
using Newtonsoft.Json.Linq;
using System;
using System.IO;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;

public class GmailServiceHelper
{
    private static async Task<string> GetAccessTokenAsync()
    {
        string tokenFilePath = HttpContext.Current.Server.MapPath("~/App_Data/token.json");
        if (!File.Exists(tokenFilePath)) throw new Exception("Token file not found!");

        var tokenData = JObject.Parse(File.ReadAllText(tokenFilePath));
        string refreshToken = tokenData["refresh_token"].ToString();
        if (string.IsNullOrEmpty(refreshToken)) throw new Exception("Refresh token not found!");

        string clientId = "YOUR_CLIENT_ID";
        string clientSecret = "YOUR_CLIENT_SECRET";
      
        var tokenRequest = new HttpClient();
        var requestBody = new System.Collections.Generic.Dictionary<string, string>
    {
        { "client_id", clientId },
        { "client_secret", clientSecret },
        { "refresh_token", refreshToken },
        { "grant_type", "refresh_token" }
    };

        var response = await tokenRequest.PostAsync("https://oauth2.googleapis.com/token",
            new FormUrlEncodedContent(requestBody));

        var jsonResponse = await response.Content.ReadAsStringAsync();
        var newTokenData = JObject.Parse(jsonResponse);

        tokenData["access_token"] = newTokenData["access_token"];
        File.WriteAllText(tokenFilePath, tokenData.ToString());

        // 🔹 DEBUG: Log the access token
        if (string.IsNullOrEmpty(tokenData["access_token"].ToString()))
            throw new Exception("Access token is null or empty!");

        return tokenData["access_token"].ToString();
    }

    public static async Task SendEmailAsync(string from, string fromname, string to, string subject, string body)
    {
        string accessToken = await GetAccessTokenAsync();

        var service = new GmailService(new BaseClientService.Initializer()
        {
            HttpClientInitializer = GoogleCredential.FromAccessToken(accessToken),
            ApplicationName = "yourappname"
        });

        var message = new MimeMessage();
        message.From.Add(new MailboxAddress(fromname, from));
        message.ReplyTo.Add(new MailboxAddress(fromname, from));
        message.To.Add(new MailboxAddress("", to));
        message.Subject = subject;

        message.Body = new TextPart("html") { Text = body };
     
        using (var memoryStream = new MemoryStream())
        {
            message.WriteTo(memoryStream);
            var rawMessage = Convert.ToBase64String(memoryStream.ToArray())
                .Replace('+', '-')
                .Replace('/', '_')
                .Replace("=", "");

            var gmailMessage = new Google.Apis.Gmail.v1.Data.Message
            {
                Raw = rawMessage
            };
            await service.Users.Messages.Send(gmailMessage, "me").ExecuteAsync();
        }
    }
}