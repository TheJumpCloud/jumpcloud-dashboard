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

        New-UDElement -Tag "tag_Systems"  -AutoRefresh -RefreshInterval 30 -Content {

            $PageLayout = '{"lg":[{"w":12,"h":3,"x":0,"y":0,"i":"grid-element-SystemsDownload"},{"w":4,"h":10,"x":0,"y":5,"i":"grid-element-OS"},{"w":4,"h":10,"x":4,"y":5,"i":"grid-element-SystemsMFA"},{"w":4,"h":10,"x":9,"y":5,"i":"grid-element-NewSystems"},{"w":4,"h":10,"x":0,"y":15,"i":"grid-element-AgentVersion"},{"w":4,"h":10,"x":4,"y":15,"i":"grid-element-OSVersion"},{"w":4,"h":10,"x":9,"y":15,"i":"grid-element-LastContact"}]}'
            $unDrawColor = "#006cac"

            $LegendOptions = New-UDChartLegendOptions -Position bottom
            $CircleChartOptions = New-UDLineChartOptions -LegendOptions $LegendOptions
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

            # Check to see if org has any registered systems
            $HasSystems = Get-JCSystem -returnProperties hostname | Measure-Object

            if ($HasSystems.Count -eq 0)
            {
                New-UDRow {
                    New-UDColumn -Size 6 {
                        New-UDCard -Title "No Systems Registered" -Content {
                            New-UDParagraph -Text "To load the systems dashboard install the JumpCloud agent on your systems."
                            New-UDunDraw -Name "monitor" -Color $unDrawColor
                        } -Links @(New-UDLink -Url 'https://support.jumpcloud.com/support/s/article/getting-started-systems1-2019-08-21-10-36-47' -Text "SEE: Getting Started - Systems")
                    }
                }
            }
            else
            {
                New-UDGridLayout -Layout $PageLayout -Content {
                
                    New-UDCard -Horizontal -Title "Systems" -Id "SystemsDownload" -Content {
                        $TotalSystems = Get-JCSystem -returnProperties hostname | Measure-Object | Select-Object -ExpandProperty Count
                        $ShowingSystems = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Measure-Object | Select-Object -ExpandProperty Count

                        New-UDParagraph -Text "Displaying information from systems that have checked in within the last $lastContactDays days. Displaying $ShowingSystems of $TotalSystems systems."
                        New-UDButton -Icon 'cloud_download' -Text "Download All System Information" -OnClick {
                            $DesktopPath = '~' + '\' + 'Desktop'
                            Set-Location $DesktopPath
                            Get-JCBackup -Systems
                            Show-UDToast -Message "System Information Downloaded To CSV On Desktop" -Duration 10000;
                        }
                    }

                    New-UDChart -Title "Operating System" -Id "OS" -Type Doughnut -AutoRefresh -RefreshInterval 60  -Endpoint {
                        try
                        {
                            Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object -Property os | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor @("#2cc692", "#ffb000", "#006cac") -HoverBackgroundColor @("#2cc692", "#ffb000", "#006cac")
                        }
                        catch
                        {
                            0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                        }
                    } -Options $CircleChartOptions -OnClick {
                        if ($EventData -ne "[]")
                        {
                            $TabNames = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object -Property os | Select-object Name
                            Show-UDModal -Content {
                                New-UDTabContainer -Tabs {
                                    foreach ($TabName in $TabNames)
                                    {
                                        New-UDTab -Text $TabName.Name -Content {
                                            $script:OSType = $TabName.Name
                                            New-UDGrid -Header @("Hostname", "Operating System", "System ID") -Properties @("Hostname", "OS", "SystemID") -Endpoint {
                                                Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Where-Object { $_.os -eq $OSType } | ForEach-Object {
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

                    $Script:MFASystems = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | ? { $_.allowMultiFactorAuthentication }
                    if ($MFASystems)
                    {
                        New-UDChart -Title "MFA Enabled Systems" -Id "SystemsMFA" -Type Doughnut -AutoRefresh -RefreshInterval 60  -Endpoint {
                            try
                            {
                                Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object allowMultiFactorAuthentication | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor @("#e54852", "#2cc692") -HoverBackgroundColor @("#e54852", "#2cc692")
                            }
                            catch
                            {
                                0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                            }
                        } -Options $CircleChartOptions -OnClick {
                            if ($EventData -ne "[]")
                            {
                                $TabNames = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object allowMultiFactorAuthentication | Select-object Name
                                Show-UDModal -Content {
                                    New-UDTabContainer -Tabs {
                                        foreach ($TabName in $TabNames)
                                        {
                                            New-UDTab -Text $TabName.Name -Content {
                                                $script:MFAEnabled = [System.Convert]::ToBoolean($TabName.Name)
                                                New-UDGrid -Header @("Hostname", "Operating System", "System ID") -Properties @("Hostname", "OS", "SystemID") -Endpoint {
                                                    Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Where-Object { $_.allowMultiFactorAuthentication -eq $MFAEnabled } | ForEach-Object {
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
                    else
                    {
                        New-UDCard -Title "MFA Enabled Systems" -Id "SystemsMFA" -Content {
                            New-UDunDraw -Name "authentication" -Color $unDrawColor
                            New-UDParagraph -Text "None of your systems have MFA enabled."
                        }
                    }

                    $AgentVersionCount = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object -Property agentVersion | Measure-Object | Select-Object -ExpandProperty Count
                    $Script:AgentVersionColors = Get-AlternatingColors -Rows:("$AgentVersionCount") -Color1:('#006cac') -Color2:('#2cc692')
                    New-UDChart -Title "Agent Version" -Id "AgentVersion" -Type HorizontalBar -AutoRefresh -RefreshInterval 60  -Endpoint {
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

                    $OSVersionCount = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object -Property version | Measure-Object | Select-Object -ExpandProperty Count
                    $Script:OSVersionColors = Get-AlternatingColors -Rows:("$OSVersionCount") -Color1:('#2cc692') -Color2:('#006cac')
                    New-UDChart -Title "OS Version" -Id "OSVersion" -Type HorizontalBar -AutoRefresh -RefreshInterval 60  -Endpoint {
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
                
                    $LastContactCount = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Select-Object -Property lastContact | Measure-Object | Select-Object -ExpandProperty "Count"
                    $Script:LastContactColors = Get-AlternatingColors -Rows:("$LastContactCount") -Color1:('#006cac') -Color2:('#2cc692')
                    New-UDChart -Title "Last Contact Date" -Id "LastContact" -Type Bar -AutoRefresh -RefreshInterval 60  -Endpoint {
                        try
                        {
                            Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Select-Object -Property lastContact | ForEach-Object {
                                [PSCustomObject]@{
                                    LastContactDate = $_.lastContact.ToString("yyyy-MM-dd")
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
                                LastContactDate = $_.lastContact.ToString("yyyy-MM-dd")
                            }
                        } | Group-Object -Property LastContactDate | Select-Object Name
                        Show-UDModal -Content {
                            New-UDTabContainer -Tabs {
                                foreach ($TabName in $TabNames)
                                {
                                    New-UDTab -Text $TabName.Name -Content {
                                        $script:LastContact = $TabName.Name
                                        New-UDGrid -Header @("Hostname", "Operating System", "Last Contact Date", "System ID") -Properties @("Hostname", "OS", "LastContactDate", "SystemID") -Endpoint {
                                            Get-SystemsWithLastContactWithinXDays -days $lastContactDays | ? { $_.lastContact.ToString("yyyy-MM-dd") -like $LastContact } | ForEach-Object {
                                                [PSCustomObject]@{
                                                    Hostname        = $_.hostname;
                                                    OS              = $_.os + " " + $_.version;
                                                    LastContactDate = $_.lastContact.ToString("yyyy-MM-dd");
                                                    SystemID        = $_._id;
                                                }
                                            } | Out-UDGridData
                                        }
                                    }
                                }
                            }
                        }
                    }
                
                    $Script:NewSystems = Get-JCSystem -filterDateProperty created -dateFilter after  -date (Get-Date).AddDays(-7)
                    if ($NewSystems)
                    {
                        New-UDGrid -Title "New Systems (Created in the last 7 days)" -Id "NewSystems" -Properties @("Hostname", "OS", "Created") -Headers @("Hostname", "OS", "Created") -Endpoint {
                            Get-JCSystem -filterDateProperty created -dateFilter after  -date (Get-Date).AddDays(-7) | Sort-Object created -Descending | ForEach-Object {
                                [PSCustomObject]@{
                                    Hostname = (New-UDLink -Text $_.hostname -Url "https://console.jumpcloud.com/#/systems/$($_._id)/details" -OpenInNewWindow);
                                    Created  = $_.created;
                                    OS       = $_.os + " " + $_.version;
                                }
                            } | Out-UDGridData
                        } -NoExport
                    }
                    else
                    {
                        New-UDCard -Title "New Systems (Created in the last 7 days)" -Id "NewSystems" -Content {
                            New-UDunDraw -Name "operating-system" -Color $unDrawColor
                            New-UDParagraph -Text "No new systems have been added to your JumpCloud Organization in the past 7 days."
                        }
                    }
                }
            } 
        }
    }

    #$UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('Laptop')
    Return [PSCustomObject]@{
        'UDPage' = $UDPage;
        #    'UDSideNavItem' = $UDSideNavItem;
    }
}
