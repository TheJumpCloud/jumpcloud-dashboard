function UDElement-directoryinsights_userCreateDelete
{
    param (
        $refreshInterval,
        $unDrawColor
    )

    New-UDElement -Tag "directoryinsights_userCreateDelete" -Id "directoryinsights_userCreateDelete" -RefreshInterval $refreshInterval -Content {

        $Script:UserCreationDeletion = $Cache:DirectoryInsightsEvents | Where-Object { $_.event_type -eq "user_create" -or $_.event_type -eq "user_delete" }
        New-UDGrid -Title "User Creations and Deletions" -Properties @("Username", "Action", "Administrator") -Headers @("Username", "Action", "Administrator") -Endpoint {
            $UserCreationDeletion | ForEach-Object {
                [PSCustomObject]@{
                    Username = $_.resource.username;
                    Action = $(if ($_.event_type -eq "user_create") { "Created" } elseif ($_.event_type -eq "user_delete") { "Deleted" });
                    Administrator = $_.initiated_by.email;
                }
            } | Out-UDGridData
        }
    }
}