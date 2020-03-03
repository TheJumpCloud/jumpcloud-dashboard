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
    [CmdletBinding(HelpURI = "https://github.com/TheJumpCloud/support/wiki/Start-JCDashboard")]
    Param(
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Please enter your JumpCloud API key. This can be found in the JumpCloud admin console within "API Settings" accessible from the drop down icon next to the admin email address in the top right corner of the JumpCloud admin console.')]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(40, 40)]
        [System.String]
        $JumpCloudApiKey,

        [Parameter(HelpMessage = 'Include systems that have contacted the JumpCloud directory within this number of days')]
        [Int]$LastContactDays,

        [Parameter(HelpMessage = 'Refresh the components on the dashboard measured in seconds')]
        [Int]$RefreshInterval,

        [Parameter(Mandatory = $false)]
        [ValidateSet("gridView", "singleComponent")]
        $Layout = "gridView",

        [Parameter(Mandatory = $false)]
        [ValidateSet("AgentVersion", "LastContact", "NewSystems", "OS", "OSVersion", "SystemsMFA", "UsersMFA", "NewUsers", "PasswordChanges", "PasswordExpiration", "PrivilegedUsers", "UserState")]
        [array]$IncludeComponent,

        [Parameter(Mandatory = $false)]
        [ValidateSet("AgentVersion", "LastContact", "NewSystems", "OS", "OSVersion", "SystemsMFA", "UsersMFA", "NewUsers", "PasswordChanges", "PasswordExpiration", "PrivilegedUsers", "UserState")]
        [array]$ExcludeComponent,

        [Parameter(HelpMessage = 'Cycle between pages on the dashboard measured in seconds')]
        [Int]$CycleInterval,

        [Parameter(HelpMessage = 'Prevent the dashboard module from auto updating')]
        [Switch]$NoUpdate
        
        #[Switch]$Beta,
    )

    # Auto Update
    if (! $NoUpdate)
    {
        $Updated = Update-ModuleToLatest -Name:($MyInvocation.MyCommand.Module.Name)
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

    ## Set Module Installed location
    if ($Updated -eq $true)
    {
        $InstalledModuleLocation = Get-InstalledModule JumpCloud.Dashboard | Select-Object -ExpandProperty InstalledLocation

        $Private = @( Get-ChildItem -Path "$InstalledModuleLocation/Private/*.ps1" -Recurse)

        Foreach ($Function in $Private)
        {
            Try
            {
                . $Function.FullName
                Write-Verbose "Imported $($Function.FullName)"
            }
            Catch
            {
                Write-Error -Message "Failed to import function $($Function.FullName): $_"
            }
        }

    }
    else
    {
        $InstalledModuleLocation = (Get-Item($PSScriptRoot)).Parent.FullName
    }

    ## Gather org name
    ## Pulled from the global $JCSettings variable popuplated by Connect-JCOnline
    $OrgName = $JCSettings.SETTINGS.name

    ## Call API
    $SettingsURL = "$JCUrlBasePath" + '/api/settings'
    $hdrs = @{

        'Content-Type' = 'application/json'
        'Accept'       = 'application/json'
        'X-API-KEY'    = $JCAPIKEY
    }

    if ($JCOrgID)
    {
        $hdrs.Add('x-org-id', "$($JCOrgID)")
    }

    $APICall = Invoke-RestMethod -Method GET -Uri  $SettingsURL -Headers $hdrs -UserAgent:(Get-JCUserAgent)

    ## Stop existing dashboards
    Get-UDDashboard | Stop-UDDashboard

    # ## Import Settings File
    $DashboardSettings = Get-Content -Raw -Path:($InstalledModuleLocation + '/' + 'Public/DashboardSettings.json') | ConvertFrom-Json

    if ($CycleInterval) {
        $DashboardSettings.'Dashboard'.Settings.cycleInterval = $CycleInterval
    }

    if ($LastContactDays) {
        $DashboardSettings.'2Get-UDsystems'.Settings.lastContactDays = $LastContactDays
        $DashboardSettings.'Dashboard'.Settings.lastContactDays = $LastContactDays
    }

    if ($RefreshInterval) {
        $DashboardSettings.'1Get-UDSystemUsers'.Settings.refreshInterval = $RefreshInterval
        $DashboardSettings.'2Get-UDsystems'.Settings.refreshInterval = $RefreshInterval
        $DashboardSettings.'Dashboard'.Settings.refreshInterval = $RefreshInterval
    }
    if ($IncludeComponent) {
        $DashboardSettings.'Dashboard'.Components.Systems = $DashboardSettings.'Dashboard'.Components.Systems | Where-Object { $_ -in $IncludeComponent }
        $DashboardSettings.'Dashboard'.Components.Users = $DashboardSettings.'Dashboard'.Components.Users | Where-Object { $_ -in $IncludeComponent }
    }
    if ($ExcludeComponent) {
        $DashboardSettings.'Dashboard'.Components.Systems = $DashboardSettings.'Dashboard'.Components.Systems | Where-Object { $_ -notin $ExcludeComponent }
        $DashboardSettings.'Dashboard'.Components.Users = $DashboardSettings.'Dashboard'.Components.Users | Where-Object { $_ -notin $ExcludeComponent }
    }

    #$UDSideNavItems = @()
    #$Scripts = @()
    #$Stylesheets = @()

    if ($Layout -eq "gridView") {
        Start-JCDashboardGridView -OrgName:($OrgName) -DashboardSettings:($DashboardSettings)
    }

    if ($Layout -eq "singleComponent") {
        Start-JCDashboardSingleComponentView -OrgName:($OrgName) -DashboardSettings:($DashboardSettings)
    }

    ## Opens the dashboard
    Start-Process -FilePath 'http://127.0.0.1:8003'
}