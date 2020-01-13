Function 4Get-UDLayout ()
{
    $PageText = 'Layout'
    $PageName = 'Layout'

    $PageLayout = '{"lg":[{"w":4,"h":9,"x":0,"y":0,"i":"grid-element-MFAConfigured"},{"w":4,"h":9,"x":4,"y":0,"i":"grid-element-PrivilegedUsers"},{"w":4,"h":9,"x":0,"y":10,"i":"grid-element-UserStateInformation"},{"w":4,"h":9,"x":4,"y":10,"i":"grid-element-NewUsers"}]}'

    $UDPage = New-UDPage -Name:($PageName) -Content {

        New-UDGridLayout -Draggable -Resizable -Layout $PageLayout -Content {
            $LegendOptions = New-UDChartLegendOptions -Position bottom
            $Options = New-UDLineChartOptions -LegendOptions $LegendOptions
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
                                    Get-JCUser | Where-Object { -not $_.totp_enabled -and -not $_.enable_user_portal_multifactor } | ForEach-Object {
                                        [PSCustomObject]@{
                                            Username = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                                            Email    = $_.email;
                                        }
                                    } | Out-UDGridData
                                }
                            }
                            New-UDTab -Text "MFA Required" -Content {
                                New-UDGrid -Properties @("Username", "Email") -Endpoint {
                                    Get-JCUser | Where-Object { -not $_.totp_enabled -and $_.enable_user_portal_multifactor } | ForEach-Object {
                                        [PSCustomObject]@{
                                            Username = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                                            Email    = $_.email;
                                        }
                                    } | Out-UDGridData
                                }
                            }
                            New-UDTab -Text "MFA Configured" -Content {
                                New-UDGrid -Properties @("Username", "Email") -Endpoint {
                                    Get-JCUser | Where-Object { $_.totp_enabled -and -not $_.enable_user_portal_multifactor } | ForEach-Object {
                                        [PSCustomObject]@{
                                            Username = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                                            Email    = $_.email;
                                        }
                                    } | Out-UDGridData
                                }
                            }
                            New-UDTab -Text "Completed" -Content {
                                New-UDGrid -Properties @("Username", "Email") -Endpoint {
                                    Get-JCUser | Where-Object { $_.totp_enabled -and $_.enable_user_portal_multifactor } | ForEach-Object {
                                        [PSCustomObject]@{
                                            Username = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                                            Email    = $_.email;
                                        }
                                    } | Out-UDGridData
                                }
                            }
                        }
                    }
                }
            }
            # # New-UDChart - MFA Configured
            # New-UDGrid -Title "Privileged Users" -Id "PrivilegedUsers" -NoExport -Headers @("Username", "Email", "Global Admin", "LDAP Bind User") -Properties @("Username", "Email", "GlobalAdmin", "LDAPBindUser") -Endpoint {
            #     Get-JCUser | Where-Object { $_.sudo -or $_.ldap_binding_user } | ForEach-Object {
            #         [PSCustomObject]@{
            #             Username     = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
            #             Email        = $_.email;
            #             GlobalAdmin  = $(if ($_.sudo) { New-UDIcon -Icon check } else { "" });
            #             LDAPBindUser = $(if ($_.ldap_binding_user) { New-UDIcon -Icon check } else { "" });
            #         }
            #     } | Out-UDGridData
            # } # New-UDGrid - Privileged Users
            New-UDGrid -Title "User State Information" -Id "UserStateInformation" -NoExport -Properties @("Username", "Email", "Suspended", "Expired", "Locked") -Endpoint {
                Get-JCUser | Where-Object { $_.account_locked -or $_.suspended -or $_.password_expired } | ForEach-Object {
                    [PSCustomObject]@{
                        Username  = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                        Suspended = $(if ($_.suspended) { New-UDIcon -Icon check } else { "" });
                        Expired   = $(if ($_.password_expired) { New-UDIcon -Icon check } else { "" });
                        Locked    = $(if ($_.account_locked) { New-UDIcon -Icon check } else { "" });
                    }
                } | Out-UDGridData
            } # New-UDGrid - User State Information
            New-UDGrid -Title "New Users (Created in the last 14 days)" -Id "NewUsers" -NoExport -Properties @("Username", "Created", "Activated") -Endpoint {
                Get-JCUser -filterDateProperty created -dateFilter after  -date (Get-Date).AddDays(-14) | Sort-Object created -Descending | ForEach-Object {
                    [PSCustomObject]@{
                        Created   = $_.created;
                        Username  = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                        Activated = $(if ($_.activated) { New-UDIcon -Icon check } else { "" });
                    }
                } | Out-UDGridData
            } # New-UDGrid - New Users Created
        } # New-UDGridLayout
    } # New-UDPage


    $UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('Laptop')
    Return [PSCustomObject]@{
        'UDPage'        = $UDPage;
        'UDSideNavItem' = $UDSideNavItem;
    }
}