<#PSScriptInfo

.VERSION 1.0

.GUID 7917df3f-978f-4246-8e61-2fd55f1075f1

.AUTHOR Solution Architecture Team

.COMPANYNAME JumpCloud

.COPYRIGHT

.TAGS

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#>

<#

.DESCRIPTION
 Used to start the JumpCloud Dashboard instance.

#>
Function Start-JCDashboard
{
    Param(
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Please enter your JumpCloud API key. This can be found in the JumpCloud admin console within "API Settings" accessible from the drop down icon next to the admin email address in the top right corner of the JumpCloud admin console.')]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(40, 40)]
        [System.String]
        $JumpCloudApiKey,

        [Int]$LastContactDays = 90,

        [Int]$RefreshInterval = 30,

        #[Switch]$Beta,

        [Switch]$NoUpdate
    )

    # Auto Update
    if (! $NoUpdate)
    {
        Update-ModuleToLatest -Name:($MyInvocation.MyCommand.Module.Name)
    }

    ## Authentication
    if ($JumpCloudApiKey)
    {
        Connect-JCOnline -JumpCloudApiKey:($JumpCloudApiKey) -force
    }
    else
    {
        if ($JCAPIKEY.length -ne 40) { Connect-JCOnline }
    }

    ## Gather org name
    ## Pulled from the global $JCSettings variable popuplated by Connect-JCOnline
    $OrgName = $JCSettings.SETTINGS.name

    ## Stop existing dashboards
    Get-UDDashboard | Stop-UDDashboard

    # ## Import Settings File
    $DashboardSettings = Get-Content -Raw -Path:($PSScriptRoot + '/' + 'DashboardSettings.json') | ConvertFrom-Json

    if ($LastContactDays)
    {
        $DashboardSettings.'2Get-UDsystems'.Settings.lastContactDays = $LastContactDays
    }

    if ($RefreshInterval)
    {
        $DashboardSettings.'1Get-UDSystemUsers'.Settings.refreshInterval = $RefreshInterval
        $DashboardSettings.'2Get-UDsystems'.Settings.refreshInterval = $RefreshInterval
        
    }

    ## Declare container variables for dashboard items
    $UDPages = @()
    #$UDSideNavItems = @()
    $Scripts = @()
    $Stylesheets = @()

    ## Get files from "Content-Pages" folder
    $PublishedFolder = Publish-UDFolder -Path:($PSScriptRoot + '/Private/' + '/Images') -RequestPath "/Images"

    if ($Beta)
    {
        # If Beta Selected Then Load All Content-Pages
        $ContentPagesFiles = Get-ChildItem -Path:($PSScriptRoot + '/Private/' + '/Content-Pages/*.ps1') -Recurse
    }
    else
    {
        $ContentPagesFiles = Get-ChildItem -Path:($PSScriptRoot + '/Private/' + '/Content-Pages/Default/*.ps1') -Recurse
    }
    ## Call functions to build dashboard
    ##############################################################################################################
    $Theme = Invoke-Expression -Command:($PSScriptRoot + '/Private/' + '/Theme/Theme.ps1')
    $NavBarLinks = Invoke-Expression -Command:($PSScriptRoot + '/Private/' + '/Navigation/NavBarLinks.ps1')
    ##############################################################################################################

    [int]$ProgressCounter = 0

    $ContentPagesFiles | ForEach-Object {


        ## Load functions from "Content-Pages" folder
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

    ## Opens the dashboard
    Start-Process -FilePath 'http://127.0.0.1:8003'

}