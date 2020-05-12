function UDElement-directoryinsights_systemCreateDelete
{
    param (
        $refreshInterval,
        $unDrawColor,
        $eventDays
    )

    New-UDElement -Tag "directoryinsights_systemCreateDelete" -Id "directoryinsights_systemCreateDelete" -RefreshInterval $refreshInterval -Content {

        $Script:SystemCreationDeletion = Get-JCEvent -Service:('directory') -StartTime:((Get-Date).AddDays(-$eventDays)) -SearchTermOr @{"event_type" = "system_create", "system_delete"}
        New-UDGrid -Title "System Creations and Deletions" -NoFilter -Properties @("Hostname", "Action", "Administrator", "Timestamp") -Headers @("Hostname", "Action", "Administrator", "Timestamp") -Endpoint {
            $SystemCreationDeletion | ForEach-Object {
                [PSCustomObject]@{
                    Hostname = $_.resource.hostname;
                    Action = $(if ($_.event_type -eq "system_create") { "Created" } elseif ($_.event_type -eq "system_delete") { "Deleted" });
                    Administrator = $_.initiated_by.email;
                    Timestamp = $_.timestamp;
                }
            } | Out-UDGridData
        }
    }
}