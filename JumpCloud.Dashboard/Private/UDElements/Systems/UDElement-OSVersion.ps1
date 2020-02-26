function UDElement-OSVersion
{
    param (
        [Parameter(Mandatory=$False)]
        $refreshInterval = 600,
        [Parameter(Mandatory=$False)]
        $lastContactDays = 90,
        [Parameter(Mandatory =$False)]
        $unDrawColor = "#006cac"
    )

    New-UDElement -Tag "OSVersion" -Id "OSVersion"  -RefreshInterval  $refreshInterval -AutoRefresh -Endpoint {

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

        $OSVersionCount = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object -Property version | Measure-Object | Select-Object -ExpandProperty Count
        $Script:OSVersionColors = Get-AlternatingColors -Rows:("$OSVersionCount") -Color1:('#2cc692') -Color2:('#006cac')
        New-UDChart -Title "OS Version" -Type HorizontalBar -AutoRefresh -RefreshInterval 60  -Endpoint {
            try
            {
                Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object -Property version | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor $OSVersionColors -HoverBackgroundColor $OSVersionColors
            }
            catch
            {
                0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
            }

        } -Options $HorizontalBarChartOptions -OnClick {
            if ($EventData -ne "[]")
            {
                $TabNames = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object version | Select-object Name
                Show-UDModal -Content {
                    New-UDTabContainer -Tabs {
                        foreach ($TabName in $TabNames)
                        {
                            New-UDTab -Text $TabName.Name -Content {
                                $script:OSVersion = $TabName.Name
                                New-UDGrid -Header @("Hostname", "Operating System", "System ID") -Properties @("Hostname", "OS", "SystemID") -Endpoint {
                                    Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Where-Object { $_.version -eq $OSVersion } | ForEach-Object {
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