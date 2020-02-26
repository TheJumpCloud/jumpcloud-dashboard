function UDElement-OSVersion
{
    param (
        $refreshInterval,
        $lastContactDays,
        $unDrawColor
    )

    New-UDElement -Tag "OSVersion" -Id "OSVersion"  -RefreshInterval $refreshInterval -AutoRefresh -Content {

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

        $OSVersionCount = $Cache:DisplaySystems | Group-Object -Property version | Measure-Object | Select-Object -ExpandProperty Count
        $Script:OSVersionColors = Get-AlternatingColors -Rows:("$OSVersionCount") -Color1:('#2cc692') -Color2:('#006cac')
        New-UDChart -Title "OS Version" -Type HorizontalBar -AutoRefresh -RefreshInterval $refreshInterval  -Endpoint {
            try
            {
                $Cache:DisplaySystems | Group-Object -Property version | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor $OSVersionColors -HoverBackgroundColor $OSVersionColors
            }
            catch
            {
                0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
            }

        } -Options $HorizontalBarChartOptions -OnClick {
            if ($EventData -ne "[]")
            {
                $TabNames = $Cache:DisplaySystems | Group-Object version | Select-object Name
                Show-UDModal -Content {
                    New-UDTabContainer -Tabs {
                        foreach ($TabName in $TabNames)
                        {
                            New-UDTab -Text $TabName.Name -Content {
                                $script:OSVersion = $TabName.Name
                                New-UDGrid -Header @("Hostname", "Operating System", "System ID") -Properties @("Hostname", "OS", "SystemID") -Endpoint {
                                    $Cache:DisplaySystems | Where-Object { $_.version -eq $OSVersion } | ForEach-Object {
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