Function 1Get-UDSystemUsers ()
{
    $PageText = 'Users'
    $PageName = 'SystemUsers'
    $UDPage = New-UDPage -Name:($PageName) -Content {
        New-UDRow {
            New-UDColumn -Size 3 {
                $LegendOptions = New-UDChartLegendOptions -Position right
                $Options = New-UDLineChartOptions -LegendOptions $LegendOptions

                New-UDChart -Title "Active Users" -Type pie -RefreshInterval 60  -Endpoint {
                    try
                    {
                        $object = @();
                        $object += [PSCustomObject]@{ "Enabled" = "Active"; "Data" = (Get-JCUser -activated $true).count }
                        $object += [PSCustomObject]@{ "Enabled" = "Pending"; "Data" = (Get-JCUser -activated $false).count }
                        $object | Out-UDChartData -DataProperty "Data" -LabelProperty "Enabled" -BackgroundColor @("#803AE8CE", "#80962F23") -HoverBackgroundColor @("#803AE8CE", "#80962F23")
                    }
                    catch
                    {
                        0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                    }
                } -Options $Options

                # MFA Users
                New-UDChart -Title "MFA Enrollment" -Type pie -RefreshInterval 60  -Endpoint {
                    try
                    {
                        $object = @();
                        $object += [PSCustomObject]@{ "Enabled" = "Active"; "Data" = (Get-JCUser -totp_enabled $true).count }
                        $object += [PSCustomObject]@{ "Enabled" = "Pending"; "Data" = (Get-JCUser -totp_enabled $false).count }
                        $object | Out-UDChartData -DataProperty "Data" -LabelProperty "Enabled" -BackgroundColor @("#803AE8CE", "#80962F23") -HoverBackgroundColor @("#803AE8CE", "#80962F23")
                    }
                    catch
                    {
                        0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                    }
                } -Options $Options

                # Expired Users
                New-UDGrid -Title "Expired Users" -Properties @("Username", "Email") -Endpoint {
                    Get-JCUser -password_expired $true | ForEach-Object {
                        [PSCustomObject]@{
                            Username = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_.id)/details" -OpenInNewWindow);
                            Email    = $_.email
                        }
                    } | Out-UDGridData
                }
            
                # Suspended Users
                New-UDGrid -Title "Suspended Users" -Properties @("Username", "Email") -Endpoint {
                    Get-JCUser -suspended $true | ForEach-Object {
                        [PSCustomObject]@{
                            Username = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_.id)/details" -OpenInNewWindow);
                            Email    = $_.email
                        }
                    } | Out-UDGridData
                }
            }
            New-UDColumn -Size 6 {
                # Locked out Users
                New-UDGrid -Title "Locked Out Users" -AutoRefresh -RefreshInterval 1 -Properties @("Username", "Email", "Unlock") -Endpoint {
                    Get-JCUser -account_locked $true | ForEach-Object {
                        [PSCustomObject]@{
                            Username = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_.id)/details" -OpenInNewWindow);
                            Email    = $_.email;
                            Unlock   = (New-UDButton -Text "Unlock" -OnClick {
                                    Set-JCUser $_.username -account_locked $false;
                                    Show-UDToast -Message "User $($_.username) is unlocked!";
                                });
                        }
                    } | Out-UDGridData
                }

                # Password expirations in the next 30 days
                New-UDGrid -Title "Upcoming Password Expirations (Expiring in the next 30 days)" -Properties @("Username", "Email", "Password Expiration Date") -Endpoint {
                    Get-JCUser -filterDateProperty password_expiration_date -dateFilter before -date (Get-Date).AddDays(30) -returnProperties username, password_expiration_date, firstname, lastname, email  -password_expired $false -externally_managed $false -activated $true | Sort-Object password_expiration_date  -Descending | ForEach-Object {
                        [PSCustomObject]@{
                            "Password Expiration Date" = $_.password_expiration_date;
                            Username                   = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_.id)/details" -OpenInNewWindow);
                            Email                      = $_.email
                        }
                    } | Out-UDGridData
                }
            }

            New-UDColumn -Size 3 {
                # Users created in the last 30 days
                New-UDGrid -Title "New Users (Created in the last 30 days)" -Properties @("Username", "Email", "Created") -Endpoint {
                    Get-JCUser -filterDateProperty created -dateFilter after  -date (Get-Date).AddDays(-30) | Sort-Object created -Descending | ForEach-Object {
                        [PSCustomObject]@{
                            Created  = $_.created;
                            Username = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_.id)/details" -OpenInNewWindow);
                            Email    = $_.email
                        }
                    } | Out-UDGridData
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