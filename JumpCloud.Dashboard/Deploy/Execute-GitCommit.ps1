. ($PSScriptRoot + '/' + 'Get-Config.ps1')
. ($PSScriptRoot + '/Functions' + '/Invoke-GitCommit.ps1')
###########################################################################
Write-Host ('[status]Commit changes to:' + $GitSourceBranch + ';')
Invoke-GitCommit -BranchName:($GitSourceBranch)