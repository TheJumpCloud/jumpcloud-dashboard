function UDElement-PasswordExpiration ()
{
    param (
        [Parameter(Mandatory=$False)]
        $refreshInterval = 600,
        [Parameter(Mandatory =$False)]
        $unDrawColor = "#006cac"
    )
    
    New-UDElement -Tag "PasswordExpiration" -Id "PasswordExpiration" -RefreshInterval $refreshInterval -AutoRefresh -Endpoint {

        if ($JCSettings.SETTINGS.passwordPolicy.enablePasswordExpirationInDays)
        {
            if (Get-JCUser -password_expired $False -filterDateProperty password_expiration_date -dateFilter before -date (Get-Date).AddDays(30))
            {
                New-UDGrid -Title "Upcoming Password Expirations"  -Headers @("Username", "Password Expiration Date")-Properties @("Username", "ExpirationDate") -Endpoint {
                    Get-JCUser -password_expired $False -filterDateProperty password_expiration_date -dateFilter before -date (Get-Date).AddDays(30) | Sort-Object "password_expiration_date" | ForEach-Object {
                        [PSCustomObject]@{
                            Username       = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                            ExpirationDate = (Get-Date($_.password_expiration_date)).ToLocalTime();
                        }
                    } | Out-UDGridData
                }
            }
            else
            {
                New-UDCard -Title "Upcoming Password Expirations" -Content {
                    New-UDunDraw -Name "my-password" -Color $unDrawColor
                    New-UDParagraph -Text "None of your users' passwords will expire in the next 30 days!"
                }
            }
        }
        else
        {
            New-UDCard -Title "Upcoming Password Expirations"  -Content {
                New-UDunDraw -Name "my-password" -Color $unDrawColor
                New-UDParagraph -Text "Password expiration is not enabled for your JumpCloud Organization."
            }
        }
    }
}