Function 1Get-UDSystemUsers ()
{
    [CmdletBinding()]

    param (

        [Parameter(ValueFromPipelineByPropertyName)]
        $refreshInterval
    )

    $PageText = 'Users'
    $PageName = 'SystemUsers'

    $UDPage = New-UDPage -Name:($PageName) -Content {
        
        [int]$refreshInterval = $refreshInterval

        $PageLayout = '{"lg":[{"w":12,"h":3,"x":0,"y":0,"i":"grid-element-UsersDownload"},{"w":4,"h":10,"x":0,"y":4,"i":"grid-element-NewUsers"},{"w":4,"h":10,"x":4,"y":4,"i":"grid-element-UserState"},{"w":4,"h":10,"x":9,"y":4,"i":"grid-element-PrivilegedUsers"},{"w":4,"h":10,"x":0,"y":15,"i":"grid-element-MFAConfigured"},{"w":4,"h":10,"x":4,"y":15,"i":"grid-element-PasswordExpiration"},{"w":4,"h":10,"x":9,"y":15,"i":"grid-element-PasswordChanges"}]}'
        $unDrawColor = "#006cac"

        $LegendOptions = New-UDChartLegendOptions -Position bottom
        $Options = New-UDLineChartOptions -LegendOptions $LegendOptions

        New-UDCard -Title "Users" -Id "UsersDownload" -Content {
            $TotalUsers = Get-JCUser -returnProperties username | Measure-Object | Select-Object -ExpandProperty Count

            New-UDParagraph -Text "Displaying information from all users in your JumpCloud Organization. Displaying $TotalUsers users."
            New-UDButton -Icon 'cloud_download' -Text "Download All User Information" -OnClick {
                $DownloadsPath = '~' + '\' + 'Downloads'
                Set-Location $DownloadsPath
                Get-JCBackup -Users
                Show-UDToast -Message "User Information Downloaded To CSV In Downloads" -Duration 10000;
            }
        }

        New-UDGridLayout -Layout $PageLayout -Content {
            #SA-798/801 - New User Info

            New-UDElement -Tag "NewUsers" -Id "NewUsers" -RefreshInterval $refreshInterval -AutoRefresh -Endpoint {

                $Script:NewUsers = Get-JCUser -filterDateProperty created -dateFilter after  -date (Get-Date).AddDays(-14)
                if ($NewUsers)
                {
                    New-UDGrid -Title "New Users (Created in the last 14 days)"  -Headers @("Username", "Activated", "Created") -Properties @("Username", "Activated", "Created") -NoFilter -Endpoint {
                        $NewUsers | Sort-Object created -Descending | ForEach-Object {
                            [PSCustomObject]@{
                                Username  = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                                Activated = $(if ($_.activated) { New-UDIcon -Icon check } else { "" });
                                Created   = $_.created;
                            }
                        } | Out-UDGridData
                    } -NoExport
                }
                else
                {
                    New-UDCard -Title "New Users (Created in the last 14 days)" -Content {
                        New-UDunDraw -Name "add-user" -Color $unDrawColor
                        New-UDParagraph -Text "No new users have been added to your JumpCloud Organization in the past 14 days."
                    }
                }
            }
            
            New-UDElement -Tag "UserState" -Id "UserState" -RefreshInterval $refreshInterval -AutoRefresh -Endpoint {

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
            #SA-799 - Privileged User Info

            New-UDElement -Tag "PrivilegedUsers" -Id "PrivilegedUsers" -RefreshInterval $refreshInterval -AutoRefresh -Endpoint {

            
                $PrivilegedUsers = @()

                $Sudo = Get-JCUser -sudo $true

                $PrivilegedUsers += $Sudo

                $SambaService = Get-JCUser -samba_service_user $true

                $PrivilegedUsers += $SambaService

                $LdapBinding = Get-JCUser -ldap_binding_user $true

                $PrivilegedUsers += $LdapBinding

                $script:UniquePrivilegedUsers = $PrivilegedUsers | Sort-Object username -Unique

                if ($UniquePrivilegedUsers)
                {

                    New-UDGrid -Title "Privileged Users" -Properties @("Username", "GlobalAdmin", "LDAPBindUser", "SambaServiceUser") -NoFilter -Endpoint {


                        $UniquePrivilegedUsers | ForEach-Object {
                            [PSCustomObject]@{
                                Username         = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                                GlobalAdmin      = $(if ($_.sudo) { New-UDIcon -Icon check } else { "" });
                                LDAPBindUser     = $(if ($_.ldap_binding_user) { New-UDIcon -Icon check } else { "" });
                                SambaServiceUser = $(if ($_.samba_service_user) { New-UDIcon -Icon check } else { "" });
                            }
                        } | Out-UDGridData
                    } -NoExport

                }

                else
                {
                    New-UDCard -Title "Privileged Users"  -Content {
                        New-UDunDraw -Name "safe" -Color $unDrawColor
                        New-UDParagraph -Text "None of your users are configured as Global Admin, LDAP Bind, or Samba Service users."
                    }
                }
            }

            New-UDElement -Tag "MFAConfigured" -Id "MFAConfigured" -RefreshInterval $refreshInterval -AutoRefresh -Endpoint {

                New-UDChart -Title "User MFA Status"  -Type Doughnut -Options $Options -Endpoint {
                    Get-JCUser | Group-Object -Property totp_enabled, enable_user_portal_multifactor -NoElement | ForEach-Object {
                        [PSCustomObject]@{
                            Name  = $(if ($_.Name -eq "False, False") { "Not Required" } elseif ($_.Name -eq "False, True") { "Pending Configuration" } elseif ($_.Name -eq "True, False") { "Configured & Not Required" } elseif ($_.Name -eq "True, True") { "Configured & Required" });
                            Sort  = $(if ($_.Name -eq "False, False") { "1" } elseif ($_.Name -eq "False, True") { "2" } elseif ($_.Name -eq "True, False") { "3" } elseif ($_.Name -eq "True, True") { "4" });
                            Count = $_.Count;
                        }
                    } | Sort-Object -Property Sort | Out-UDChartData -LabelProperty "Name" -DataProperty "Count" -BackgroundColor @("#e54852", "#ffb000" , "#006cac", "#2cc692") -HoverBackgroundColor @("#e54852", "#ffb000" , "#006cac", "#2cc692")
                } -OnClick {
                    if ($EventData -ne "[]")
                    {
                        Show-UDModal -Content {
                            New-UDTabContainer -Tabs {
                                New-UDTab -Text "Not Required" -Content {
                                    New-UDGrid -Properties @("Username", "Email") -Endpoint {
                                        Get-JCUser -totp_enabled $False -enable_user_portal_multifactor $false | ForEach-Object {
                                            [PSCustomObject]@{
                                                Username = $_.username;
                                                Email    = $_.email;
                                            }
                                        } | Out-UDGridData
                                    }
                                }
                                New-UDTab -Text "Pending Configuration" -Content {
                                    New-UDGrid -Properties @("Username", "Email") -Endpoint {
                                        Get-JCUser -totp_enabled $False -enable_user_portal_multifactor $true | ForEach-Object {
                                            [PSCustomObject]@{
                                                Username = $_.username;
                                                Email    = $_.email;
                                            }
                                        } | Out-UDGridData
                                    }
                                }
                                New-UDTab -Text "Configured & Not Required" -Content {
                                    New-UDGrid -Properties @("Username", "Email") -Endpoint {
                                        Get-JCUser -totp_enabled $true -enable_user_portal_multifactor $False | ForEach-Object {
                                            [PSCustomObject]@{
                                                Username = $_.username;
                                                Email    = $_.email;
                                            }
                                        } | Out-UDGridData
                                    }
                                }
                                New-UDTab -Text "Configured & Required" -Content {
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
            }

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

    }


    
    #$UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('Users')
    Return [PSCustomObject]@{
        'UDPage' = $UDPage;
        #    'UDSideNavItem' = $UDSideNavItem;
    }
    
}