Function 2Get-UDSystems () {
    [CmdletBinding()]

    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        $lastContactDays
    )

    $PageText = 'Systems'
    $PageName = 'Systems'
    $PageLayout = '{"lg":[{"w":4,"h":9,"x":0,"y":0,"i":"grid-element-OS"},{"w":4,"h":9,"x":4,"y":0,"i":"grid-element-SystemsMFA"},{"w":4,"h":9,"x":9,"y":0,"i":"grid-element-NewSystems"},{"w":4,"h":9,"x":0,"y":10,"i":"grid-element-AgentVersion"},{"w":4,"h":9,"x":4,"y":10,"i":"grid-element-OSVersion"},{"w":4,"h":9,"x":9,"y":10,"i":"grid-element-LastContact"},{"w":12,"h":4,"x":4,"y":20,"i":"grid-element-SystemsDownload"}]}'

    $LegendOptions = New-UDChartLegendOptions -Position bottom
    $CircleChartOptions = New-UDLineChartOptions -LegendOptions $LegendOptions
    $BarChartOptions = @{
        legend = @{
            display = $false
        }
        scales = @{
            xAxes = @(
                @{
                    ticks = @{
                        beginAtZero = $true
                    }
                }
            )
        }
    }
    $LineChartOptions = @{
        legend = @{
            display = $false
        }
        scales = @{
            yAxes = @(
                @{
                    ticks = @{
                        beginAtZero = $true
                    }
                }
            )
        }
    }

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
            New-UDGridLayout -Layout $PageLayout -Content {
                New-UDChart -Title "Operating Systems $lastContactDays" -Id "OS" -Type Doughnut -RefreshInterval 60  -Endpoint {
                    try {
                        Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object -Property os | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor @("#2cc692", "#ffb000", "#006cac") -HoverBackgroundColor @("#2cc692", "#ffb000", "#006cac")
                    }
                    catch {
                        0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                    }
                } -Options $CircleChartOptions -OnClick {
                    if ($EventData -ne "[]") {
                        $TabNames = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object -Property os | Select-object Name
                        Show-UDModal -Content {
                            New-UDTabContainer -Tabs {
                                foreach ($TabName in $TabNames) {
                                    New-UDTab -Text $TabName.Name -Content {
                                        $script:OSType = $TabName.Name
                                        New-UDGrid -Properties @("Hostname", "OS", "Version") -Endpoint {
                                            Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Where-Object { $_.os -eq $OSType } | ForEach-Object {
                                                [PSCustomObject]@{
                                                    Hostname = $_.hostname;
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

                New-UDChart -Title "MFA Enabled Systems" -Id "SystemsMFA" -Type pie -RefreshInterval 60  -Endpoint {
                    try {
                        Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object allowMultiFactorAuthentication | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor @("#e54852", "#2cc692") -HoverBackgroundColor @("#e54852", "#2cc692")
                    }
                    catch {
                        0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                    }
                } -Options $CircleChartOptions -OnClick {
                    if ($EventData -ne "[]") {
                        $TabNames = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object allowMultiFactorAuthentication | Select-object Name
                        Show-UDModal -Content {
                            New-UDTabContainer -Tabs {
                                foreach ($TabName in $TabNames) {
                                    New-UDTab -Text $TabName.Name -Content {
                                        $script:MFAEnabled = [System.Convert]::ToBoolean($TabName.Name)
                                        New-UDGrid -Properties @("Hostname", "OS", "Version") -Endpoint {
                                            Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Where-Object { $_.allowMultiFactorAuthentication -eq $MFAEnabled } | ForEach-Object {
                                                [PSCustomObject]@{
                                                    Hostname = $_.hostname;
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

                New-UDChart -Title "Agent Version" -Id "AgentVersion" -Type HorizontalBar -RefreshInterval 60  -Endpoint {
                    try {
                        Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object -Property agentVersion | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor "#2cc692" -HoverBackgroundColor "#2cc692"
                    }
                    catch {
                        0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                    }
                } -Options $BarChartOptions -OnClick {
                    if ($EventData -ne "[]") {
                        $TabNames = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object agentVersion | Select-object Name
                        Show-UDModal -Content {
                            New-UDTabContainer -Tabs {
                                foreach ($TabName in $TabNames) {
                                    New-UDTab -Text $TabName.Name -Content {
                                        $script:AgentVersion = $TabName.Name
                                        New-UDGrid -Headers @("Hostname", "OS", "Version", "Agent Version") -Properties @("Hostname", "OS", "Version", "AgentVersion") -Endpoint {
                                            Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Where-Object { $_.agentVersion -eq $AgentVersion } | ForEach-Object {
                                                [PSCustomObject]@{
                                                    Hostname     = $_.hostname;
                                                    OS           = $_.os;
                                                    Version      = $_.version;
                                                    AgentVersion = $_.agentVersion;
                                                }
                                            } | Out-UDGridData
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                New-UDChart -Title "OS Version" -Id "OSVersion" -Type HorizontalBar -RefreshInterval 60  -Endpoint {
                    try {
                        Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object -Property version | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor "#2cc692" -HoverBackgroundColor "#2cc692"
                    }
                    catch {
                        0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                    }

                } -Options $BarChartOptions -OnClick {
                    if ($EventData -ne "[]") {
                        $TabNames = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object version | Select-object Name
                        Show-UDModal -Content {
                            New-UDTabContainer -Tabs {
                                foreach ($TabName in $TabNames) {
                                    New-UDTab -Text $TabName.Name -Content {
                                        $script:OSVersion = $TabName.Name
                                        New-UDGrid -Properties @("Hostname", "OS", "Version") -Endpoint {
                                            Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Where-Object { $_.version -eq $OSVersion } | ForEach-Object {
                                                [PSCustomObject]@{
                                                    Hostname = $_.hostname;
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
                
                New-UDChart -Title "Last Contact Days" -Id "LastContact" -Type Line -RefreshInterval 60  -Endpoint {
                    try {
                        Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Select-Object -Property lastContact | ForEach-Object {
                            [PSCustomObject]@{
                                LastContactDate = $_.lastContact.ToString("yyyy-MM-dd")
                            }
                        } | Group-Object -Property LastContactDate | Select-Object Name, Count | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor "#2cc692" -HoverBackgroundColor "#2cc692"
                    }
                    catch {
                        0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                    }
                } -Options $LineChartOptions -OnClick {
                    $TabNames = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Select-Object -Property lastContact | ForEach-Object {
                        [PSCustomObject]@{
                            LastContactDate = $_.lastContact.ToString("yyyy-MM-dd")
                        }
                    } | Group-Object -Property LastContactDate | Select-Object Name
                    Show-UDModal -Content {
                        New-UDTabContainer -Tabs {
                            foreach ($TabName in $TabNames) {
                                New-UDTab -Text $TabName.Name -Content {
                                    $script:LastContact = $TabName.Name
                                    New-UDGrid -Properties @("Hostname", "OS", "Version", "LastContactDate") -Endpoint {
                                        Get-SystemsWithLastContactWithinXDays -days $lastContactDays | ? {$_.lastContact.ToString("yyyy-MM-dd") -like $LastContact} | ForEach-Object {
                                            [PSCustomObject]@{
                                                Hostname = $_.Hostname;
                                                OS = $_.os;
                                                Version = $_.version;
                                                LastContactDate = $_.lastContact.ToString("yyyy-MM-dd");
                                            }
                                        } | Out-UDGridData
                                    }
                                }
                            }
                        }
                    }
                }
                
                New-UDGrid -Title "New Systems (Created in the last 7 days)" -Id "NewSystems" -Properties @("Hostname", "OS", "Created") -Endpoint {
                    Get-JCSystem -filterDateProperty created -dateFilter after  -date (Get-Date).AddDays(-7) | Sort-Object created -Descending | ForEach-Object {
                        [PSCustomObject]@{
                            Created  = $_.created;
                            Hostname = (New-UDLink -Text $_.hostname -Url "https://console.jumpcloud.com/#/systems/$($_._id)/details" -OpenInNewWindow);
                            OS       = $_.os + " " + $_.version;
                        }
                    } | Out-UDGridData
                } -NoExport
                New-UDCard -Title "Displaying information from systems that have checked in within the last $lastContactDays days" -Id "SystemsDownload" -Content {
                    $TotalSystems = Get-JCSystem -returnProperties hostname | Measure-Object | Select-Object -ExpandProperty Count
                    $ShowingSystems = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Measure-Object | Select-Object -ExpandProperty Count

                    New-UDParagraph -Text "Displaying $ShowingSystems of $TotalSystems systems."
                    New-UDButton -Icon 'cloud_download' -Text "Download All System Information" -OnClick {
                        $DesktopPath = '~' + '\' + 'Desktop'
                        Set-Location $DesktopPath
                        Get-JCBackup -Systems
                        Show-UDToast -Message "System Information Downloaded To CSV On Desktop" -Duration 10000;
                    }
                }
            }
        } 
    }

    #$UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('Laptop')
    Return [PSCustomObject]@{
        'UDPage'        = $UDPage;
    #    'UDSideNavItem' = $UDSideNavItem;
    }
}
