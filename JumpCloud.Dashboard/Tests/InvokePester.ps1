
Param(
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)][ValidateNotNullOrEmpty()][System.String]$TestOrgAPIKey
)
. ((Get-Item -Path($PSScriptRoot)).Parent.Parent.FullName + '/Deploy/Get-Config.ps1')
###########################################################################
# Run Pester tests
[xml]$PesterResults = Invoke-Pester ($PSScriptRoot) -PassThru | ConvertTo-NUnitReport -AsString
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