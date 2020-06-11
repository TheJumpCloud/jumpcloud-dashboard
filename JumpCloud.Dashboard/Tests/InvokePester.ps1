
Param(
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)][ValidateNotNullOrEmpty()][System.String]$TestOrgAPIKey
)
. ((Get-Item -Path($PSScriptRoot)).Parent.Parent.FullName + '/Deploy/Get-Config.ps1')
###########################################################################
# Run Pester tests
$PesterTestResultPath = $PSScriptRoot + "/Dashboard-TestResults.xml"
If (Test-Path -Path:($PesterTestResultPath)) { Remove-Item -Path:($PesterTestResultPath) -Force }
$PesterResults = Invoke-Pester -PassThru -Path:($PSScriptRoot)
$PesterResults | Export-NUnitReport -Path:($PesterTestResultPath)
If (Test-Path -Path:($PesterTestResultPath))
{
    [xml]$PesterResults = Get-Content -Path:($PesterTestResultPath)
    $FailedTests = $PesterResults.'test-results'.'test-suite'.'results'.'test-suite' | Where-Object { $_.success -eq 'False' }
    If ($FailedTests)
    {
        Write-Host ('')
        Write-Host ('##############################################################################################################')
        Write-Host ('##############################Error Description###############################################################')
        Write-Host ('##############################################################################################################')
        Write-Host ('')
        $FailedTests | ForEach-Object { $_.InnerText + ';' }
        Write-Error -Message:('Tests Failed: ' + [string]($FailedTests | Measure-Object).Count)
    }
}