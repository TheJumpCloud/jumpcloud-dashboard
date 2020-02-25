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

$RootPath = Split-Path $PSScriptRoot -Parent

Import-Module "$RootPath/JumpCloud.Dashboard.psd1"

$testDashboard = Start-JCDashboard -JumpCloudAPIKey $JumpCloudAPIKEY -NoUpdate
start-sleep -Seconds 60