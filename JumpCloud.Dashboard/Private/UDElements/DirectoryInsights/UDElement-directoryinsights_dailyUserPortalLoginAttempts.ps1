function UDElement-directoryinsights_dailyUserPortalLoginAttempts
{
    param(
        $eventDays,
        $refreshInterval,
        $unDrawColor
    )

    $startDate = (Get-Date)
    $Script:dateRange = @()
    1..$eventDays | ForEach-Object {
        $dateRange += $startDate.ToString("yyyy-MM-dd")
        $startDate = $startDate.AddDays(-1)
    }

    $Script:userPortalAuthEvents = Get-JCEvent -Service:('directory') -StartTime:((Get-Date).AddDays(-$eventDays)) -SearchTermAnd @{"event_type" = "user_login_attempt"}
    New-UDElement -Tag "directoryinsights_dailyUserPortalLoginAttempts" -Id "directoryinsights_dailyUserPortalLoginAttempts" -RefreshInterval $refreshInterval -AutoRefresh -Content {

        New-UDChart -Title "Daily User Portal Authentication Attempts" -Type Bar -AutoRefresh -RefreshInterval $refreshInterval -Endpoint {
            $dateRange | ForEach-Object {
                $date = $_
                $successCount = 0
                $failureCount = 0
                $userPortalAuthEvents | Where-Object { [datetime]::Parse($_.timestamp).ToString("yyyy-MM-dd") -like "$($date)*" } | Foreach-Object {
                    if ($_.success -eq $true) {
                        $successCount += 1
                    } elseif ($_.success -eq $false) {
                        $failureCount += 1
                    }
                }
                [PSCustomObject]@{
                    Timestamp = $date;
                    Success = $successCount;
                    Failure = $failureCount;
                }
            } | Out-UDChartData -LabelProperty "Timestamp" -Dataset @(
                New-UDChartDataset -Label "Success" -DataProperty "Success" -BackgroundColor "#2cc692" -HoverBackgroundColor "#2cc692"
                New-UDChartDataset -Label "Failure" -DataProperty "Failure" -BackgroundColor "#e54852" -HoverBackgroundColor "#e54852"
            )
        } -OnClick {
            if ($EventData -ne "[]")
            {
                Show-UDModal -Content {
                    New-UDTabContainer -Tabs {
                        foreach ($TabName in $dateRange)
                        {
                            New-UDTab -Text $TabName -Content {
                                $Script:TabDate = $TabName
                                New-UDGrid -Headers @("Username", "Attempt", "IP Address", "Timestamp") -Properties @("Username", "Attempt", "IPAddress", "Timestamp") -Endpoint {
                                    $userPortalAuthEvents | Where-Object { [datetime]::Parse($_.timestamp).ToString("yyyy-MM-dd") -like "$($TabDate)" } | Foreach-Object {
                                        [PSCustomObject]@{
                                            Username = $_.initiated_by.username;
                                            Attempt = $(if ($_.success) { "Success" } elseif (!$_.success) { "Failure" });
                                            IPAddress = $_.client_ip;
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
}