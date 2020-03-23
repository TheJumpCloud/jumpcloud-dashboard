Function Start-JCDashboardGridView() {
    param (
        [Parameter(Mandatory = $true)]
        $OrgName,
        [Parameter(Mandatory = $true)]
        $DashboardSettings
    )

    ## Call functions to build dashboard
    ##############################################################################################################
    $Theme = Get-JCTheme
    ##############################################################################################################

    $Script:AllComponents = @()
    if ($DashboardSettings.'Dashboard'.Components.Systems) {
        $DashboardSettings.'Dashboard'.Components.Systems | ForEach-Object {
            $AllComponents += $_.trim()
        }
    }
    if ($DashboardSettings.'Dashboard'.Components.Users) {
        $DashboardSettings.'Dashboard'.Components.Users | ForEach-Object {
            $AllComponents += $_.trim()
        }
    }
    if ($DashboardSettings.'Dashboard'.Components.Onboarding) {
        $DashboardSettings.'Dashboard'.Components.Onboarding | ForEach-Object {
            $AllComponents += $_.trim()
        }
    }

    $Script:DashboardSettings = $DashboardSettings

    $UDPages = New-UDPage -Name "Custom" -Content {

        # Create cache
        Write-Debug "$($_): Cache does not exist. Creating."
        $SystemCache = New-SystemCache -lastContactDays:($DashboardSettings.'Dashboard'.Settings.lastContactDays) -refreshInterval:($DashboardSettings.'Dashboard'.Settings.refreshInterval)

        # Build out the PageLayout String
        if ($AllComponents.count -eq 1) {
            $PageLayout = '{"lg":[{"w":10,"x":1,"y":1,"i":"grid-element-' + $AllComponents + '"}]}'
            Write-Host $PageLayout
        } else {
            $i = 0
            $y = 4
            $PageLayout = '{"lg":['
            $AllComponents | ForEach-Object {
                $PageLayout += '{"w":4,"h":10,"x":' + [math]::Floor(($i % 3) * 4.51) + ',"y":' + $y + ',"i":"grid-element-' + $_ + '"}'
                if ((++$i % 3) -eq 0) {
                    $y += 11
                }
                if ($i -ne $AllComponents.count) {
                    $PageLayout += ','
                }
            }
            $PageLayout += ']}'
        }

        New-UDGridLayout -Layout $PageLayout -Content {
            if ($DashboardSettings.'Dashboard'.Components.Systems) {
                $DashboardSettings.'Dashboard'.Components.Systems | ForEach-Object {
                    Invoke-Expression "UDElement-$($_) -LastContactDate $($DashboardSettings.'Dashboard'.Settings.lastContactDays) -unDrawColor '$($DashboardSettings.'Dashboard'.Settings.unDrawColor)' -RefreshInterval $($DashboardSettings.'Dashboard'.Settings.refreshInterval)"
                }
            }
            if ($DashboardSettings.'Dashboard'.Components.Users) {
                $DashboardSettings.'Dashboard'.Components.Users | ForEach-Object {
                    Invoke-Expression "UDElement-$($_) -unDrawColor '$($DashboardSettings.'Dashboard'.Settings.unDrawColor)' -RefreshInterval $($DashboardSettings.'Dashboard'.Settings.refreshInterval)"
                }
            }
        } -Draggable -Resizable
    }

    $Navigation = New-UDSideNav -None
    $Dashboard = New-UDDashboard `
        -Title:("$($OrgName) Dashboard") `
        -Theme:($Theme) `
        -Navigation:($Navigation) `
        -Pages:($UDPages) `
        -NavBarLogo:(New-UDImage -Url:('/Images/jumpcloud.svg') -Height 42 -Width 56)

    ## Start the dashboard
    Start-UDDashboard -Dashboard:($Dashboard) -Port:($DashboardSettings.'Dashboard'.Settings.Port) -ListenAddress:('127.0.0.1') -PublishedFolder $PublishedFolder -Force
}