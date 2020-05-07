function Get-SingleEventModal
{
    param (
        $eventID
    )
    $Script:SingleEvent = $Cache:DirectoryInsightsEvents | Where-Object { $_.id -eq $eventID }
    
    Show-UDModal -Content {
        New-UDTable -Headers @(" ", " ") -Endpoint {
            @{
                'Initiated By' = "$($SingleEvent.initiated_by)"
                'GeoIP' = "$($SingleEvent.geoip)"
                'Resource' = "$($SingleEvent.resource)"
                'Changes' = "$($SingleEvent.changes | ConvertTo-Json)"
                'Authentication Method' = $SingleEvent.auth_method
                'Event Type' = $SingleEvent.event_type
                'Organization' = $SingleEvent.organization
                'Version' = $SingleEvent.'@version'
                'Event ID' = $SingleEvent.id
                'User Agent' = "$($SingleEvent.user_agent)"
                'Timestamp' = $SingleEvent.timestamp
            }.GetEnumerator() | Out-UDTableData -Property @("Name", "Value")
        }
    }
}