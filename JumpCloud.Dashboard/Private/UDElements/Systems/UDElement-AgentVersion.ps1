function UDElement-AgentVersion {
    param (
        $refreshInterval,
        $lastContactDays,
        $unDrawColor
    )

    New-UDElement -Tag "AgentVersion" -Id "AgentVersion" -RefreshInterval $refreshInterval -AutoRefresh -Endpoint {

        $HorizontalBarChartOptions = @{
            legend = @{
                display = $false
            }
            scales = @{
                xAxes = @(
                    @{
                        ticks      = @{
                            beginAtZero = $true
                        }
                        scaleLabel = @{
                            display     = $true
                            labelString = "Number of Systems"
                        }
                    }
                )
            }
        }

        $AgentVersionCount = $Cache:DisplaySystems | Group-Object -Property agentVersion | Measure-Object | Select-Object -ExpandProperty Count
        $Script:AgentVersionColors = Get-AlternatingColors -Rows:("$AgentVersionCount") -Color1:('#006cac') -Color2:('#2cc692')
        New-UDChart -Title "Agent Version" -Type HorizontalBar -AutoRefresh -RefreshInterval $refreshInterval  -Endpoint {
            try {
                $Cache:DisplaySystems | Group-Object -Property agentVersion | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor $AgentVersionColors -HoverBackgroundColor $AgentVersionColors
            }
            catch {
                0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
            }
        } -Options $HorizontalBarChartOptions -OnClick {
            if ($EventData -ne "[]") {
                $TabNames = $Cache:DisplaySystems | Group-Object agentVersion | Select-object Name
                Show-UDModal -Content {
                    New-UDTabContainer -Tabs {
                        foreach ($TabName in $TabNames) {
                            New-UDTab -Text $TabName.Name -Content {
                                $script:AgentVersion = $TabName.Name
                                New-UDGrid -Headers @("Hostname", "Operating System", "Agent Version", "System ID") -Properties @("Hostname", "OS", "AgentVersion", "SystemID") -Endpoint {
                                    $Cache:DisplaySystems | Where-Object { $_.agentVersion -eq $AgentVersion } | ForEach-Object {
                                        [PSCustomObject]@{
                                            Hostname     = $_.hostname;
                                            OS           = $_.os + " " + $_.version;
                                            AgentVersion = $_.agentVersion;
                                            SystemID     = $_._id;
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