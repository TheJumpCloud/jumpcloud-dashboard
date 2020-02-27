#Vars
$ModuleName = 'JumpCloud.Dashboard'
$ModuleFolderPath = (Get-Item -Path:($PSScriptRoot)).Parent.FullName + '\' + $ModuleName
$FilePath_psd1 = $ModuleFolderPath + '\' + $ModuleName + '.psd1'
$FolderPath_Docs = $ModuleFolderPath + '\Docs\'
$FolderPath_enUS = $ModuleFolderPath + '\en-US\'
$GitHubWikiUrl = 'https://github.com/TheJumpCloud/jumpcloud-dashboard/wiki/'
# Install required modules
$RequiredModules = ('PSScriptAnalyzer', 'Pester', 'platyPS', 'Selenium', 'UniversalDashboard.Community', 'UniversalDashboard.UDunDraw', 'JumpCloud')
ForEach ($RequiredModule In $RequiredModules)
{
    # Check to see if the module is imported
    If ((Get-Module -Name:($RequiredModule) -ErrorAction:('SilentlyContinue')))
    {
        Remove-Module -Name:($RequiredModule) -Force
    }
    # Check to see if the module is installed
    If (Get-InstalledModule -Name:($RequiredModule) -ErrorAction:('SilentlyContinue'))
    {
        Write-Host ('Updating module: ' + $RequiredModule)
        Update-Module -Name:($RequiredModule) -Force
    }
    # Check to see if the module exists on the PSGallery
    ElseIf (Find-Module -Name:($RequiredModule))
    {
        Write-Host ('Installing module: ' + $RequiredModule)
        Install-Module -Name:($RequiredModule) -Force -SkipPublisherCheck
    }
    Import-Module -Name:($RequiredModule) -Force
}
# Remove the module that is being developed if it exists in the current session
If ((Get-Module -Name:($ModuleName) -ErrorAction:('SilentlyContinue')))
{
    Remove-Module -Name:($ModuleName) -Force
}
# Import the current version of the module that is in development
Import-Module ($FilePath_psd1) -Force