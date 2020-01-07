Function 1Get-UDSystemUsers ()
{
    [CmdletBinding()]

    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        $lastContactDays
    )

    $PageText = 'Users'
    $PageName = 'SystemUsers'
    $PageLayout = '{"lg":[{"w":4,"h":9,"x":0,"y":0,"i":"grid-element-NewUsers"},{"w":4,"h":9,"x":4,"y":0,"i":"grid-element-UserState"},{"w":4,"h":9,"x":9,"y":0,"i":"grid-element-PrivilegedUsers"},{"w":4,"h":9,"x":0,"y":10,"i":"grid-element-MFAConfigured"},{"w":4,"h":9,"x":4,"y":10,"i":"grid-element-PasswordExpiration"}]}'

    $LegendOptions = New-UDChartLegendOptions -Position bottom
    $Options = New-UDLineChartOptions -LegendOptions $LegendOptions

    $UDPage = New-UDPage -Name:($PageName) -Content {


        # Check to see if org has any registered systems
        $HasUsers = Get-JCUser -returnProperties username | Measure-Object

        if ($HasUsers.Count -eq 0)
        {

            New-UDRow {
                New-UDColumn -Size 6 {
                    New-UDCard -Title "No Users Registered" -Content {
                        New-UDParagraph -Text "To load the users dashboard create some users in your JumpCloud Administrator Console."
                        New-UDunDraw -Name "team-spirit"
                    } -Links @(New-UDLink -Url 'https://support.jumpcloud.com/support/s/article/getting-started-users1-2019-08-21-10-36-47' -Text "SEE: Getting Started - Users")
                }
            }
        }
        else
        {
            New-UDGridLayout -Layout $PageLayout -Resizable -Draggable -Content {
                #SA-798/801 - New User Info
                New-UDGrid -Title "New Users (Created in the last 14 days)" -Id "NewUsers" -Properties @("Username", "Email", "Created", "Activated") -Endpoint {
                    Get-JCUser -filterDateProperty created -dateFilter after  -date (Get-Date).AddDays(-14) | Sort-Object created -Descending | ForEach-Object {
                        [PSCustomObject]@{
                            Created   = $_.created;
                            Username  = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                            Email     = $_.email;
                            Activated = $(if ($_.activated) { New-UDIcon -Icon check } else { "" });
                        }
                    } | Out-UDGridData
                }
                #SA-796 - User State Info
                New-UDGrid -Title "User State Information" -Id "UserState" -Properties @("Username", "Email", "Suspended", "Expired", "Locked") -Endpoint {
                    $UserStates = @()

                    $LockedUsers = Get-JCUser -account_locked $true

                    $UserStates += $LockedUsers

                    $ExpiredUsers = Get-JCUser -password_expired $true

                    $UserStates += $ExpiredUsers

                    $SuspendedUsers = Get-JCUser -suspended $true

                    $UserStates += $SuspendedUsers

                    $UniqueUsers = $UserStates | Sort-Object username -Unique

                    $UniqueUsers | ForEach-Object {
                        [PSCustomObject]@{
                            Username  = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                            Suspended = $(if ($_.suspended) { New-UDIcon -Icon check } else { "" });
                            Expired   = $(if ($_.password_expired) { New-UDIcon -Icon check } else { "" });
                            Locked    = $(if ($_.account_locked) { New-UDIcon -Icon check } else { "" });
                        }
                    } | Out-UDGridData
                }
                #SA-799 - Privileged User Info
                New-UDGrid -Title "Privileged Users" -Id "PrivilegedUsers" -Headers @("Username", "Email", "Global Admin", "LDAP Bind User", "SambaServiceUser") -Properties @("Username", "Email", "GlobalAdmin", "LDAPBindUser", "SambaServiceUser") -Endpoint {
                    $PrivilegedUsers = @()

                    $Sudo = Get-JCUser -sudo $true

                    $PrivilegedUsers += $Sudo

                    $SambaService = Get-JCUser -samba_service_user $true

                    $PrivilegedUsers += $SambaService

                    $LdapBinding = Get-JCUser -ldap_binding_user $true

                    $PrivilegedUsers += $LdapBinding

                    $UniquePrivilegedUsers = $PrivilegedUsers | Sort-Object username -Unique
                    $UniquePrivilegedUsers | ForEach-Object {
                        [PSCustomObject]@{
                            Username         = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                            Email            = $_.email;
                            GlobalAdmin      = $(if ($_.sudo) { New-UDIcon -Icon check } else { "" });
                            LDAPBindUser     = $(if ($_.ldap_binding_user) { New-UDIcon -Icon check } else { "" });
                            SambaServiceUser = $(if ($_.samba_service_user) { New-UDIcon -Icon check } else { "" });
                        }
                    } | Out-UDGridData
                }
                New-UDChart -Title "MFA Configured" -Id "MFAConfigured" -Type Doughnut -RefreshInterval 60 -Options $Options -Endpoint {
                    Get-JCUser | Group-Object -Property totp_enabled, enable_user_portal_multifactor -NoElement | ForEach-Object {
                        [PSCustomObject]@{
                            Name  = $(if ($_.Name -eq "False, False") { "No MFA" } elseif ($_.Name -eq "False, True") { "MFA Required" } elseif ($_.Name -eq "True, False") { "MFA Configured" } elseif ($_.Name -eq "True, True") { "Completed" });
                            Count = $_.Count;
                        }
                    } | Out-UDChartData -LabelProperty "Name" -DataProperty "Count" -BackgroundColor @("#e54852", "#ffb000", "#006cac", "#2cc692") -HoverBackgroundColor @("#e54852", "#ffb000", "#006cac", "#2cc692")
                } -OnClick {
                    if ($EventData -ne "[]")
                    {
                        Show-UDModal -Content {
                            New-UDTabContainer -Tabs {
                                New-UDTab -Text "No MFA" -Content {
                                    New-UDGrid -Properties @("Username", "Email") -Endpoint {
                                        Get-JCUser -totp_enabled $False -enable_user_portal_multifactor $false | ForEach-Object {
                                            [PSCustomObject]@{
                                                Username = $_.username;
                                                Email    = $_.email;
                                            }
                                        } | Out-UDGridData
                                    }
                                }
                                New-UDTab -Text "MFA Required" -Content {
                                    New-UDGrid -Properties @("Username", "Email") -Endpoint {
                                        Get-JCUser -totp_enabled $False -enable_user_portal_multifactor $true | ForEach-Object {
                                            [PSCustomObject]@{
                                                Username = $_.username;
                                                Email    = $_.email;
                                            }
                                        } | Out-UDGridData
                                    }
                                }
                                New-UDTab -Text "MFA Configured" -Content {
                                    New-UDGrid -Properties @("Username", "Email") -Endpoint {
                                        Get-JCUser -totp_enabled $true -enable_user_portal_multifactor $False | ForEach-Object {
                                            [PSCustomObject]@{
                                                Username = $_.username;
                                                Email    = $_.email;
                                            }
                                        } | Out-UDGridData
                                    }
                                }
                                New-UDTab -Text "Completed" -Content {
                                    New-UDGrid -Properties @("Username", "Email") -Endpoint {
                                        Get-JCUser -totp_enabled $true -enable_user_portal_multifactor $true | ForEach-Object {
                                            [PSCustomObject]@{
                                                Username = $_.username;
                                                Email    = $_.email;
                                            }
                                        } | Out-UDGridData
                                    }
                                }
                            }
                        }
                    }
                }
                if ($JCSettings.SETTINGS.passwordPolicy.enablePasswordExpirationInDays)
                {
                    if (Get-JCUser -password_expired $False -filterDateProperty password_expiration_date -dateFilter before -date (Get-Date).AddDays(7))
                    {
                        New-UDGrid -Title "Upcoming Password Expirations" -Id "PasswordExpiration" -Headers @("Username", "Email", "Expiration Date")-Properties @("Username", "Email", "ExpirationDate") -Endpoint {
                            Get-JCUser -password_expired $False -filterDateProperty password_expiration_date -dateFilter before -date (Get-Date).AddDays(7) | ForEach-Object {
                                [PSCustomObject]@{
                                    Username       = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                                    Email          = $_.email;
                                    ExpirationDate = $_.password_expiration_date.ToLocalTime();
                                }
                            }
                        }
                    }
                    else
                    {
                        New-UDCard -Title "Upcoming Password Expiration" -Id "PasswordExpiration" -Content {
                            New-UDunDraw -Name "my-password"
                            New-UDParagraph -Text "You do not have any users whose password will expire in the next 7 days!"
                        }
                    }
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