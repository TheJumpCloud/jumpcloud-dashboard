
function UDElement-user_userStates ()
{
    param (
        $refreshInterval,
        $unDrawColor
    )

    New-UDElement -Tag "user_userStates" -Id "user_userStates" -RefreshInterval $refreshInterval -AutoRefresh -Endpoint {

        #SA-796 - User State Info
        $UserStates = @()

        $LockedUsers = Get-JCUser -account_locked $true

        $UserStates += $LockedUsers

        $ExpiredUsers = Get-JCUser -password_expired $true

        $UserStates += $ExpiredUsers

        $SuspendedUsers = Get-JCUser -suspended $true

        $UserStates += $SuspendedUsers

        $Script:UniqueUsers = $UserStates | Sort-Object username -Unique

        if ($UniqueUsers)
        {
            New-UDGrid -Title "User State Information" -Properties @("Username", "Email", "Suspended", "Expired", "Locked") -NoFilter -Endpoint {
                $UniqueUsers | ForEach-Object {
                    [PSCustomObject]@{
                        Username  = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                        Suspended = $(if ($_.suspended) { New-UDIcon -Icon check } else { "" });
                        Expired   = $(if ($_.password_expired) { New-UDIcon -Icon check } else { "" });
                        Locked    = $(if ($_.account_locked) { New-UDIcon -Icon check } else { "" });
                    }
                } | Out-UDGridData
            } -NoExport
        }
        else
        {

            New-UDCard -Title "User State Information" -Content {
                New-UDunDraw -Name "celebration" -Color $unDrawColor
                New-UDParagraph -Text "None of your users are Suspended, Expired, or Locked Out of their JumpCloud accounts!"
            }
        }
    }
}

