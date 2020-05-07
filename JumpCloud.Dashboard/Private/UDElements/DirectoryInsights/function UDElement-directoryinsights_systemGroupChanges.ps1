function UDElement-directoryinsights_systemGroupChanges 
{
    param(
        $refreshInterval,
        $unDrawColor
    )

    $Script:systemGroupChangeEvents = $Cache:DirectoryInsightsEvents | Where-Object { $_.event_type -eq "association_change" -and $_.association.connection.from.type -eq "SYSTEM_GROUP"}
    
    New-UDElement -Tag "directoryinsights_systemGroupChanges" -Id "directoryinsights_systemGroupChanges" -RefreshInterval $refreshInterval -AutoRefresh -Content {
        New-UDGrid -Title "System Group Modifications" -Properties @("TargetType", "TargetName", "Action", "GroupName", "Timestamp") -Headers @("Target Type", "Target Name", "Action", "System Group Name", "Timestamp") -Endpoint {
            $systemGroupChangeEvents | ForEach-Object {
                $(Get-GroupAssociationChange -eventID $_.id)
            } | Out-UDGridData
        } 
    }
}
