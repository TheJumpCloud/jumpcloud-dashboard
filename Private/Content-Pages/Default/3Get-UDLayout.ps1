Function 3Get-UDLayout ()
{
    $PageText = 'Layout'
    $PageName = 'Layout'

    $UDPage = New-UDPage -Name:($PageName) -Content {
        New-UDRow {

            New-UDColumn -Size 4 -Content {
                New-UDCard -Title "Details" -Text "These are some details about my dashboard" -Links @(New-UDLink -Url http://www.google.com -Text "Google a little more info")
            }
            New-UDColumn -Size 4 -Content {
                New-UDCard -Title "Details" -Text "These are some details about my dashboard" -Links @(New-UDLink -Url http://www.google.com -Text "Google a little more info")
            }
            New-UDColumn -Size 4 -Content {
                New-UDCard -Title "Upcoming Password Expiration" -Content {
                    New-UDunDraw -Name "my-password"
                    New-UDParagraph -Text "You have no users whose passwords will expire in the next 7 days!"
                }
            }

        }

        New-UDRow {
            New-UDCard -Title "Details" -Text "These are some details about my dashboard" -Links @(New-UDLink -Url http://www.google.com -Text "Google a little more info")
        }
    }

    $UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('Laptop')
    Return [PSCustomObject]@{
        'UDPage'        = $UDPage;
        'UDSideNavItem' = $UDSideNavItem;
    }
}