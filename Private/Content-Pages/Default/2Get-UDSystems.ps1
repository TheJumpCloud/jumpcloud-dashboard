Function 2Get-UDSystems ()
{
    [CmdletBinding()]

    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        $lastContactDays
    )

    $PageText = 'Systems'
    $PageName = 'Systems'
    $UDPage = New-UDPage -Name:($PageName) -Content {

        # Check to see if org has any registered systems
        $HasSystems = Get-JCSystem -returnProperties hostname | Measure-Object

        if ($HasSystems.Count -eq 0)
        {
            New-UDRow {
                New-UDCard -Title "No Systems Registered" -Text "To load the systems dashboard install the JumpCloud systems agent on your systems." -Links @(New-UDLink -Url 'https://support.jumpcloud.com/support/s/article/getting-started-systems1-2019-08-21-10-36-47' -Text "SEE: Getting Started - Systems")


            }
        }
        else
        {

            New-UDRow {

                New-UDColumn -Size 4 -Content {
                    $LegendOptions = New-UDChartLegendOptions -Position bottom
                    $Options = New-UDLineChartOptions -LegendOptions $LegendOptions
                    New-UDChart -Title "Operating System" -Type Doughnut -RefreshInterval 60  -Endpoint {
                        try
                        {
                            Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object -Property os | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor @("#8014558C", "#803AE8CE") -HoverBackgroundColor @("#8014558C", "#803AE8CE")
                        }
                        catch
                        {
                            0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                        }
                    } -Options $Options

                    
                }
                New-UDColumn -Size 4 -Content {
                    $LegendOptions = New-UDChartLegendOptions -Position bottom
                    $Options = New-UDLineChartOptions -LegendOptions $LegendOptions
                    New-UDChart -Title "MFA Enabled Systems" -Type pie -RefreshInterval 60  -Endpoint {
                        try
                        {
                            Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object allowMultiFactorAuthentication | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor @("#8014558C", "#803AE8CE") -HoverBackgroundColor @("#8014558C", "#803AE8CE")
                        }
                        catch
                        {
                            0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                        }
                    } -Options $Options
                }
                New-UDColumn -Size 4 -Content {
                    $LegendOptions = New-UDChartLegendOptions -Position bottom
                    $Options = New-UDLineChartOptions -LegendOptions $LegendOptions
                    New-UDChart -Title "System Insights Status" -Type pie -RefreshInterval 60  -Endpoint {
                        try
                        {
                            Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Select-Object _id, @{Name = 'SystemInsightsState'; Expression = { $_.systemInsights.state } } | Group-Object SystemInsightsState | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor @("#8014558C", "#803AE8CE") -HoverBackgroundColor @("#8014558C", "#803AE8CE")
                        }
                        catch
                        {
                            0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                        }
                    } -Options $Options
                }

            }

            New-UDRow {

                New-UDColumn -Size 4 -Content {
                    $LegendOptions = New-UDChartLegendOptions -Hide
                    $Options = New-UDLineChartOptions -LegendOptions $LegendOptions
                    New-UDChart -Title "Agent Version" -Type HorizontalBar -RefreshInterval 60  -Endpoint {
                        try
                        {
                            Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object -Property agentVersion | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                        }
                        catch
                        {
                            0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                        }

                    } -Options $Options
                }
                
                New-UDColumn -Size 4 -Content {
                    $LegendOptions = New-UDChartLegendOptions -Hide
                    $Options = New-UDLineChartOptions -LegendOptions $LegendOptions
                    New-UDChart -Title "OS Version" -Type HorizontalBar -RefreshInterval 60  -Endpoint {
                        try
                        {
                            Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object -Property version | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                        }
                        catch
                        {
                            0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                        }

                    } -Options $Options
                }

                New-UDColumn -Size 4 -Content {
                    $LegendOptions = New-UDChartLegendOptions -Hide
                    $Options = New-UDLineChartOptions -LegendOptions $LegendOptions
                    New-UDChart -Title "Days Since Last Contact" -Type HorizontalBar -RefreshInterval 60  -Endpoint {
                        try
                        {
                            Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Select-Object -ExpandProperty lastContact | Select-Object @{Name = "Date"; expression = { $_ } }, @{Name = "TimeSpan"; expression = { (New-TimeSpan -Start $_ -End $(Get-Date)).Days } } | Group-object -Property TimeSpan | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                        }
                        catch
                        {
                            0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                        }

                    } -Options $Options
                }

            }
            New-UDRow {

                $TotalSystems = Get-JCSystem -returnProperties hostname | Measure-Object | Select-Object -ExpandProperty Count
                $ShowingSystems = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Measure-Object | Select-Object -ExpandProperty Count

                New-UDCard -Title "Displaying information from systems that have checked in within the last $lastContactDays days" -Text "Displaying $ShowingSystems of $TotalSystems systems" 

            }
        }
    }

    $UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('Laptop')
    Return [PSCustomObject]@{
        'UDPage'        = $UDPage;
        'UDSideNavItem' = $UDSideNavItem;
    }
}
