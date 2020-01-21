Function 1Get-UDSystemUsers ()
{
    [CmdletBinding()]

    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        $lastContactDays
    )

    $PageText = 'Users'
    $PageName = 'SystemUsers'
    $PageLayout = '{"lg":[{"w":12,"h":3,"x":0,"y":0,"i":"grid-element-UsersDownload"},{"w":4,"h":10,"x":0,"y":4,"i":"grid-element-NewUsers"},{"w":4,"h":10,"x":4,"y":4,"i":"grid-element-UserState"},{"w":4,"h":10,"x":9,"y":4,"i":"grid-element-PrivilegedUsers"},{"w":4,"h":10,"x":0,"y":15,"i":"grid-element-MFAConfigured"},{"w":4,"h":10,"x":4,"y":15,"i":"grid-element-PasswordExpiration"},{"w":4,"h":10,"x":9,"y":15,"i":"grid-element-PasswordChanges"}]}'

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
            New-UDGridLayout -Layout $PageLayout -Content {
                #SA-798/801 - New User Info
                $Script:NewUsers = Get-JCUser -filterDateProperty created -dateFilter after  -date (Get-Date).AddDays(-14)
                if ($NewUsers)
                {
                    New-UDGrid -Title "New Users (Created in the last 14 days)" -Id "NewUsers" -Properties @("Username", "Email", "Created", "Activated") -NoFilter -Endpoint {    
                        $NewUsers | Sort-Object created -Descending | ForEach-Object {
                            [PSCustomObject]@{
                                Created   = $_.created;
                                Username  = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                                Email     = $_.email;
                                Activated = $(if ($_.activated) { New-UDIcon -Icon check } else { "" });
                            }
                        } | Out-UDGridData
                    } -NoExport
                }
                else
                {
                    New-UDCard -Title "New Users (Created in the last 14 days)" -Id "NewUsers" -Content {
                        New-UDunDraw -Name "add-user"
                        New-UDParagraph -Text "No new users have been added your your JumpCloud Organization in the past 14 days."
                    }
                }
            
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
                    New-UDGrid -Title "User State Information" -Id "UserState" -Properties @("Username", "Email", "Suspended", "Expired", "Locked") -NoFilter -Endpoint {
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
                    New-UDCard -Title "User State Information" -Id "UserState" -Content {
                        New-UDunDraw -Name "celebration"
                        New-UDParagraph "None of your users are Suspended, Expired or Locked Out of their JumpCloud accounts!"
                    }
                }
                #SA-799 - Privileged User Info
                New-UDGrid -Title "Privileged Users" -Id "PrivilegedUsers" -Properties @("Username", "GlobalAdmin", "LDAPBindUser", "SambaServiceUser") -NoFilter -Endpoint {
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
                            Username         = $_.username;
                            GlobalAdmin      = $(if ($_.sudo) { New-UDIcon -Icon check } else { "" });
                            LDAPBindUser     = $(if ($_.ldap_binding_user) { New-UDIcon -Icon check } else { "" });
                            SambaServiceUser = $(if ($_.samba_service_user) { New-UDIcon -Icon check } else { "" });
                        }
                    } | Out-UDGridData
                } -NoExport
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
                    if (Get-JCUser -password_expired $False -filterDateProperty password_expiration_date -dateFilter before -date (Get-Date).AddDays(30))
                    {
                        New-UDGrid -Title "Upcoming Password Expirations" -Id "PasswordExpiration" -Headers @("Username", "Password Expiration Date")-Properties @("Username", "ExpirationDate") -Endpoint {
                            Get-JCUser -password_expired $False -filterDateProperty password_expiration_date -dateFilter before -date (Get-Date).AddDays(30) | Sort-Object "password_expiration_date" | ForEach-Object {
                                [PSCustomObject]@{
                                    Username       = $_.username;
                                    ExpirationDate = $_.password_expiration_date.ToLocalTime();
                                }
                            } | Out-UDGridData
                        }
                    }
                    else
                    {
                        New-UDCard -Title "Upcoming Password Expiration" -Id "PasswordExpiration" -Content {
                            New-UDunDraw -Name "my-password"
                            New-UDParagraph -Text "None of your users' passwords will expire in the next 30 days!"
                        }
                    }
                }
                else
                {
                    New-UDCard -Title "Upcoming Password Expiration" -Id "PasswordExpiration" -Content {
                        New-UDunDraw -Name "my-password"
                        New-UDParagraph -Text "Password Expiration is not enabled for your JumpCloud Organization."
                    }
                }


                if ($JCSettings.SETTINGS.passwordPolicy.enablePasswordExpirationInDays)
                {
                    [int]$script:PasswordExpirationDays = $JCSettings.SETTINGS.passwordPolicy.passwordExpirationInDays

                    [int]$script:PasswordExpirationDaysSearch = $PasswordExpirationDays - 14

                    if (Get-JCUser -filterDateProperty password_expiration_date -dateFilter after -date (Get-Date).AddDays($PasswordExpirationDaysSearch) -returnProperties password_expiration_date, username)
                    {
                        New-UDGrid -Title "Recent Password Changes" -Id "PasswordChanges" -Headers @("Username", "Password Change Date")-Properties @("Username", "ChangeDate") -Endpoint {
                            Get-JCUser -filterDateProperty password_expiration_date -dateFilter after -date (Get-Date).AddDays($PasswordExpirationDaysSearch) -returnProperties password_expiration_date, username | Sort-object 'password_expiration_date' -Descending | ForEach-Object {
                                [PSCustomObject]@{
                                    Username       = $_.username;
                                    ChangeDate = $_.password_expiration_date.ToLocalTime().AddDays(-$PasswordExpirationDays)
                                }
                            } | Out-UDGridData
                        }
                    }
                    else
                    {
                        New-UDCard -Title "Upcoming Password Expiration" -Id "PasswordExpiration" -Content {
                            New-UDunDraw -Name "my-password"
                            New-UDParagraph -Text "None of your users' passwords will expire in the next 30 days!"
                        }
                    }
                }
                else
                {
                    New-UDCard -Title "Upcoming Password Expiration" -Id "PasswordExpiration" -Content {
                        New-UDunDraw -Name "my-password"
                        New-UDParagraph -Text "Password Expiration is not enabled for your JumpCloud Organization."
                    }
                }


                New-UDCard -Title "Users" -Id "UsersDownload" -Content {
                    $TotalUsers = Get-JCUser -returnProperties username | Measure-Object | Select-Object -ExpandProperty Count

                    New-UDParagraph -Text "Displaying information from all users in your JumpCloud Organization. Displaying $TotalUsers users."
                    New-UDButton -Icon 'cloud_download' -Text "Download All User Information" -OnClick {
                        $DesktopPath = '~' + '\' + 'Desktop'
                        Set-Location $DesktopPath
                        Get-JCBackup -Users
                        Show-UDToast -Message "User Information Downloaded To CSV On Desktop" -Duration 10000;
                    }
                }
            }
        }
    }
    #$UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('Users')
    Return [PSCustomObject]@{
        'UDPage' = $UDPage;
        #    'UDSideNavItem' = $UDSideNavItem;
    }
}