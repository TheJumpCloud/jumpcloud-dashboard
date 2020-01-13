# ### Poorly optimized functions for making a graph
# $web = (Invoke-WebRequest "https://en.wikipedia.org/wiki/MacOS" -UseBasicParsing | Select-Object -Property Content).Content 
# $almost = (($web.ToString() -split "[`r`n]" | Select-String "Latest release" | Select -First 1) -split ":")[6].Trim()
# $latest = [regex]::match($almost, '(Latest release<\/+a+>+<+\/+th><td>)(.*)(<sup id="cite_ref-3)').Groups[2].Value
# # $latest
# $mac = Get-JCSystemInsights -Table os_version | Select-Object name, version, system_id | Where-Object name -like "Mac OS *"
# $mac_group = $mac | Group-Object -Property version
# $notlatest = $mac | Where-Object version -NotLike $latest
# # $notlatest.Count
# $islatest = $mac | Where-Object version -Match $latest
# # $islatest.Count
# if ($islatest.Count -match 0) {
#     $p = 0
# }
# elseif ($islatest.Count -notmatch 0) {
#     $p = ($notlatest.Count * 100) / $islatest.Count
# }
Function 2Get-UDSystems ()
{
    $PageText = 'Systems'
    $PageName = 'Systems'
    $UDPage = New-UDPage -Name:($PageName) -Content {
        New-UDRow {
            New-UDColumn -size 6 {

                New-UDGrid -Title "Added in last 10 Days" -Properties @("Name") -Endpoint {
                    Get-JCSystem -filterDateProperty created -dateFilter after -date (Get-Date).AddDays(-10) -returnProperties hostname | ForEach-Object {
                        [PSCustomObject]@{
                            HostName = (New-UDLink -Text $_.hostname -Url "https://console.jumpcloud.com/#/systems/$($_.id)/details" -OpenInNewWindow);
                        }
                    } | Out-UDGridData
                }
                New-UDGrid -Title "No Contact in last 5 Days" -Properties @("Name", "Last Contant") -Endpoint {
                    Get-JCSystem | Where-Object { $_.lastContact -lt ((Get-Date).AddDays(-5)).ToUniversalTime() } | ForEach-Object {
                        [PSCustomObject]@{
                            HostName    = (New-UDLink -Text $_.hostname -Url "https://console.jumpcloud.com/#/systems/$($_.id)/details" -OpenInNewWindow);
                            LastContact = $_.lastContact;
                        }
                    } | Out-UDGridData
                }
                New-UDGrid -Title "Duplicate Systems" -Properties @("Name") -Endpoint {
                    Get-JCSystem | Group-Object serialNumber | Where-Object Count -gt 1 | Foreach { $_.Group | Sort-Object lastContact -Descending | Select-Object hostname, serialNumber | Select-Object -Skip 1 } | Group-Object serialNumber | ForEach-Object {
                        [PSCustomObject]@{
                            SerialNumber = (New-UDLink -Text $_.Name -Url "https://console.jumpcloud.com/#/systems/$($_.id)/details" -OpenInNewWindow);
                            Count        = $_.Count;
                        }
                    } | Out-UDGridData
                }
            }
            New-UDColumn -Size 6 {
                New-UDCollapsible -Items {
                    New-UDCollapsibleItem -Title "Operating System" -Icon arrow_circle_right -Content {
                        New-UDGrid -Title "OS Versions" -Properties @("Name", "Count") -Endpoint {
                            Get-JCSystem | Group-Object -Property version, os | Select-object Count, Name | ForEach-Object {
                                [PSCustomObject]@{
                                    OSName = $_.Name;
                                    Count  = $_.Count;
                                }
                            } | Out-UDGridData
                        }
                        $LegendOptions = New-UDChartLegendOptions -Position bottom
                        $Options = New-UDLineChartOptions -LegendOptions $LegendOptions
                        New-UDChart -Title "OS Type" -Type pie -RefreshInterval 60  -Endpoint {
                            try
                            {
                                Get-JCSystem | Group-Object -Property os | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor @("#8014558C", "#803AE8CE") -HoverBackgroundColor @("#8014558C", "#803AE8CE")
                            }
                            catch
                            {
                                0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                            }
                        } -Options $Options
                        New-UDChart -Title "OS Architecture" -Type pie -RefreshInterval 60 -Endpoint {
                            try
                            {
                                Get-JCSystem | Group-Object -Property arch | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor @("#8014558C", "#803AE8CE") -HoverBackgroundColor @("#8014558C", "#803AE8CE")
                            }
                            catch
                            {
                                0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                            }
                        } -Options $Options
                    }
                }
                New-UDCollapsible -Items {
                    New-UDCollapsibleItem -Title "All Systems" -Icon arrow_circle_right -Content {
                        New-UDChart -Title "System MFA By OS" -Type Bar -AutoRefresh -RefreshInterval 60 -Endpoint {
                            $AllSystems = Get-JCSystem
                            $object = @();
                            $object += [PSCustomObject]@{ "OperatingSystem" = "Windows 10"; "SystemMFAEnabled" = ($AllSystems | ? version -like '*10 *' | ? allowMultiFactorAuthentication -like 'true' ).count; "WPFDesigner" = ($AllSystems | ? version -like '*10 *' | ? allowMultiFactorAuthentication -like 'false').count; "Totalcount" = ($AllSystems | ? version -like '*10 *' | Select hostname).count }
                            $object += [PSCustomObject]@{ "OperatingSystem" = "Windows 8"; "SystemMFAEnabled" = ($AllSystems | ? version -like '*8 *' | ? allowMultiFactorAuthentication -like 'true' ).count; "WPFDesigner" = ($AllSystems | ? version -like '*8 *' | ? allowMultiFactorAuthentication -like 'false').count; "Totalcount" = ($AllSystems | ? version -like '*8 *' | Select hostname).count }
                            $object += [PSCustomObject]@{ "OperatingSystem" = "OSX"; "SystemMFAEnabled" = ($AllSystems | ? version -like '*10.*' | ? allowMultiFactorAuthentication -like 'true' ).count; "WPFDesigner" = ($AllSystems | ? version -like '*10.*' | ? allowMultiFactorAuthentication -like 'false').count; "Totalcount" = ($AllSystems | ? version -like '*10.*' | Select hostname).count }
                            $object | Out-UDChartData -LabelProperty "OperatingSystem" -Dataset @(
                                New-UDChartDataset -DataProperty "SystemMFAEnabled" -Label "MFA Enabled" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23"
                                New-UDChartDataset -DataProperty "WPFDesigner" -Label "MFA Not Enabled" -BackgroundColor "#8014558C" -HoverBackgroundColor "#8014558C"
                                New-UDChartDataset -DataProperty "Totalcount" -Label "Total" -BackgroundColor "#803AE8CE" -HoverBackgroundColor "#803AE8CE"
                            )
                        }
                        New-UDChart -Title "Current Status" -Type pie -RefreshInterval 60  -Endpoint {
                            try
                            {
                                $object = @();
                                $object += [PSCustomObject]@{ "Enabled" = "Active"; "Data" = (Get-JCSystem -active $true).count }
                                $object += [PSCustomObject]@{ "Enabled" = "Not Active"; "Data" = (Get-JCSystem -active $false).count }
                                $object | Out-UDChartData -DataProperty "Data" -LabelProperty "Enabled" -BackgroundColor @("#803AE8CE", "#80962F23") -HoverBackgroundColor @("#803AE8CE", "#80962F23")
                            }
                            catch
                            {
                                0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                            }
                        } -Options $Options
                        New-UDChart -Title "System Insights" -Type pie -RefreshInterval 60 -Endpoint {
                            try
                            {
                                $object = @();
                                $object += [PSCustomObject]@{ "Enabled" = "Enabled"; "Data" = (Get-JCSystem | Where-Object systemInsights -Like "*state=enabled*").count }
                                $object += [PSCustomObject]@{ "Enabled" = "Not Enabled"; "Data" = (Get-JCSystem | Where-Object systemInsights -NotLike "*state=enabled*").count }
                                $object | Out-UDChartData -DataProperty "Data" -LabelProperty "Enabled" -BackgroundColor @("#803AE8CE", "#80962F23") -HoverBackgroundColor @("#803AE8CE", "#80962F23")
                            }
                            catch
                            {
                                0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                            }
                        } -Options $Options
                        New-UDGrid -Title "JC Agent Version" -Properties @("Name", "Count")  -Endpoint {
                            Get-JCSystem | group-object agentVersion | select Count, Name | ForEach-Object {
                                [PSCustomObject]@{
                                    OSName = $_.Name;
                                    Count  = $_.Count;
                                }
                            } | Out-UDGridData
                        }
                    }
                }
                New-UDCollapsible -Items {
                    New-UDCollapsibleItem -Title "Mac Systems" -Icon arrow_circle_right -Content {
                        New-UDChart -Title "$p% of mac systems running $latest" -Type Pie -Endpoint {
                            $ph = (0, 0)
                            $results = $mac | Group-Object -Property Version
                            # Iterate through results, updating values if they exist
                            foreach ($item in $results)
                            {
                                if ($item.Version -like $latest)
                                {
                                    $ph[0] = $item.Count
                                }
                                elseif ($item.Version -notmatch $latest)
                                {
                                    $ph[1] = $notlatest.Count
                                }
                            }
                            $hash = [ordered]@{$latest = $ph[0]; "not $latest" = $ph[1] }
        
                            $hash | Out-UdChartData -DataProperty "Values" -BackgroundColor @("#80962F23", "#803AE8CE") -LabelProperty "Keys"
                        } -Options @{
                            legend = @{
                                display  = $true;
                                position = 'right'
                                labels   = @{
                                    # fontColor = '#000000'; 
                                    # fontSize  = 16
                                }
                            }
                    
                        }
                        New-UDChart -Title "OSX Filevault2 Key Escrowed" -Type pie -RefreshInterval 60  -Endpoint {
                            try
                            {
                                $object = @();
                                $object += [PSCustomObject]@{ "Enabled" = "FDEKeyPresent"; "Data" = (Get-JCSystem | ? fde -Like "*keyPresent=True; active=True*" | ? os -like *Mac*).fde.keyPresent.count }
                                $object += [PSCustomObject]@{ "Enabled" = "FDEKeyNotPresent"; "Data" = ((((Get-JCPolicyTargetSystem -PolicyName 'FileVault 2') | Select-Object HostName).Hostname.count) - ((Get-JCSystem | ? fde -Like "*keyPresent=True; active=True*" | ? os -like *Mac*).fde.keyPresent.count)) }
                                $object | Out-UDChartData -DataProperty "Data" -LabelProperty "Enabled" -BackgroundColor @("#80962F23", "#803AE8CE") -HoverBackgroundColor @("#80962F23", "#803AE8CE")
                            }
                            catch
                            {
                                0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                            }
                        } -Options $Options
                    } }
                New-UDCollapsible -Items {
                    New-UDCollapsibleItem -Title "Windows Systems" -Icon arrow_circle_right -Content {
                        New-UDChart -Title "Windows Bitlocker Key Escrowed" -Type pie -RefreshInterval 60 -Endpoint {
                            try
                            {
                                $object = @();
                                $object += [PSCustomObject]@{ "Enabled" = "FDEKeyPresent"; "Data" = (Get-JCSystem | ? fde -Like "*keyPresent=True; active=True*" | ? os -like *Windows*).fde.keyPresent.count }
                                $object += [PSCustomObject]@{ "Enabled" = "FDEKeyNotPresent"; "Data" = (((Get-JCPolicyTargetSystem -PolicyName 'Bitlocker Full Disk Encryption' | Select HostName).count) - ((Get-JCSystem | ? fde -Like "*keyPresent=True; active=True*" | ? os -like *Windows*).fde.keyPresent.count)) }
                                $object | Out-UDChartData -DataProperty "Data" -LabelProperty "Enabled" -BackgroundColor @("#80962F23", "#803AE8CE") -HoverBackgroundColor @("#80962F23", "#803AE8CE")
                            }
                            catch
                            {
                                0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                            }
                        } -Options $Options
                    } }
                New-UDRow {
                    New-UDColumn -Size 6 {
                    }
                }
            }
            New-UDColumn -Size 3 {
                $LegendOptions = New-UDChartLegendOptions -Position bottom
                $Options = New-UDLineChartOptions -LegendOptions $LegendOptions
            }
        }
    }
    $UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('Laptop')
    Return [PSCustomObject]@{
        'UDPage'        = $UDPage;
        'UDSideNavItem' = $UDSideNavItem;
    }
}