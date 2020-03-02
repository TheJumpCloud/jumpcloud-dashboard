$RequiredModules = ('PSScriptAnalyzer', 'Pester', 'platyPS', 'Selenium', 'UniversalDashboard.Community', 'UniversalDashboard.UDunDraw', 'JumpCloud')
ForEach ($RequiredModule In $RequiredModules)
{
    # Check to see if the module is installed
    If (-not (Get-InstalledModule -Name:($RequiredModule) -ErrorAction:('SilentlyContinue')))
    {
        Write-Host ('Installing module: ' + $RequiredModule)
        Install-Module -Name:($RequiredModule) -Force -Scope:('CurrentUser')
    }
    Write-Host ('Importing module: ' + $RequiredModule)
    Import-Module -Name:($RequiredModule) -Force -Scope:('Global')
}