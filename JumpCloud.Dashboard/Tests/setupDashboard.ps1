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

# Import Private Functions
$Private = @( Get-ChildItem -Path "../Private/*.ps1" -Recurse)
Foreach ($Function In @($Public + $Private)) {
    Try {
        . $Function.FullName
    }
    Catch {
        Write-Error -Message "Failed to import function $($Function.FullName): $_"
    }
}

$RootPath = Split-Path $PSScriptRoot -Parent

Import-Module "$RootPath/JumpCloud.Dashboard.psd1"

$testDashboard = Start-JCDashboard -JumpCloudAPIKey $JumpCloudAPIKEY -NoUpdate

