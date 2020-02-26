[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $JumpCloudAPIKEY
)

try{
# Cheks For Required Modules - Selenium

if (-not $(Get-InstalledModule -Name Selenium -ErrorAction Ignore ))
{
    Install-Module -Name Selenium -Scope CurrentUser -Force
}

$RootPath = Split-Path $PSScriptRoot -Parent

#choco uninstall firefox -y
#choco install firefox --version=60.0 -y

Import-Module "$RootPath/JumpCloud.Dashboard.psd1"
#Get-UDDashboard | Stop-UDDashboard
Start-JCDashboard -JumpCloudAPIKey $JumpCloudAPIKEY -NoUpdate
Get-UDDashboard
Write-Host ('Test1: ' + $Error)
Write-Host ('Test2: ' + $_)
$Error.Clear()
}
Catch{
    Write-Error $Error
}