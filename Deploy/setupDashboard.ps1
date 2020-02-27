#Vars
$FunctionName = 'Start-JCDashboard'
$FolderPath_Docs = (Split-Path ($PSScriptRoot).ToString()) + '\Docs\'
$FolderPath_enUS = (Split-Path ($PSScriptRoot).ToString()) + '\en-US\'
$FilePath_Md = $FolderPath_Docs + 'Start-JCDashboard.md'
$FilePath_psd1 = (Split-Path ($PSScriptRoot).ToString()) + '\JumpCloud.Dashboard\JumpCloud.Dashboard.psd1'

# Checks For Required Modules
if (Get-Module -ListAvailable -Name PSScriptAnalyzer) {
    Write-Host "psscriptanalyzer module installed"
    } else {
    Write-Host "Installing psscriptanalyzer"
    Install-Module -Name:('psscriptanalyzer') -Force -Scope:('CurrentUser') -SkipPublisherCheck
}

if (Get-Module -ListAvailable -Name Pester) {
    Write-Host "pester module installed"
    } else {
    Write-Host "Installing pester"
    Install-Module -Name:('pester') -Force -Scope:('CurrentUser') -SkipPublisherCheck
}

if (Get-Module -ListAvailable -Name Selenium) {
    Write-Host "selenium module installed"
    } else {
    Write-Host "Installing selenium"
    Install-Module -Name:('selenium') -Force -Scope:('CurrentUser') -SkipPublisherCheck
}

if ((Get-Module -Name JumpCloud.Dashboard -ErrorAction Ignore ))
{
    remove-Module -Name JumpCloud.Dashboard
}

# Install Required Modules
Install-Module  "UniversalDashboard.Community", "UniversalDashboard.UDunDraw", "JumpCloud"  -Force -Scope CurrentUser

# Import JCDashboard Module
Import-Module ($FilePath_psd1) -Force