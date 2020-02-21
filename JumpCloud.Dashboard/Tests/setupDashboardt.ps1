[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $JumpCloudAPIKEY
)

# Required Modules

if (-not $(Get-InstalledModule -Name Selenium -ErrorAction Ignore ))
{
    Install-Module -Name Selenium -Scope CurrentUser -Force
}

# Firefox must be installed

$RootPath = Split-Path $PSScriptRoot -Parent

Import-Module "$RootPath/JumpCloud.Dashboard.psd1"

Start-JCDashboard -JumpCloudAPIKey $JumpCloudAPIKEY -NoUpdate

