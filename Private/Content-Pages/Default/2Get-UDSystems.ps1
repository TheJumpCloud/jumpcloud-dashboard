Function 2Get-UDSystems () {
    [CmdletBinding()]

    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        $lastContactDays
    )

    $PageText = 'Systems'
    $PageName = 'Systems'
    $PageLayout = '{"lg":[{"w":4,"h":9,"x":0,"y":0,"i":"grid-element-OS"},{"w":4,"h":9,"x":4,"y":0,"i":"grid-element-MFA"},{"w":4,"h":9,"x":9,"y":0,"i":"grid-element-NewSystems"},{"w":4,"h":9,"x":0,"y":10,"i":"grid-element-AgentVersion"},{"w":4,"h":9,"x":4,"y":10,"i":"grid-element-OSVersion"},{"w":4,"h":9,"x":9,"y":10,"i":"grid-element-LastContact"},{"w":12,"h":4,"x":4,"y":20,"i":"grid-element-SystemsDownload"}]}'

    $LegendOptions = New-UDChartLegendOptions -Position bottom
    $Options = New-UDLineChartOptions -LegendOptions $LegendOptions

    $UDPage = New-UDPage -Name:($PageName) -Content {

        # Check to see if org has any registered systems
        $HasSystems = Get-JCSystem -returnProperties hostname | Measure-Object

        if ($HasSystems.Count -eq 0) {
            New-UDRow {
                New-UDColumn -Size 6 {
                    New-UDCard -Title "No Systems Registered" -Content {
                        New-UDParagraph -Text "To load the systems dashboard install the JumpCloud agent on your systems."
                        New-UDunDraw -Name "monitor"
                    } -Links @(New-UDLink -Url 'https://support.jumpcloud.com/support/s/article/getting-started-systems1-2019-08-21-10-36-47' -Text "SEE: Getting Started - Systems")
                }
            }
        }
        else {
            New-UDGridLayout -Layout $PageLayout -Draggable -Resizable  -Content {
                New-UDChart -Title "Operating Systems $lastContactDays" -Id "OS" -Type Doughnut -RefreshInterval 60  -Endpoint {
                    try {
                        Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object -Property os | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor @("#8014558C", "#803AE8CE") -HoverBackgroundColor @("#8014558C", "#803AE8CE")
                    }
                    catch {
                        0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                    }
                } -Options $Options -OnClick {
                    if ($EventData -ne "[]") {
                        $TabNames = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object -Property os | Select-object Name
                        Show-UDModal -Content {
                            New-UDTabContainer -Tabs {
                                foreach ($TabName in $TabNames) {
                                    New-UDTab -Text $TabName.Name -Content {
                                        $script:OSType = $TabName.Name
                                        New-UDGrid -Properties @("HostName", "OS", "Version") -Endpoint {
                                            Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Where-Object { $_.os -eq $OSType } | ForEach-Object {
                                                [PSCustomObject]@{
                                                    HostName = $_.hostname;
                                                    OS       = $_.os;
                                                    Version  = $_.version;
                                                }
                                            } | Out-UDGridData
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                New-UDChart -Title "MFA Enabled Systems" -Id "MFA" -Type pie -RefreshInterval 60  -Endpoint {
                    try {
                        Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object allowMultiFactorAuthentication | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor @("#8014558C", "#803AE8CE") -HoverBackgroundColor @("#8014558C", "#803AE8CE")
                    }
                    catch {
                        0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                    }
                } -Options $Options

                New-UDChart -Title "Agent Version" -Id "AgentVersion" -Type HorizontalBar -RefreshInterval 60  -Endpoint {
                    try {
                        Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object -Property agentVersion | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                    }
                    catch {
                        0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                    }

                } -Options $Options

                New-UDChart -Title "OS Version" -Id "OSVersion" -Type HorizontalBar -RefreshInterval 60  -Endpoint {
                    try {
                        Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object -Property version | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                    }
                    catch {
                        0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                    }

                } -Options $Options
                
                New-UDChart -Title "Last Contact Days" -Id "LastContact" -Type HorizontalBar -RefreshInterval 60  -Endpoint {
                    try {
                        Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Select-Object -ExpandProperty lastContact | Select-Object @{Name = "Date"; expression = { $_ } }, @{Name = "TimeSpan"; expression = { (New-TimeSpan -Start $_ -End $(Get-Date)).Days } } | Group-object -Property TimeSpan | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                    }
                    catch {
                        0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                    }

                } -Options $Options
                
                New-UDGrid -Title "New Systems (Created in the last 7 days)" -Id "NewSystems" -Properties @("Hostname", "OS", "Created") -Endpoint {
                    Get-JCSystem -filterDateProperty created -dateFilter after  -date (Get-Date).AddDays(-7) | Sort-Object created -Descending | ForEach-Object {
                        [PSCustomObject]@{
                            Created  = $_.created;
                            Hostname = (New-UDLink -Text $_.hostname -Url "https://console.jumpcloud.com/#/systems/$($_._id)/details" -OpenInNewWindow);
                            OS       = $_.os + " " + $_.version;
                        }
                    } | Out-UDGridData
                }
                New-UDCard -Title "Displaying information from systems that have checked in within the last $lastContactDays days" -Id "SystemsDownload" -Content {
                    $TotalSystems = Get-JCSystem -returnProperties hostname | Measure-Object | Select-Object -ExpandProperty Count
                    $ShowingSystems = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Measure-Object | Select-Object -ExpandProperty Count

                    New-UDParagraph -Text "Displaying $ShowingSystems of $TotalSystems systems."
                    New-UDButton -Icon 'cloud_download' -Text "Download All System Information" -OnClick {
                        $DesktopPath = '~' + '\' + 'Desktop'
                        Set-Location $DesktopPath
                        Get-JCBackup -Systems
                        Show-UDToast -Message "System Information Downloaded To CSV On Desktop";
                    }
                }
            }
        } 
    }

    $UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('Laptop')
    Return [PSCustomObject]@{
        'UDPage'        = $UDPage;
        'UDSideNavItem' = $UDSideNavItem;
    }
}
