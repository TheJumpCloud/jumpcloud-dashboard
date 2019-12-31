Function 1Get-UDSystemUsers ()
{
    [CmdletBinding()]

    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        $lastContactDays
    )

    $PageText = 'Users'
    $PageName = 'SystemUsers'
    $UDPage = New-UDPage -Name:($PageName) -Content {

        # Check to see if org has any registered systems
        $HasUsers = Get-JCUser -returnProperties username | Measure-Object

        if ($HasUsers.Count -eq 0)
        {
            New-UDRow {
                New-UDCard -Title "No Users Registered" -Text "To load the users dashboard create some users in your JumpCloud Administrator Console." -Links @(New-UDLink -Url 'https://support.jumpcloud.com/support/s/article/getting-started-users1-2019-08-21-10-36-47' -Text "SEE: Getting Started - Users")
            }
        }
        else
        {
            New-UDRow {
                New-UDColumn -Size 4 -Content {
                    #SA-798/801 - New User Info
                    New-UDGrid -Title "New Users (Created in the last 14 days)" -Properties @("Username", "Email", "Created", "Activated") -Endpoint {
                        Get-JCUser -filterDateProperty created -dateFilter after  -date (Get-Date).AddDays(-14) | Sort-Object created -Descending | ForEach-Object {
                            [PSCustomObject]@{
                                Created  = $_.created;
                                Username = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                                Email    = $_.email;
                                Activated = $_.activated;
                            }
                        } | Out-UDGridData
                    }
                }
                New-UDColumn -Size 4 -Content {
                    #SA-796 - User State Info
                    New-UDGrid -Title "User State Information" -Properties @("Username", "Email", "State") -Endpoint {
                        Get-JCUser | Where-Object {$_.account_locked -or $_.suspended -or $_.password_expired} | ForEach-Object {
                            [PSCustomObject]@{
                                Username = $_.username;
                                Email = $_.email;
                                State = $(if ($_.suspended){"Suspended"} elseif ($_.password_expired) {"Password Expired"} elseif ($_.account_locked){"Account Locked"} else {""});
                            }
                        } | Out-UDGridData
                    }
                }
                New-UDColumn -Size 4 -Content {
                    
                }
            }

           
        }
    }
    $UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('Users')
    Return [PSCustomObject]@{
        'UDPage'        = $UDPage;
        'UDSideNavItem' = $UDSideNavItem;
    }
}