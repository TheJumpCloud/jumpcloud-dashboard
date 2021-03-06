function UDElement-system_os
{
    param (
        $refreshInterval,
        $lastContactDays,
        $unDrawColor
    )

    New-UDElement -Tag "system_os" -Id "system_os"  -RefreshInterval  $refreshInterval -AutoRefresh -Content {

        $LegendOptions = New-UDChartLegendOptions -Position bottom
        $CircleChartOptions = New-UDLineChartOptions -LegendOptions $LegendOptions

        New-UDChart -Title "Operating System" -Type Doughnut -AutoRefresh -RefreshInterval $refreshInterval  -Endpoint {
            try
            {
                $Cache:DisplaySystems | Group-Object -Property os | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor @("#2cc692", "#ffb000", "#006cac", "#e54852", "#9080e0") -HoverBackgroundColor @("#2cc692", "#ffb000", "#006cac", "#e54852", "#9080e0")
            }
            catch
            {
                0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
            }
        } -Options $CircleChartOptions -OnClick {
            if ($EventData -ne "[]")
            {
                $TabNames = $Cache:DisplaySystems | Group-Object -Property os | Select-object Name
                Show-UDModal -Content {
                    New-UDTabContainer -Tabs {
                        foreach ($TabName in $TabNames)
                        {
                            New-UDTab -Text $TabName.Name -Content {
                                $script:OSType = $TabName.Name
                                New-UDGrid -Header @("Hostname", "Operating System", "System ID") -Properties @("Hostname", "OS", "SystemID") -Endpoint {
                                    $Cache:DisplaySystems | Where-Object { $_.os -eq $OSType } | ForEach-Object {
                                        [PSCustomObject]@{
                                            Hostname = $_.hostname;
                                            OS       = $_.os + " " + $_.version;
                                            SystemID = $_._id;
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