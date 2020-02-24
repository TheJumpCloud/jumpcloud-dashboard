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
Function Start-JCDashboard {
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

        [Parameter(Mandatory= $false)]
        [ValidateSet("AgentVersion", "LastContact", "NewSystems", "OS", "OSVersion", "SystemsMFA", "UsersMFA", "NewUsers", "PasswordChanges", "PasswordExpiration", "PrivilegedUsers", "UserState")]
        $IncludeComponent,

        [Parameter(Mandatory= $false)]
        [ValidateSet("AgentVersion", "LastContact", "NewSystems", "OS", "OSVersion", "SystemsMFA", "UsersMFA", "NewUsers", "PasswordChanges", "PasswordExpiration", "PrivilegedUsers", "UserState")]
        $ExcludeComponent,

        [Parameter(HelpMessage = 'Cycle between pages on the dashboard measured in seconds')]
        [Int]$CycleInterval,

        [Parameter(HelpMessage = 'Prevent the dashboard module from auto updating')]
        [Switch]$NoUpdate
        
        #[Switch]$Beta,
    )

    # Auto Update
    #if (! $NoUpdate)
    #
    #    $Updated = Update-ModuleToLatest -Name:($MyInvocation.MyCommand.Module.Name)
    #}

    ## Authentication
    if ($JumpCloudApiKey) {
        Connect-JCOnline -JumpCloudApiKey:($JumpCloudApiKey) -force
    }
    else {
        if ($JCAPIKEY.length -ne 40) { Connect-JCOnline }
    }

    ## Set Module Installed location
    #if ($Updated -eq $true)
    #{
    #    $InstalledModuleLocation = Get-InstalledModule JumpCloud.Dashboard | Select-Object -ExpandProperty InstalledLocation

    #    $Private = @( Get-ChildItem -Path "$InstalledModuleLocation/Private/*.ps1" -Recurse)

    #    Foreach ($Function in $Private)
    #    {
    #        Try
    #        {
    #            . $Function.FullName
    #            Write-Verbose "Imported $($Function.FullName)"
    #        }
    #        Catch
    #        {
    #            Write-Error -Message "Failed to import function $($Function.FullName): $_"
    #        }
    #    }

    #}

    #else
    #{
    $InstalledModuleLocation = $PSScriptRoot

    $Private = @( Get-ChildItem -Path "$InstalledModuleLocation/Private/*.ps1" -Recurse)

    Foreach ($Function in $Private) {
        Try {
            . $Function.FullName
            Write-Verbose "Imported $($Function.FullName)"
        }
        Catch {
            Write-Error -Message "Failed to import function $($Function.FullName): $_"
        }
    }
    #}

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

    if ($JCOrgID) {
        $hdrs.Add('x-org-id', "$($JCOrgID)")
    }

    $APICall = Invoke-RestMethod -Method GET -Uri  $SettingsURL -Headers $hdrs -UserAgent:(Get-JCUserAgent)

    ## Stop existing dashboards
    Get-UDDashboard | Stop-UDDashboard

    # ## Import Settings File
    $DashboardSettings = Get-Content -Raw -Path:($InstalledModuleLocation + '/' + 'DashboardSettings.json') | ConvertFrom-Json

    if ($LastContactDays) {
        $DashboardSettings.'2Get-UDsystems'.Settings.lastContactDays = $LastContactDays
    }

    if ($RefreshInterval) {
        $DashboardSettings.'1Get-UDSystemUsers'.Settings.refreshInterval = $RefreshInterval
        $DashboardSettings.'2Get-UDsystems'.Settings.refreshInterval = $RefreshInterval
    }


    #$UDSideNavItems = @()
    #$Scripts = @()
    #$Stylesheets = @()

    if ($Layout -eq "gridView") {
        Start-JCDashboardGridView($OrgName)
    }

    ## Opens the dashboard
    Start-Process -FilePath 'http://127.0.0.1:8003'

}