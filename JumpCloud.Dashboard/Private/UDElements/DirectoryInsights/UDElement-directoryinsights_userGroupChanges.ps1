function UDElement-directoryinsights_userGroupChanges 
{
    param(
        $refreshInterval,
        $unDrawColor
    )

    $Script:userGroupChangeEvents = $Cache:DirectoryInsightsEvents | Where-Object { $_.event_type -eq "association_change" -and $_.association.connection.from.type -eq "USER_GROUP"}
    
    New-UDElement -Tag "directoryinsights_userGroupChanges" -Id "directoryinsights_userGroupChanges" -RefreshInterval $refreshInterval -AutoRefresh -Content {
        New-UDGrid -Title "User Group Modifications" -Properties @("TargetType", "TargetName", "Action", "GroupName", "Timestamp") -Headers @("Target Type", "Target Name", "Action", "User Group Name", "Timestamp") -Endpoint {
            $userGroupChangeEvents | ForEach-Object {
                $(Get-GroupAssociationChange -eventID $_.id)
            } | Out-UDGridData
        } 
    }
}
