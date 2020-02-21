Param(
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, Position = 0)][ValidateNotNullOrEmpty()][System.String]$TestOrgAPIKey,
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, Position = 2)][System.String[]]$ExcludeTagList,
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, Position = 3)][System.String[]]$IncludeTagList
)
$ModuleManifestName = 'JumpCloud.Dashboard.psd1'

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
