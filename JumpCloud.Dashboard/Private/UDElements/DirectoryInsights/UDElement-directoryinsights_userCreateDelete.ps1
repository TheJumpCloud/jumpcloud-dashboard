function UDElement-directoryinsights_userCreateDelete
{
    param (
        $refreshInterval,
        $unDrawColor,
        $eventDays
    )

    New-UDElement -Tag "directoryinsights_userCreateDelete" -Id "directoryinsights_userCreateDelete" -RefreshInterval $refreshInterval -Content {

        $Script:UserCreationDeletion = Get-JCEvent -Service:('directory') -StartTime:((Get-Date).AddDays(-30)) -SearchTermOr @{"event_type" = "user_create", "user_delete"}
        New-UDGrid -Title "User Creations and Deletions" -NoFilter -Properties @("Username", "Action", "Administrator", "Timestamp") -Headers @("Username", "Action", "Administrator", "Timestamp") -Endpoint {
            $UserCreationDeletion | ForEach-Object {
                [PSCustomObject]@{
                    Username = $_.resource.username;
                    Action = $(if ($_.event_type -eq "user_create") { "Created" } elseif ($_.event_type -eq "user_delete") { "Deleted" });
                    Administrator = $_.initiated_by.email;
                    Timestamp = $_.timestamp;
                    #Info = New-UDButton -Text "More Info" -OnClick {$(Get-SingleEventModal -eventID $_.id)};
                }
            } | Out-UDGridData
        }
    }
}