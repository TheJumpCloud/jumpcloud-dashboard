function UDElement-directoryinsights_dailyAdminConsoleLoginAttempts
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

    $Script:adminConsoleAuthEvents = Get-JCEvent -Service:('directory') -StartTime:((Get-Date).AddDays(-$eventDays)) -SearchTermAnd @{"event_type" = "admin_login_attempt"}
    New-UDElement -Tag "directoryinsights_dailyAdminConsoleLoginAttempts" -Id "directoryinsights_dailyAdminConsoleLoginAttempts" -RefreshInterval $refreshInterval -AutoRefresh -Content {

        New-UDChart -Title "Daily Admin Console Authentication Attempts" -Type Bar -AutoRefresh -RefreshInterval $refreshInterval -Endpoint {
            $dateRange | ForEach-Object {
                $date = $_
                $successCount = 0
                $failureCount = 0
                $adminConsoleAuthEvents | Where-Object { [datetime]::Parse($_.timestamp).ToString("yyyy-MM-dd") -like "$($date)" } | Foreach-Object {
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
                                New-UDGrid -Headers @("Email", "Attempt", "IP Address", "Timestamp") -Properties @("Email", "Attempt", "IPAddress", "Timestamp") -Endpoint {
                                    $adminConsoleAuthEvents | Where-Object { [datetime]::Parse($_.timestamp).ToString("yyyy-MM-dd") -like "$($TabDate)" } | Foreach-Object {
                                        [PSCustomObject]@{
                                            Email = $_.resource.email;
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