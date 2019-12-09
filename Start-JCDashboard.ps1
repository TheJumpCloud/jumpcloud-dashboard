Function Start-JCDashboard
{
    Param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Please enter your JumpCloud API key. This can be found in the JumpCloud admin console within "API Settings" accessible from the drop down icon next to the admin email address in the top right corner of the JumpCloud admin console.')]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(40, 40)]
        [System.String]
        $JumpCloudApiKey
    )
    ## Install PreReqs
    # Install-Module JumpCloud
    # Import-Module JumpCloud
    # Install-Module UniversalDashboard.Community -AcceptLicense
    # Import-Module UniversalDashboard
    # Get-Command -Module UniversalDashboard.Community

    ## Authenticate
    Connect-JCOnline -JumpCloudApiKey:($JumpCloudApiKey)
    ## Stop existing dashboards
    Get-UDDashboard | Stop-UDDashboard
    ## Declare container variables for dashboard items
    $UDPages = @()
    $UDSideNavItems = @()
    $Scripts = @()
    $Stylesheets = @()
    $PublishedFolder = Publish-UDFolder -Path:($PSScriptRoot + '/Images') -RequestPath "/Images"
    ## Get files from "Content-Pages" folder
    $ContentPagesFiles = Get-ChildItem -Path:($PSScriptRoot + '/Content-Pages/*.ps1') -Recurse
    ## Call functions to build dashboard
    ##############################################################################################################
    $Theme = Invoke-Expression -Command:($PSScriptRoot + '/Theme/Theme.ps1')
    $NavBarLinks = Invoke-Expression -Command:($PSScriptRoot + '/Navigation/NavBarLinks.ps1')
    ##############################################################################################################
    $ContentPagesFiles | ForEach-Object {
        ## Load functions from "Content-Pages" folder
        .($_.FullName)
        ## Run function
        $CommandResults = Invoke-Expression -Command:($_.BaseName)
        ## Add the output to the container variable
        $UDPages += $CommandResults.UDPage
        $UDSideNavItems += $CommandResults.UDSideNavItem
    }
    # Build dashboard
    $Navigation = New-UDSideNav -Content { $UDSideNavItems }
    $Pages = $UDPages
    $Dashboard = New-UDDashboard `
        -Title:('JumpCloud Directory Dashboard') `
        -Theme:($Theme) `
        -Pages:($Pages) `
        -Navigation:($Navigation) `
        -NavbarLinks:($NavBarLinks) `
        -NavBarLogo:(New-UDImage -Url:('/images/jumpcloud.svg') -Height 42 -Width 56)

    # -Scripts:($Scripts) `
    # -Stylesheets:($Stylesheets) `
    # -Footer:($Footer)

    ## Start the dashboard
    Start-UDDashboard -Dashboard:($Dashboard) -Port:(8000) -ListenAddress:('127.0.0.1') -PublishedFolder $PublishedFolder -Force
    ## Opens the dashboard
    #Start-Process -FilePath 'http://127.0.0.1:8000'


    # New-UDDashboard
    # -Content <scriptblock>                   OR             -Pages <Page[]>
    # -Navigation <SideNav>
    # -Scripts <string[]>
    # -Stylesheets <string[]>
    # -Footer <Footer>

    # -Title <string>
    # -CyclePages
    # -CyclePagesInterval <int>
    # -NavBarColor <DashboardColor>
    # -NavBarFontColor <DashboardColor>
    # -NavbarLinks <hashtable[]>
    # -NavBarLogo <Element>
    # -BackgroundColor <DashboardColor>
    # -FontColor <DashboardColor>
    # -Theme <Theme>
    # -EndpointInitialization <initialsessionstate>
    # -GeoLocation
    # -IdleTimeout <timespan>



    # $systeminsights22.UDPage.components
}