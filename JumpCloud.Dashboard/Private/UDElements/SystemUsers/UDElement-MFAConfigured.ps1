function UDElement-MFAConfigured ()
{
    param (
        $refreshInterval,
        $unDrawColor
    )

    New-UDElement -Tag "MFAConfigured" -Id "MFAConfigured" -RefreshInterval $refreshInterval -AutoRefresh -Endpoint {

        $LegendOptions = New-UDChartLegendOptions -Position bottom
        $Options = New-UDLineChartOptions -LegendOptions $LegendOptions

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
}