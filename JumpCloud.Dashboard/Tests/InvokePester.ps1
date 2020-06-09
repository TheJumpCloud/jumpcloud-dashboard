
Param(
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)][ValidateNotNullOrEmpty()][System.String]$TestOrgAPIKey
)
. ((Get-Item -Path($PSScriptRoot)).Parent.Parent.FullName + '/Deploy/Get-Config.ps1')
###########################################################################
# Run Pester tests
$PesterTestResultPath = $PSScriptRoot + "/Dashboard-TestResults.xml"
Invoke-Pester -PassThru | ConvertTo-NUnitReport -AsString | Out-File -FilePath:($PesterTestResultPath)
[xml]$PesterResults = Get-Content -Path($PesterTestResultPath)
$FailedTests = $PesterResults.'test-results'.'test-suite'.'results'.'test-suite' | Where-Object { $_.success -eq 'False' }
If ($FailedTests)
{
    Write-Host ('')
    Write-Host ('##############################################################################################################')
    Write-Host ('##############################Error Description###############################################################')
    Write-Host ('##############################################################################################################')
    Write-Host ('')
    $FailedTests | ForEach-Object { $_.InnerText + ';' }
    Write-Host("##vso[task.logissue type=error;]" + 'Tests Failed: ' + [string]($FailedTests | Measure-Object).Count)
    Write-Error -Message:('Tests Failed: ' + [string]($FailedTests | Measure-Object).Count)
}
Write-Host($PesterResults)
Write-Host($PesterTestResultPath)