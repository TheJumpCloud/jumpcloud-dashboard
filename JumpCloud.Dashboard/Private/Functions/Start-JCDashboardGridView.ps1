Function Start-JCDashboardGridView() {
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

    $Script:AllComponents = @($DashboardSettings.'Dashboard'.Components.Users) + @($DashboardSettings.'Dashboard'.Components.Systems)

    $Script:DashboardSettings = $DashboardSettings
    if ($AllComponents) {
        [int]$ProgressCounter = 0

        $UDPages = New-UDPage -Name "Custom" -Content {

            $AllComponents | ForEach-Object {

                # $UDPages += New-Page -Name:($_) -Content {
                $count = $AllComponents | Measure-Object

                if ($Cache:DisplaySystems) {
                    Write-Debug "$($_): Cache exists"
                }
                else {
                    Write-Debug "$($_): Cache does not exist. Creating."
                    $SystemCache = New-SystemCache -lastContactDays:($DashboardSettings.'Dashboard'.Settings.lastContactDays) -refreshInterval:($DashboardSettings.'Dashboard'.Settings.refreshInterval)
                }

                if ($count.count -eq 1) {
                    $Script:PageLayout = '{"lg":[{"w":10,"x":1,"y":1,"i":"grid-element-' + $_ + '"}]}'
                } elseif ($count.count -eq 2) {
                    $Script:PageLayout = '{"lg":[{"w":10,"x":0,"y":4,"i":"grid-element-' + $_[0] + '"},{"w":10,"x":4,"y":4,"i":"grid-element-' + $_[1] + '"}]}'
                } else {

                }
            }
        
            New-UDGridLayout -Layout $PageLayout -Content {
                $AllComponents | ForEach-Object {
                    Invoke-Expression "UDElement-$($_) -LastContactDate $($DashboardSettings.'Dashboard'.Settings.lastContactDays) -unDrawColor '$($DashboardSettings.'Dashboard'.Settings.unDrawColor)' -RefreshInterval $($DashboardSettings.'Dashboard'.Settings.refreshInterval)"
                } 
            } -Draggable -Resizable

            $ProgressCounter++

            $PageProgressParams = @{

                Activity        = "Loading the $_ dashboard components"
                Status          = "Dashboard $ProgressCounter of $($AllComponents.count)"
                PercentComplete = ($ProgressCounter / $($AllComponents.count)) * 100

            }

            Write-Progress @PageProgressParams

        }
    }

    $Navigation = New-UDSideNav -None
    $Dashboard = New-UDDashboard `
        -Title:("$($OrgName) Dashboard") `
        -Theme:($Theme) `
        -Navigation:($Navigation) `
        -Pages:($UDPages) `
        -CyclePages `
        -CyclePagesInterval:($DashboardSettings.'Dashboard'.Settings.cycleInterval) `
        -NavBarLogo:(New-UDImage -Url:('/Images/jumpcloud.svg') -Height 42 -Width 56)

    ## Start the dashboard
    Start-UDDashboard -Dashboard:($Dashboard) -Port:($DashboardSettings.'Dashboard'.Settings.Port) -ListenAddress:('127.0.0.1') -PublishedFolder $PublishedFolder -Force
}
