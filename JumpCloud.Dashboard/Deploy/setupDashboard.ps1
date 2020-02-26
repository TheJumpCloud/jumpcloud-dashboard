[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $JumpCloudAPIKEY
)

# Cheks For Required Modules - Selenium

if (-not $(Get-InstalledModule -Name Selenium -ErrorAction Ignore ))
{
    Install-Module -Name Selenium -Scope CurrentUser -Force
}

if ((Get-Module -Name JumpCloud.Dashboard -ErrorAction Ignore ))
{
    remove-Module -Name JumpCloud.Dashboard
}

Install-Module  "UniversalDashboard.Community", "UniversalDashboard.UDunDraw", "JumpCloud"  -Force -Scope CurrentUser

$RootPath = Split-Path $PSScriptRoot -Parent
Import-Module "$RootPath/JumpCloud.Dashboard.psd1"

#Start-JCDashboard -JumpCloudAPIKey $JumpCloudAPIKEY -NoUpdate
#Get-UDDashboard