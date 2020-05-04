function UDElement-directoryinsights_userCreateDelete
{
    param (
        $refreshInterval,
        $unDrawColor
    )

    New-UDElement -Tag "directoryinsights_userCreateDelete" -Id "directoryinsights_userCreateDelete" -RefreshInterval $refreshInterval -Content {

        $Script:UserCreationDeletion = $Cache:DirectoryInsightsEvents | Where-Object { $_.event_type -eq "user_create" -or $_.event_type -eq "user_delete" }
        New-UDGrid -Title "User Creations and Deletions" -Properties @("Username", "Action", "Administrator", "Timestamp", "Info") -Headers @("Username", "Action", "Administrator", "Timestamp", "Info") -Endpoint {
            $UserCreationDeletion | ForEach-Object {
                [PSCustomObject]@{
                    Username = $_.resource.username;
                    Action = $(if ($_.event_type -eq "user_create") { "Created" } elseif ($_.event_type -eq "user_delete") { "Deleted" });
                    Administrator = $_.initiated_by.email;
                    Timestamp = $_.timestamp;
                    Info = New-UDButton -Text "More Info" -OnClick {$(Get-SingleEventModal -eventID $_.id)};
                }
            } | Out-UDGridData
        }
    }
}