$tenantId = "838f6c73-507b-4674-b621-d8dd0009208d"
$clientId = "84ace87e-3f92-47ad-89d3-08281190051b"
$clientSecret = ""

$body = @{
    grant_type    = "client_credentials"
    client_id     = $clientId
    client_secret = $clientSecret
    scope         = "https://graph.microsoft.com/.default"
}

$tokenResponse = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -ContentType "application/x-www-form-urlencoded" -Body $body
$appAccessToken = $tokenResponse.access_token
$appAccessToken

if (-not $appAccessToken) {
    Write-Output "Error: Failed to retrieve app access token."
    return
}

Write-Output "App-level access token obtained successfully."


$graphUri = "https://graph.microsoft.com/v1.0/users"
$usersResponse = Invoke-RestMethod -Method Get -Uri $graphUri -Headers @{ Authorization = "Bearer $appAccessToken" }
foreach ($user in $usersResponse.value) {
    Write-Output "User: $($user.displayName), Email: $($user.userPrincipalName)"
}

