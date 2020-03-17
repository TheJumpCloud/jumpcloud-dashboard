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

    $Script:DashboardSettings = $DashboardSettings
    if ($DashboardSettings.'Dashboard'.Components.Systems) {
        [int]$ProgressCounter = 0

        $UDPages = New-UDPage -Name "something" -Content {
            $list = @()
            $list = $DashboardSettings.'Dashboard'.Components.Systems
            if ($list.Length -match 1) {
                $PageLayout = '{"lg":[{"w":10,"x":1,"y":0,"i":"grid-element-' + $list + '"}]}'
            }
            if ($list.Length -match 2) {
                $PageLayout = '{"lg":[{"w":5,"x":1,"y":0,"i":"grid-element-' + $list[0] + '","moved":false,"static":true},{"w":5,"x":6,"y":0,"i":"grid-element-' + $list[1] + '","moved":false,"static":true}]}'
            }
            # $PageLayout = '{"lg":[{"w":4,"x":0,"y":0,"i":"grid-element-' + $list[0] + '"},{"w":4,"x":4,"y":0,"i":"grid-element-' + $list[1] + '"}]}'
            New-UDGridLayout -Layout $PageLayout -Content {
            $list | ForEach-Object {

            # $UDPages += New-Page -Name:($_) -Content {

                if ($Cache:DisplaySystems) {
                    Write-Debug "$($_): Cache exists"
                }
                else {
                    Write-Debug "$($_): Cache does not exist. Creating."
                    $SystemCache = New-SystemCache -lastContactDays:($DashboardSettings.'Dashboard'.Settings.lastContactDays) -refreshInterval:($DashboardSettings.'Dashboard'.Settings.refreshInterval)
                }

                # if ($count.count -eq 1){
                #     $PageLayout = '{"lg":[{"w":10,"x":1,"y":1,"i":"grid-element-' + $_ + '"}]}'
                # }
                # if ($count.count -eq 2) {
                #     $PageLayout = '{"lg":[{"w":4,"x":0,"y":0,"i":"grid-element-' + $_[0] + '"},{"w":4,"x":4,"y":0,"i":"grid-element-' + $_[1] + '"}]}'
                # }

                # New-UDGridLayout -Content {
                Invoke-Expression "UDElement-$($_) -LastContactDate $($DashboardSettings.'Dashboard'.Settings.lastContactDays) -unDrawColor '$($DashboardSettings.'Dashboard'.Settings.unDrawColor)' -RefreshInterval $($DashboardSettings.'Dashboard'.Settings.refreshInterval)"
                # } -Draggable -Resizable
            }


            $ProgressCounter++

            $PageProgressParams = @{

                Activity        = "Loading the $_ dashboard components"
                Status          = "Dashboard $ProgressCounter of $($DashboardSettings.'Dashboard'.Components.Systems.count)"
                PercentComplete = ($ProgressCounter / $($DashboardSettings.'Dashboard'.Components.Systems.count)) * 100

            }

            Write-Progress @PageProgressParams
        } -Draggable
    }
}

    # if ($DashboardSettings.'Dashboard'.Components.Users) {
    #     [int]$ProgressCounter = 0
    #     $DashboardSettings.'Dashboard'.Components.Users | ForEach-Object {

    #         $UDPages += New-UDPage -Name:($_) -Content {
    #             $PageLayout = '{"lg":[{"w":10,"x":1,"y":1,"i":"grid-element-' + $_ + '"}]}'

    #             New-UDGridLayout -Layout $PageLayout -Content {
    #                 Invoke-Expression "UDElement-$($_) -unDrawColor '$($DashboardSettings.'Dashboard'.Settings.unDrawColor)' -RefreshInterval $($DashboardSettings.'Dashboard'.Settings.refreshInterval)"
    #             }
    #         }

    #         $ProgressCounter++

    #         $PageProgressParams = @{

    #             Activity        = "Loading the $_ dashboard components"
    #             Status          = "Dashboard $ProgressCounter of $($DashboardSettings.'Dashboard'.Components.Users.count)"
    #             PercentComplete = ($ProgressCounter / $($DashboardSettings.'Dashboard'.Components.Users.count)) * 100

    #         }

    #         Write-Progress @PageProgressParams

    #     }
    # }

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
    Start-UDDashboard -Dashboard:($Dashboard) -Port:($DashboardSettings.'Dashboard'.Settings.Port) -ListenAddress:('127.0.0.1') -PublishedFolder $PublishedFolder -Force
}
