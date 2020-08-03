Describe -Tag:('PSScriptAnalyzer') 'Running PSScriptAnalyzer' {
    BeforeAll{
        $FolderPath_Module = (Get-Item $PSScriptRoot).Parent.FullName
        Write-Host ('[status]Running PSScriptAnalyzer on: ' + $FolderPath_Module)
        $ScriptAnalyzerResults = Invoke-ScriptAnalyzer -Path:($FolderPath_Module) -Recurse -ExcludeRule PSReviewUnusedParameter, PSUseProcessBlockForPipelineCommand, PSAvoidUsingWMICmdlet, PSAvoidUsingPlainTextForPassword, PSAvoidUsingUsernameAndPasswordParams, PSAvoidUsingInvokeExpression, PSUseDeclaredVarsMoreThanAssignments, PSUseSingularNouns, PSAvoidGlobalVars, PSUseShouldProcessForStateChangingFunctions, PSAvoidUsingWriteHost, PSAvoidUsingPositionalParameters, PSUseApprovedVerbs, PSUseToExportFieldsInManifest, PSUseOutputTypeCorrectly, PSAvoidUsingCmdletAliases, PSShouldProcess
        If (-not [System.String]::IsNullOrEmpty($ScriptAnalyzerResults))
        {
            $ScriptAnalyzerResults | ForEach-Object {
                Write-Error ('[PSScriptAnalyzer][' + $_.Severity + '][' + $_.RuleName + '] ' + $_.Message + ' found in "' + $_.ScriptPath + '" at line ' + $_.Line + ':' + $_.Column)
            }
        }
        Else
        {
            Write-Host ('[success]ScriptAnalyzer returned no results')
        }
    }
    It 'script results'{
        $ScriptAnalyzerResults | Should -Be $null
    }
}
