function UDElement-PasswordChanges ()
{
    param (
        [Parameter(Mandatory=$False)]
        $refreshInterval = 600,
        [Parameter(Mandatory =$False)]
        $unDrawColor = "#006cac"
    )

    New-UDElement -Tag "PasswordChanges" -Id "PasswordChanges" -RefreshInterval $refreshInterval -AutoRefresh -Endpoint {

        if ($JCSettings.SETTINGS.passwordPolicy.enablePasswordExpirationInDays -eq "True")
        {
            [int]$script:PasswordExpirationDays = $JCSettings.SETTINGS.passwordPolicy.passwordExpirationInDays

            [int]$script:PasswordExpirationDaysSearch = $PasswordExpirationDays - 14

            if (Get-JCUser -filterDateProperty password_expiration_date -dateFilter after -date (Get-Date).AddDays($PasswordExpirationDaysSearch) -returnProperties password_expiration_date, username)
            {
                New-UDGrid -Title "Recent Password Changes"  -Headers @("Username", "Password Change Date")-Properties @("Username", "ChangeDate") -Endpoint {
                    Get-JCUser -activated $true -filterDateProperty password_expiration_date -dateFilter after -date (Get-Date).AddDays($PasswordExpirationDaysSearch) -returnProperties password_expiration_date, username | Sort-object 'password_expiration_date' -Descending | ForEach-Object {
                        [PSCustomObject]@{
                            Username   = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                            ChangeDate = (Get-Date($_.password_expiration_date)).AddDays(-$PasswordExpirationDays)
                        }
                    } | Out-UDGridData
                }
            }

            else
            {
                New-UDCard -Title "Recent Password Changes"  -Content {
                    New-UDunDraw -Name "no-data" -Color $unDrawColor
                    New-UDParagraph -Text "No recent password changes"
                }
            }

        }
        else
        {
            New-UDCard -Title "Recent Password Changes"  -Content {
                New-UDunDraw -Name "alert" -Color $unDrawColor
                New-UDParagraph -Text "Password expiration must be enabled to view recent password changes."
            }
        }

    }

}