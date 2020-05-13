function UDElement-directoryinsights_userGroupChanges
{
    param(
        $refreshInterval,
        $unDrawColor,
        $eventDays
    )

    $Script:userGroupChangeEvents = Get-JCEvent -Service:('directory') -StartTime:((Get-Date).AddDays(-$eventDays)) -SearchTermAnd @{"event_type" = "association_change"; "association.connection.from.type" = "USER_GROUP"}
    New-UDElement -Tag "directoryinsights_userGroupChanges" -Id "directoryinsights_userGroupChanges" -RefreshInterval $refreshInterval -AutoRefresh -Content {
        New-UDGrid -Title "User Group Modifications" -Properties @("TargetType", "TargetName", "Action", "GroupName", "Timestamp") -Headers @("Target Type", "Target Name", "Action", "User Group Name", "Timestamp") -Endpoint {
            $userGroupChangeEvents | ForEach-Object {
                $(Get-GroupAssociationChange -event $_)
            } | Out-UDGridData
        }
    }
}
