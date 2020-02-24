Function Start-JCDashboardGridView () {

    param (
        [Parameter(Mandatory=$true)]
        $OrgName
    )
    ## Declare container variables for dashboard items
    $UDPages = @()

    ## Get files from "UDPages" folder
    $PublishedFolder = Publish-UDFolder -Path:($InstalledModuleLocation + '/Private/' + 'Images') -RequestPath "/Images"

    if ($Beta) {
        # If Beta Selected Then Load All UDPages
        $ContentPagesFiles = Get-ChildItem -Path:($InstalledModuleLocation + '/Private/' + 'UDPages/*.ps1') -Recurse
    }
    else {
        $ContentPagesFiles = Get-ChildItem -Path:($InstalledModuleLocation + '/Private/' + 'UDPages/Default/*.ps1') -Recurse
    }
    ## Call functions to build dashboard
    ##############################################################################################################
    $Theme = Get-JCTheme
    $NavBarLinks = Get-JCNavBarLinks
    ##############################################################################################################

    [int]$ProgressCounter = 0

    $ContentPagesFiles | ForEach-Object {


        ## Load functions from "UDPages" folder
        .($_.FullName)
        Write-Verbose "Loading $($_.BaseName)"

        ## Write progress logic
        $PageName = ($($_.BaseName) -split '-UD')[1]
        $ProgressCounter++

        $PageProgressParams = @{

            Activity        = "Loading the $PageName dashboard components"
            Status          = "Dashboard $ProgressCounter of $($ContentPagesFiles.count)"
            PercentComplete = ($ProgressCounter / $($ContentPagesFiles.count)) * 100

        }

        Write-Progress @PageProgressParams

        ## Load the Page Settings
        $PageSettings = $($DashboardSettings."$($_.BaseName)".'Settings')

        ## Compile the parameters
        $commandParams = ''

        $($PageSettings).PSObject.Properties | ForEach-Object {
            $commandParams = $commandParams + '-' + "$($_.Name) " + "'$($_.Value)' "
        }
        Write-Debug $commandParams

        ## Run function to load the page
        $CommandResults = Invoke-Expression "$($_.BaseName) $commandParams"

        ## Add the output to the container variable
        $UDPages += $CommandResults.UDPage
        #$UDSideNavItems += $CommandResults.UDSideNavItem
    }
    # Build dashboard
    $Navigation = New-UDSideNav -None
    $Pages = $UDPages
    $Dashboard = New-UDDashboard `
        -Title:("$($OrgName) Dashboard") `
        -Theme:($Theme) `
        -Pages:($Pages) `
        -Navigation:($Navigation) `
        -NavbarLinks:($NavBarLinks) `
        -NavBarLogo:(New-UDImage -Url:('/images/jumpcloud.svg') -Height 42 -Width 56)

    # -Scripts:($Scripts) `
    # -Stylesheets:($Stylesheets) `
    # -Footer:($Footer)

    ## Start the dashboard
    Start-UDDashboard -Dashboard:($Dashboard) -Port:(8003) -ListenAddress:('127.0.0.1') -PublishedFolder $PublishedFolder -Force
}