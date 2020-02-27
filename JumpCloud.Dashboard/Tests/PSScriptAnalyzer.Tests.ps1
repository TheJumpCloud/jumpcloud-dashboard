$FolderPath_Module = (Split-Path ($PSScriptRoot).ToString())

Write-Host ('[status]Running PSScriptAnalyzer on: ' + $FolderPath_Module)
$ScriptAnalyzerResults = Invoke-ScriptAnalyzer -Path:($FolderPath_Module) -Recurse -ExcludeRule PSAvoidUsingWMICmdlet,PSAvoidUsingPlainTextForPassword,PSAvoidUsingUsernameAndPasswordParams,PSAvoidUsingInvokeExpression,PSUseDeclaredVarsMoreThanAssignments,PSUseSingularNouns,PSAvoidGlobalVars,PSUseShouldProcessForStateChangingFunctions,PSAvoidUsingWriteHost,PSAvoidUsingPositionalParameters,PSUseApprovedVerbs,PSUseToExportFieldsInManifest


If ($ScriptAnalyzerResults)
{
    $ScriptAnalyzerResults
    Write-Error ('Go fix the ScriptAnalyzer results!')
}
Else
{
    Write-Host ('[success]ScriptAnalyzer returned no results')
}



Invoke-ScriptAnalyzer -Path:('C:\agent\_work\3\s\JumpCloud.Dashboard') -Recurse -ExcludeRule PSAvoidUsingWMICmdlet,PSAvoidUsingPlainTextForPassword,PSAvoidUsingUsernameAndPasswordParams,PSAvoidUsingInvokeExpression,PSUseDeclaredVarsMoreThanAssignments,PSUseSingularNouns,PSAvoidGlobalVars,PSUseShouldProcessForStateChangingFunctions,PSAvoidUsingWriteHost,PSAvoidUsingPositionalParameters,PSUseApprovedVerbs
