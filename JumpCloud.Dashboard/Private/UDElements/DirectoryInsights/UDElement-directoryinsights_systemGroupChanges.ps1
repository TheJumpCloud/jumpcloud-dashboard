function UDElement-directoryinsights_systemGroupChanges
{
    param(
        $refreshInterval,
        $unDrawColor,
        $eventDays
    )

    $Script:systemGroupChangeEvents = Get-JCEvent -Service:('directory') -StartTime:((Get-Date).AddDays(-$eventDays)) -SearchTermAnd @{"event_type" = "association_change"; "association.connection.from.type" = "SYSTEM_GROUP"}
    New-UDElement -Tag "directoryinsights_systemGroupChanges" -Id "directoryinsights_systemGroupChanges" -RefreshInterval $refreshInterval -AutoRefresh -Content {
        New-UDGrid -Title "System Group Modifications" -Properties @("TargetType", "TargetName", "Action", "GroupName", "Timestamp") -Headers @("Target Type", "Target Name", "Action", "System Group Name", "Timestamp") -Endpoint {
            $systemGroupChangeEvents | ForEach-Object {
                $(Get-GroupAssociationChange -event $_)
            } | Out-UDGridData
        }
    }
}
