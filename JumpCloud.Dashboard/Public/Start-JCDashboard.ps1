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

.EXAMPLE
Start-JCDashboard

Launches the JumpCloud Dashboard with the default settings.

.EXAMPLE
Start-JCDashboard -LastContactDays 30

Launches the JumpCloud Dashboard and only displays systems that have contacted JumpCloud in the last 30 days.

.EXAMPLE
Start-JCDashboard -RefreshInterval 60

Launches the JumpCloud Dashboard and sets the component refresh interval to 60 seconds.

.EXAMPLE
Start-JCDashboard -Layout singleComponent -CycleInterval 90

Launches the JumpCloud Dashboard in singleComponent view mode with all components and cycles between pages every 90 seconds

.EXAMPLE
Start-JCDashboard -Layout gridView

Launches the JumpCloud Dashboard in gridView view mode with all components
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

        [Parameter(HelpMessage = 'Specify either gridview or singleComponent to display dashboards by component individually. GridView displays components in a single page, singleComponent displays components on individual pages, cycled by the CycleInterval parameter', Mandatory = $false)]
        [ValidateSet("gridView", "singleComponent")]
        $Layout = "default",

        [Parameter(HelpMessage = 'Prevent the dashboard module from auto updating')]
        [Switch]$NoUpdate,

        [Parameter(HelpMessage = 'Specify $true or $false to autolaunch the Dashboard in a browser once started.', Mandatory = $false)]
        [bool]$AutoLaunch = $true,

        [Parameter(HelpMessage = 'Dashboard port to launch on localhost', Mandatory = $false)]
        [Int]$Port

    )

    DynamicParam
    {
        If ((Get-PSCallStack).Command -like '*MarkdownHelp')
        {
            $Layout = "singleComponent"
        }
        $dict = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        If ($Layout -eq "singleComponent" -or $Layout -eq "gridView")
        {
            $attr = New-Object System.Management.Automation.ParameterAttribute
            $attr.HelpMessage = "Dashboard Components to include"
            $attr.ValueFromPipelineByPropertyName = $true
            $attrColl = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            $attrColl.Add($attr)
            $attrColl.Add((New-Object System.Management.Automation.ValidateSetAttribute("system_agentVersion", "system_lastContact", "system_newSystems", "system_os", "system_version", "system_mfaStatus", "user_mfaStatus", "user_newUsers", "user_passwordChanges", "user_passwordExpirations", "user_privilegedUsers", "user_userStates")))
            $param = New-Object System.Management.Automation.RuntimeDefinedParameter('IncludeComponent', [array], $attrColl)
            $dict.Add('IncludeComponent', $param)

            $attr1 = New-Object System.Management.Automation.Parameterattribute
            $attr1.HelpMessage = "Dashboard Components to exclude"
            $attr1.ValueFromPipelineByPropertyName = $true
            $attr1Coll = New-Object System.Collections.ObjectModel.Collection[System.attribute]
            $attr1Coll.Add($attr1)
            $attr1Coll.Add((New-Object System.Management.Automation.ValidateSetattribute("system_agentVersion", "system_lastContact", "system_newSystems", "system_os", "system_version", "system_mfaStatus", "user_mfaStatus", "user_newUsers", "user_passwordChanges", "user_passwordExpirations", "user_privilegedUsers", "user_userStates")))
            $param1 = New-Object System.Management.Automation.RuntimeDefinedParameter('ExcludeComponent', [array], $attr1Coll)
            $dict.Add('ExcludeComponent', $param1)

            $attr2 = New-Object System.Management.Automation.Parameterattribute
            $attr2.HelpMessage = "Cycle between pages on the dashboard measured in seconds"
            $attr2.ValueFromPipelineByPropertyName = $true
            $attr2Coll = New-Object System.Collections.ObjectModel.Collection[System.attribute]
            $attr2Coll.Add($attr2)
            $param2 = New-Object System.Management.Automation.RuntimeDefinedParameter('CycleInterval', [Int], $attr2Coll)
            $dict.Add('CycleInterval', $param2)

        }
        return $dict
    }

    process
    {
        # Setting vars for dynamic params

        if ($PSBoundParameters["IncludeComponent"])
        {
            $IncludeComponent = $PSBoundParameters["IncludeComponent"]

        }

        if ($PSBoundParameters["ExcludeComponent"])
        {
            $ExcludeComponent = $PSBoundParameters["ExcludeComponent"]

        }

        if ($PSBoundParameters["CycleInterval"])
        {
            $CycleInterval = $PSBoundParameters["CycleInterval"]

        }

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
            $RootPath = (Split-Path $PSScriptRoot -Parent)
            $InstalledModuleLocation = $RootPath
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

        if ($CycleInterval)
        {
            $DashboardSettings.'Dashboard'.Settings.cycleInterval = $CycleInterval
        }

        if ($LastContactDays)
        {
            $DashboardSettings.'2Get-UDsystems'.Settings.lastContactDays = $LastContactDays
            $DashboardSettings.'Dashboard'.Settings.lastContactDays = $LastContactDays
        }

        if ($RefreshInterval)
        {
            $DashboardSettings.'1Get-UDSystemUsers'.Settings.refreshInterval = $RefreshInterval
            $DashboardSettings.'2Get-UDsystems'.Settings.refreshInterval = $RefreshInterval
            $DashboardSettings.'3Get-UDOnboarding'.Settings.refreshInterval = $RefreshInterval
            $DashboardSettings.'Dashboard'.Settings.refreshInterval = $RefreshInterval
        }
        if ($IncludeComponent)
        {
            $DashboardSettings.'Dashboard'.Components.Systems = $DashboardSettings.'Dashboard'.Components.Systems | Where-Object { $_ -in $IncludeComponent }
            $DashboardSettings.'Dashboard'.Components.Users = $DashboardSettings.'Dashboard'.Components.Users | Where-Object { $_ -in $IncludeComponent }
            $DashboardSettings.'Dashboard'.Components.Onboarding = $DashboardSettings.'Dashboard'.Components.Onboarding | Where-Object { $_ -in $IncludeComponent }
        }
        if ($ExcludeComponent)
        {
            $DashboardSettings.'Dashboard'.Components.Systems = $DashboardSettings.'Dashboard'.Components.Systems | Where-Object { $_ -notin $ExcludeComponent }
            $DashboardSettings.'Dashboard'.Components.Users = $DashboardSettings.'Dashboard'.Components.Users | Where-Object { $_ -notin $ExcludeComponent }
            $DashboardSettings.'Dashboard'.Components.Onboarding = $DashboardSettings.'Dashboard'.Components.Onboarding | Where-Object { $_ -notin $ExcludeComponent }
        }
        if ($Port)
        {
            $DashboardSettings.'Dashboard'.Settings.Port = $Port
        }

        #$UDSideNavItems = @()
        #$Scripts = @()
        #$Stylesheets = @()

        if ($Layout -eq "default")
        {
            Start-JCDashboardDefault -OrgName:($OrgName) -DashboardSettings:($DashboardSettings)
        } elseif ($Layout -eq "gridView")
        {
            Start-JCDashboardGridView -OrgName:($OrgName) -DashboardSettings:($DashboardSettings)
        } elseif ($Layout -eq "singleComponent")
        {
            Start-JCDashboardSingleComponentView -OrgName:($OrgName) -DashboardSettings:($DashboardSettings)
        }

        ## Opens the dashboard
        if ($AutoLaunch -eq $true){
            Start-Process -FilePath:('http://127.0.0.1:' + "$($DashboardSettings.'Dashboard'.Settings.Port)")
        }
    }
}