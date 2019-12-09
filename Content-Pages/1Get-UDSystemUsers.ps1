Function 1Get-UDSystemUsers () {
    $PageText = 'Users'
    $PageName = 'SystemUsers'
    $UDPage = New-UDPage -Name:($PageName) -Content {
        New-UDRow {
            New-UDColumn -Size 3 {
                $LegendOptions = New-UDChartLegendOptions -Position right
                $Options = New-UDLineChartOptions -LegendOptions $LegendOptions

                New-UDChart -Title "Active Users" -Type pie -RefreshInterval 60  -Endpoint {
                    try {
                        $object = @();
                        $object += [PSCustomObject]@{ "Enabled" = "Active"; "Data" = (Get-JCUser -activated $true).count }
                        $object += [PSCustomObject]@{ "Enabled" = "Pending"; "Data" = (Get-JCUser -activated $false).count }
                        $object | Out-UDChartData -DataProperty "Data" -LabelProperty "Enabled" -BackgroundColor @("#803AE8CE", "#80962F23") -HoverBackgroundColor @("#803AE8CE", "#80962F23")
                    }
                    catch {
                        0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                    }
                } -Options $Options

                # MFA Users
                New-UDChart -Title "MFA Enrollment" -Type pie -RefreshInterval 60  -Endpoint {
                    try {
                        $object = @();
                        $object += [PSCustomObject]@{ "Enabled" = "Active"; "Data" = (Get-JCUser -totp_enabled $true).count }
                        $object += [PSCustomObject]@{ "Enabled" = "Pending"; "Data" = (Get-JCUser -totp_enabled $false).count }
                        $object | Out-UDChartData -DataProperty "Data" -LabelProperty "Enabled" -BackgroundColor @("#803AE8CE", "#80962F23") -HoverBackgroundColor @("#803AE8CE", "#80962F23")
                    }
                    catch {
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
                New-UDGrid -Title "AD-Managed Users" -AutoRefresh -RefreshInterval 1 -Properties @("Username", "Email", "Disassociate") -Endpoint {
                    Get-JCUser -externally_managed $true | ForEach-Object {
                        [PSCustomObject]@{
                            Username     = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_.id)/details" -OpenInNewWindow);
                            Email        = $_.email;
                            Disassociate = (New-UDButton -Text "Disassociate" -OnClick {
                                    Set-JCUser $_.username -externally_managed $false;
                                    Show-UDToast -Message "User $($_.username) is no longer managed by AD!";
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


       
                 
       
                New-UDGrid -Title "Deleted Users (Deleted in the last 7 days)" -Properties @("Username", "First Name", "Last Name", "Email", "Deleted") -Endpoint {
                    # User Deletes
                    $IncrementType = "days" #hours, minutes are alternatives
                    $UTCOffset = 7
                    $IncrementAmount = 1
                    $StartDate = (Get-Date).AddDays(-7).AddHours($UTCOffset)
                    $EndDate = (Get-Date).AddHours($UTCOffset)
                    $EventsArray = @()
                         
                    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                    $TimeIncrements = Do {
                        $startDate = Switch ($IncrementType) {
                            'hours' { (Get-Date -Date:($startDate)).AddHours($IncrementAmount) }
                            'minutes' { (Get-Date -Date:($startDate)).AddMinutes($IncrementAmount) }
                            'days' { (Get-Date -Date:($startDate)).AddDays($IncrementAmount) }
                            Default { Write-Error ('Unknown increment value.') }
                        }
                        (Get-Date -Date:($startDate) -Format s)
                    }
                    Until ($startDate -ge $endDate)
                    For ($i = 1; $i -le $TimeIncrements.Length - 1; $i++) {
                        $startTime = ($TimeIncrements[$i - 1])
                        $endTime = ($TimeIncrements[$i])
                        Write-Host ('Pulling events from ' + $startTime + ' to ' + $endTime)
                        $UrlTemplate = 'https://events.jumpcloud.com/events?startDate={0}Z&endDate={1}Z'
                        $url = $UrlTemplate -f $startTime, $endTime
                        $hdrs = @{"X-API-KEY" = "a5b5e17089971807a2663080d9e2ee8b79325459" }
                        $events = Invoke-RestMethod -Method GET -Uri $url -Header $hdrs
                        if ($events) {
                            Write-Host ("$($events.count) " + 'events found in range ' + $startTime + ' to ' + $endTime )
                            $EventsArray += $events
                        }
                        $DeleteEvents = $EventsArray | Where-Object type -EQ 'systemusers' | Where-Object { $_.details.action -EQ 'DELETE' }
                       
                    }
                    $DeleteEvents | Sort-Object time -Descending | ForEach-Object {
                        [PSCustomObject]@{
                            Deleted  = $_.time;
                            Username = $_.details.document.username;
                            Email    = $_.details.document.email
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