# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Application.Read.All"

# Output file path
$outputPath = ".\certnotifemailoutput.csv"

# Only enterprise apps (same tag the Entra portal uses for its Enterprise applications list)
$filter = "tags/any(t:t eq 'WindowsAzureActiveDirectoryIntegratedApp')"

# Getting enterprise apps AppID, DisplayName and Notification Email Address. Then exporting to CSV.
Get-MgServicePrincipal -All -Filter $filter -Property Id, AppId, DisplayName, NotificationEmailAddresses |
    Select-Object Id, AppId, DisplayName,
        @{Name = 'EmailAddresses'; Expression = { $_.NotificationEmailAddresses -join ';' }} |
    Sort-Object DisplayName |
    Export-Csv -Path $outputPath -NoTypeInformation -Encoding UTF8

# Confirmation of success
Write-Host "Export complete: $outputPath" -ForegroundColor Green