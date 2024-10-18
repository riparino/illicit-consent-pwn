$token = ""
$userEmail = ""
$graphApiUrl = "https://graph.microsoft.com/v1.0/users/$userEmail/messages"


$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}


$response = Invoke-RestMethod -Uri $graphApiUrl -Headers $headers -Method Get
$response.value | ForEach-Object {
    Write-Output "Subject: $($_.subject)"
    Write-Output "From: $($_.from.emailAddress.name)"
}