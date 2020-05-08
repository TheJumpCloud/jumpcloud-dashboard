function UDElement-directoryinsights_userPortalAuth
{
    param (
        $refreshInterval,
        $unDrawClor,
        $eventDays
    )

    $Script:userPortalAuthEvents = $Cache:DirectoryInsightsEvents | Where-Object { $_.event_type -eq "user_login_attempt" }
    
    New-UDElement -Tag "directoryinsights_userPortalAuth" -Id "directoryinsights_userPortalAuth" -RefreshInterval $refreshInterval -AutoRefresh -Content {

        $LegendOptions = New-UDChartLegendOptions -Position bottom
        $CircleChartOptions = New-UDLineChartOptions -LegendOptions $LegendOptions

        New-UDChart -Title "User Portal Authentication Attempts" -Type Doughnut -AutoRefresh -RefreshInterval $refreshInterval -Endpoint {
            try
            {
                $userPortalAuthEvents | Group-Object success | ForEach-Object {
                    [PSCustomObject]@{
                        Name = $(if ($_.Name -eq "True") { "Success" } elseif ($_.Name -eq "False") { "Failure" });
                        Count = $_.Count;
                    }
                } | Select-Object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor @("#2cc692", "#e54852") -HoverBackgroundColor @("#2cc692", "#e54852")
            }
            catch
            {
                0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
            }
        } -Options $CircleChartOptions -OnClick {
            if ($EventData -ne "[]")
            {
                Show-UDModal -Content {
                    New-UDTabContainer -Tabs {
                        New-UDTab -Text "Success" -Content {
                            New-UDGrid -Properties @("Username", "Attempt", "Timestamp") -Endpoint {
                                $userPortalAuthEvents | Where-Object { $_.success -eq $true } | ForEach-Object {
                                    [PSCustomObject]@{
                                        Username = $_.initiated_by.username;
                                        Attempt = $(if ($_.success -eq "True") { "Success" } elseif ($_.success -eq $false) { "Failure" });
                                        Timestamp = $_.timestamp;
                                    }
                                } | Out-UDGridData
                            }
                        }
                        New-UDTab -Text "Failure" -Content {
                            New-UDGrid -Properties @("Username", "Attempt", "Timestamp") -Endpoint {
                                $userPortalAuthEvents | Where-Object { $_.success -eq $false } | ForEach-Object {
                                    [PSCustomObject]@{
                                        Username = $_.initiated_by.username;
                                        Attempt = $(if ($_.success -eq $true) { "Success" } elseif ($_.success -eq $false) { "Failure" });
                                        Timestamp = $_.timestamp;
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