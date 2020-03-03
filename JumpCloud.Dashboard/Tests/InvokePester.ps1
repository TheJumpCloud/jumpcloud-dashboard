Param(
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)][ValidateNotNullOrEmpty()][System.String]$TestOrgAPIKey
)
. ((Get-Item -Path($PSScriptRoot)).Parent.Parent.FullName + '/Deploy/Get-Config.ps1')
###########################################################################
#Start UDDashbaord
Start-JCDashboard -port 8004 -JumpCloudAPIKey $TestOrgAPIKey -NoUpdate -Layout singleComponent -IncludeComponent "AgentVersion", "LastContact", "NewSystems", "OS", "OSVersion", "SystemsMFA", "UsersMFA", "NewUsers", "PasswordChanges", "PasswordExpiration", "PrivilegedUsers", "UserState" -cycleInterval 5
Start-JCDashboard -port 8003 -JumpCloudAPIKey $TestOrgAPIKey -NoUpdate

# Run Pester tests
$PesterResults = Invoke-Pester -Script:($PSScriptRoot) -PassThru
$FailedTests = $PesterResults.TestResult | Where-Object { $_.Passed -eq $false }
If ($FailedTests)
{
    Write-Output ('')
    Write-Output ('##############################################################################################################')
    Write-Output ('##############################Error Description###############################################################')
    Write-Output ('##############################################################################################################')
    Write-Output ('')
    $FailedTests | ForEach-Object { $_.Name + '; ' + $_.FailureMessage + '; ' }
    Write-Error -Message:('Tests Failed: ' + [string]($FailedTests | Measure-Object).Count)
}