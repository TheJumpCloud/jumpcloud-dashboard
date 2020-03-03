Function Start-JCDashboardSingleComponentView() {
    param (
        [Parameter(Mandatory = $true)]
        $OrgName,
        [Parameter(Mandatory = $true)]
        $DashboardSettings
    )

    ## Declare container variables for dashboard items
    $UDPages = @()

    ## Call functions to build dashboard
    ##############################################################################################################
    $Theme = Get-JCTheme
    ##############################################################################################################
    $Script:DashboardSettings = $DashboardSettings
    if ($DashboardSettings.'Dashboard'.Components.Systems) {
        [int]$ProgressCounter = 0
        $DashboardSettings.'Dashboard'.Components.Systems | ForEach-Object {

            $UDPages += New-UDPage -Name:($_) -Content {
                $PageLayout = '{"lg":[{"w":10,"h":22,"x":1,"y":1,"i":"grid-element-' + $_ + '"}]}' 

                New-UDGridLayout -Layout $PageLayout -Content {
                    Invoke-Expression "UDElement-$($_) -LastContactDate $($DashboardSettings.'Dashboard'.Settings.lastContactDays) -unDrawColor '$($DashboardSettings.'Dashboard'.Settings.unDrawColor)' -RefreshInterval $($DashboardSettings.'Dashboard'.Settings.refreshInterval)"
                }
            }

            $ProgressCounter++

            $PageProgressParams = @{

                Activity        = "Loading the $_ dashboard components"
                Status          = "Dashboard $ProgressCounter of $($DashboardSettings.'Dashboard'.Components.Systems.count)"
                PercentComplete = ($ProgressCounter / $($DashboardSettings.'Dashboard'.Components.Systems.count)) * 100

            }

            Write-Progress @PageProgressParams

        }
    }

    if ($DashboardSettings.'Dashboard'.Components.Users) {
        [int]$ProgressCounter = 0
        $DashboardSettings.'Dashboard'.Components.Users | ForEach-Object {

            $UDPages += New-UDPage -Name:($_) -Content {
                $PageLayout = '{"lg":[{"w":10,"h":22,"x":1,"y":1,"i":"grid-element-' + $_ + '"}]}' 

                New-UDGridLayout -Layout $PageLayout -Content {
                    Invoke-Expression "UDElement-$($_) -unDrawColor '$($DashboardSettings.'Dashboard'.Settings.unDrawColor)' -RefreshInterval $($DashboardSettings.'Dashboard'.Settings.refreshInterval)"
                }
            }

            $ProgressCounter++

            $PageProgressParams = @{

                Activity        = "Loading the $_ dashboard components"
                Status          = "Dashboard $ProgressCounter of $($DashboardSettings.'Dashboard'.Components.Users.count)"
                PercentComplete = ($ProgressCounter / $($DashboardSettings.'Dashboard'.Components.Users.count)) * 100

            }

            Write-Progress @PageProgressParams

        }
    }

    $Navigation = New-UDSideNav -None
    $Pages = $UDPages
    $Dashboard = New-UDDashboard `
        -Title:("$($OrgName) Dashboard") `
        -Theme:($Theme) `
        -Navigation:($Navigation) `
        -Pages:($Pages) `
        -CyclePages `
        -CyclePagesInterval:($DashboardSettings.'Dashboard'.Settings.cycleInterval) `
        -NavBarLogo:(New-UDImage -Url:('/Images/jumpcloud.svg') -Height 42 -Width 56)

    ## Start the dashboard
    Start-UDDashboard -Dashboard:($Dashboard) -Port:(8003) -ListenAddress:('127.0.0.1') -PublishedFolder $PublishedFolder -Force
}
