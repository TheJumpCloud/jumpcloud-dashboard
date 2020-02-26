function UDElement-LastContact
{
    param (
        [Parameter(Mandatory=$False)]
        $refreshInterval = 600,
        [Parameter(Mandatory=$False)]
        $lastContactDays = 90,
        [Parameter(Mandatory =$False)]
        $unDrawColor = "#006cac"
    )


    New-UDElement -Tag "LastContact" -Id "LastContact"  -RefreshInterval  $refreshInterval -AutoRefresh -Endpoint {

        $VerticalBarChartOptions = @{
            legend = @{
                display = $false
            }
            scales = @{
                yAxes = @(
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

        $LastContactCount = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Select-Object -Property lastContact | Measure-Object | Select-Object -ExpandProperty "Count"
        $Script:LastContactColors = Get-AlternatingColors -Rows:("$LastContactCount") -Color1:('#006cac') -Color2:('#2cc692')
        New-UDChart -Title "Last Contact Date" -Type Bar -AutoRefresh -RefreshInterval 60  -Endpoint {
            try
            {
                Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Select-Object -Property lastContact | ForEach-Object {
                    [PSCustomObject]@{
                        LastContactDate = (Get-Date($_.lastContact)).ToString("yyyy-MM-dd")
                    }
                } | Group-Object -Property LastContactDate | Select-Object Name, Count | Out-UDChartData -LabelProperty "Name" -DataProperty "Count" -BackgroundColor $LastContactColors -HoverBackgroundColor $LastContactColors
            }
            catch
            {
                0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
            }
        } -Options $VerticalBarChartOptions -OnClick {
            $TabNames = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Select-Object -Property lastContact | ForEach-Object {
                [PSCustomObject]@{
                    LastContactDate = (Get-Date($_.lastContact)).ToString("yyyy-MM-dd")
                }
            } | Group-Object -Property LastContactDate | Select-Object Name
            Show-UDModal -Content {
                New-UDTabContainer -Tabs {
                    foreach ($TabName in $TabNames)
                    {
                        New-UDTab -Text $TabName.Name -Content {
                            $script:LastContact = $TabName.Name
                            New-UDGrid -Header @("Hostname", "Operating System", "Last Contact Date", "System ID") -Properties @("Hostname", "OS", "LastContactDate", "SystemID") -Endpoint {
                                Get-SystemsWithLastContactWithinXDays -days $lastContactDays | ? { (Get-Date($_.lastContact)).ToString("yyyy-MM-dd") -like $LastContact } | ForEach-Object {
                                    [PSCustomObject]@{
                                        Hostname        = $_.hostname;
                                        OS              = $_.os + " " + $_.version;
                                        LastContactDate = (Get-Date($_.lastContact)).ToString("yyyy-MM-dd");
                                        SystemID        = $_._id;
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