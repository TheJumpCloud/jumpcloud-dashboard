function UDElement-directoryinsights_groupChanges 
{
    param(
        $refreshInterval,
        $unDrawColor
    )

    $Script:groupChangeEvents = $Cache:DirectoryInsightsEvents | Where-Object { $_.event_type -eq "association_change" }
    
    New-UDElement -Tag "directoryinsights_groupChanges" -Id "directoryinsights_groupChanges" -RefreshInterval $refreshInterval -AutoRefresh -Content {
        New-UDGrid -Title "Group Modifications" -Properties @("Event", "Timestamp") -Headers @("Event", "Timestamp") -Endpoint {
            $groupChangeEvents | ForEach-Object {
                [PSCustomObject]@{
                    Event = $(Get-GroupAssociationChange -eventID $_.id);
                    Timestamp = $_.timestamp;
                }
            } | Out-UdGridData
        }
    }
}