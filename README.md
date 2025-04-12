# GmailCSharpServiceHelper
C# code for a asp.net webforms website to generate oauth tokens to send emails using gmail api
This code was created to allow a website contact form to use a Google workspace email as the SMTP server after Google removed support for app passwords and this code uses the Google API to send messages.

## 1. Setup Google Cloud for OAuth 2.0

### Step 1: Create a Google Cloud Project

1. Go to Google Cloud Console. https://console.cloud.google.com/
2. Create a new project (or use an existing one).

### Step 2: Enable Gmail API

1. Go to APIs & Services → Library. (Hamburger menu top left)
2. Search for Gmail API and enable it.

### Step 3: Configure OAuth Consent Screen

1. Go to APIs & Services → OAuth consent screen.
2. Click Get started
3. Enter the App Name and support email, use same name as project and click next
4. Select "External" and click next
5. Fill in the required details and save.

### Step 4: Create OAuth 2.0 Credentials

1. Go to APIs & Services → Credentials.
2. Click Create Credentials → OAuth client ID.
3. Select Web Application
4. Enter the domain name in the Authorised JavaScript origins
5. Enter the redirect URL in the Authorised redirect URIs. This needs to be the full path to the gettoken.aspx page on your website.
6. Save and on the list page click the download arrrow on the right side of the list and Download JSON (client_secret.json) on the popup window.
7. Move the client_secret.json to the App_Data/ folder in your website.
8. Save the Client ID and Client Secret  to use in the code below.


## 2. Install Required NuGet Packages

Install the following packages in your C# project:

    dotnet add package Google.Apis.Gmail.v1
    dotnet add package Google.Apis.Auth
    dotnet add package MimeKit
    dotnet add package Newtonsoft.Json


## 3. Implement OAuth Authentication

### 1. Authenticate and Get Access Token

1. Go to authorize.aspx, click the link, and authorize your account
2. gettoken.aspx will load and click the Get Token button
3. The refresh token is stored in token.json for future use

## 4. Sending a test email

    string recipient = "emailto@domain.com";
    string senderemail = "emailfrom@domain.com";
    string sendername = "Senders Name";
    string subject = "Trying to use auth on emails";
    string message = "Trying to use auth on emails to send a message";
    await GmailServiceHelper.SendEmailAsync(senderemail, sendername, recipient, subject, message);
