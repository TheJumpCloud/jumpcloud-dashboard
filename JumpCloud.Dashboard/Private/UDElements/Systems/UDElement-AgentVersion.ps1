function UDElement-AgentVersion
{
    param (
        $refreshInterval,
        $lastContactDays,
        $unDrawColor
    )

    New-UDElement -Tag "AgentVersion" -Id "AgentVersion"  -RefreshInterval  $refreshInterval -AutoRefresh -Endpoint {

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

        $AgentVersionCount = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object -Property agentVersion | Measure-Object | Select-Object -ExpandProperty Count
        $Script:AgentVersionColors = Get-AlternatingColors -Rows:("$AgentVersionCount") -Color1:('#006cac') -Color2:('#2cc692')
        New-UDChart -Title "Agent Version" -Type HorizontalBar -AutoRefresh -RefreshInterval 60  -Endpoint {
            try
            {
                Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object -Property agentVersion | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor $AgentVersionColors -HoverBackgroundColor $AgentVersionColors
            }
            catch
            {
                0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
            }
        } -Options $HorizontalBarChartOptions -OnClick {
            if ($EventData -ne "[]")
            {
                $TabNames = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object agentVersion | Select-object Name
                Show-UDModal -Content {
                    New-UDTabContainer -Tabs {
                        foreach ($TabName in $TabNames)
                        {
                            New-UDTab -Text $TabName.Name -Content {
                                $script:AgentVersion = $TabName.Name
                                New-UDGrid -Headers @("Hostname", "Operating System", "Agent Version", "System ID") -Properties @("Hostname", "OS", "AgentVersion", "SystemID") -Endpoint {
                                    Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Where-Object { $_.agentVersion -eq $AgentVersion } | ForEach-Object {
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