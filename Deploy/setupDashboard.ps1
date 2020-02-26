# Checks For Required Modules - Selenium

if (-not $(Get-InstalledModule -Name Selenium -ErrorAction Ignore ))
{
    Install-Module -Name Selenium -Scope CurrentUser -Force
}

if ((Get-Module -Name JumpCloud.Dashboard -ErrorAction Ignore ))
{
    remove-Module -Name JumpCloud.Dashboard
}

Install-Module  "UniversalDashboard.Community", "UniversalDashboard.UDunDraw", "JumpCloud"  -Force -Scope CurrentUser

$FilePath_psd1 = (Split-Path ($PSScriptRoot).ToString()) + '\JumpCloud.Dashboard\JumpCloud.Dashboard.psd1'
Import-Module ($FilePath_psd1) -Force