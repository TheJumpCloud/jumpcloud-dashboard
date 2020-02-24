$FolderPath_Module = (Split-Path ($PSScriptRoot).ToString())

Write-Host ('[status]Running PSScriptAnalyzer on: ' + $FolderPath_Module)
$ScriptAnalyzerResults = Invoke-ScriptAnalyzer -Path:($FolderPath_Module) -Recurse -ExcludeRule PSAvoidUsingWMICmdlet,PSAvoidUsingPlainTextForPassword,PSAvoidUsingUsernameAndPasswordParams,PSAvoidUsingInvokeExpression,PSUseDeclaredVarsMoreThanAssignments,PSUseSingularNouns,PSAvoidGlobalVars,PSUseShouldProcessForStateChangingFunctions,PSAvoidUsingWriteHost,PSAvoidUsingPositionalParameters,PSUseApprovedVerbs

for  ($i =0; $i -lt $ScriptAnalyzerResults.Length; $i++) {
    If ($ScriptAnalyzerResults[$i].Severity -eq "Error") {
        Write-Host($ScriptAnalyzerResults[$i].Message)
        Write-Error ('Go fix the ScriptAnalyzer results!')
    }
    else {
        Write-Host ('[success]ScriptAnalyzer returned no results')
    }
}

# $ScriptAnalyzerResults | ForEach-Object {
#     If (_$.Severity != "Information" -OR _$ != "Warning")
#         {
#         Write-Host($ScriptAnalyzerResults)
#         Write-Error ('Go fix the ScriptAnalyzer results!')
#     }
#     Else
#     {
#         Write-Host ('[success]ScriptAnalyzer returned no results')
#     }
# }

