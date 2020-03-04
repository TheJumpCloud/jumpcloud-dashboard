Param(
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)][ValidateNotNullOrEmpty()][System.String]$TestOrgAPIKey
)
. ((Get-Item -Path($PSScriptRoot)).Parent.Parent.FullName + '/Deploy/Get-Config.ps1')
###########################################################################
#ud setup
# Start-JCDashboard -JumpCloudAPIKey $TestOrgAPIKey -NoUpdate
# Run Pester tests
$PesterResults = Invoke-Pester -Script:($PSScriptRoot) -PassThru -ExcludeTag:('PSScriptAnalyzer')
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