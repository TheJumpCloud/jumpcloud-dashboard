Function 1Get-UDSystemUsers () {
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

        if ($HasUsers.Count -eq 0) {

            New-UDRow {
                New-UDColumn -Size 6 {
                    New-UDCard -Title "No Users Registered" -Content {
                        New-UDParagraph -Text "To load the users dashboard create some users in your JumpCloud Administrator Console."
                        New-UDunDraw -Name "team-spirit"
                    } -Links @(New-UDLink -Url 'https://support.jumpcloud.com/support/s/article/getting-started-users1-2019-08-21-10-36-47' -Text "SEE: Getting Started - Users")
                }
            }
        }
        else {
            New-UDRow {
                New-UDColumn -Size 4 -Content {
                    #SA-798/801 - New User Info
                    New-UDGrid -Title "New Users (Created in the last 14 days)" -Properties @("Username", "Email", "Created", "Activated") -Endpoint {
                        Get-JCUser -filterDateProperty created -dateFilter after  -date (Get-Date).AddDays(-14) | Sort-Object created -Descending | ForEach-Object {
                            [PSCustomObject]@{
                                Created   = $_.created;
                                Username  = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                                Email     = $_.email;
                                Activated = $(if ($_.activated) { New-UDIcon -Icon check } else {""});
                            }
                        } | Out-UDGridData
                    }
                }
                New-UDColumn -Size 4 -Content {
                    #SA-796 - User State Info
                    New-UDGrid -Title "User State Information" -Properties @("Username", "Email", "Suspended", "Expired", "Locked") -Endpoint {
                        Get-JCUser | Where-Object { $_.account_locked -or $_.suspended -or $_.password_expired } | ForEach-Object {
                            [PSCustomObject]@{
                                Username = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                                Suspended = $(if ($_.suspended) { New-UDIcon -Icon check } else {""});
                                Expired = $(if ($_.password_expired) { New-UDIcon -Icon check } else {""});
                                Locked = $(if ($_.account_locked) { New-UDIcon -Icon check } else {""});
                            }
                        } | Out-UDGridData
                    }
                }
                New-UDColumn -Size 4 -Content {
                    #SA-799 - Privileged User Info
                    New-UDGrid -Title "Privileged Users" -Headers @("Username", "Email", "Global Admin", "LDAP Bind User") -Properties @("Username", "Email", "GlobalAdmin", "LDAPBindUser") -Endpoint {
                        Get-JCUser | Where-Object { $_.sudo -or $_.ldap_binding_user } | ForEach-Object {
                            [PSCustomObject]@{
                                Username     = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                                Email        = $_.email;
                                GlobalAdmin  = $(if ($_.sudo) { New-UDIcon -Icon check } else {""});
                                LDAPBindUser = $(if ($_.ldap_binding_user) { New-UDIcon -Icon check } else {""});
                            }
                        } | Out-UDGridData
                    }
                }
            }
            New-UDRow {
                if ($JCSettings.SETTINGS.passwordPolicy.enablePasswordExpirationInDays) {
                    New-UDColumn -Size 4 -Content { 
                        if (Get-JCUser -password_expired $False -filterDateProperty password_expiration_date -dateFilter before -date (Get-Date).AddDays(7)) {
                            New-UDGrid -Title "Upcoming Password Expirations" -Headers @("Username", "Email", "Expiration Date")-Properties @("Username", "Email", "ExpirationDate") -Endpoint {
                                Get-JCUser -password_expired $False -filterDateProperty password_expiration_date -dateFilter before -date (Get-Date).AddDays(7) | ForEach-Object {
                                    [PSCustomObject]@{
                                        Username       = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                                        Email          = $_.email;
                                        ExpirationDate = $_.password_expiration_date.ToLocalTime();
                                    }
                                }
                            }
                        }
                        else {
                            New-UDCard -Title "Upcoming Password Expiration" -Content {
                                New-UDunDraw -Name "my-password"
                                New-UDParagraph -Text "You do not have any users whose password will expire in the next 7 days!"
                            }
                        }
                    }                    
                }
                New-UDColumn -Size 4 -Content {
                    $LegendOptions = New-UDChartLegendOptions -Position bottom
                    $Options = New-UDLineChartOptions -LegendOptions $LegendOptions
                    New-UDChart -Title "MFA Configured" -Type Doughnut -RefreshInterval 60  -Endpoint {
                        try
                        {
                            Get-JCUser | Group-Object -Property totp_enabled, enable_user_portal_multifactor -NoElement | ForEach-Object {
                                [PSCustomObject]@{
                                    Name = $(if ($_.Name -eq "False, False") {"No MFA"} elseif ($_.Name -eq "False, True") {"MFA Required"} elseif ($_.Name -eq "True, False") {"MFA Configured"} elseif ($_.Name -eq "True, True") {"Completed"});
                                    Count = $_.Count;
                                }
                            } | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor @("#e54852", "#ffb000", "#006cac", "#2cc692") -HoverBackgroundColor @("#e54852", "#ffb000", "#006cac", "#2cc692")
                            
                        }
                        catch
                        {
                            0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                        }
                    } -Options $Options
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