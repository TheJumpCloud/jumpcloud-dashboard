. ($PSScriptRoot + '/' + 'setupDashboard.ps1')
###########################################################################
Write-Host ('[status]Importing current module: ' + $ModuleName)
Import-Module ($FilePath_psd1) -Force
# Clear out existing docs
If (Test-Path -Path:($FolderPath_Docs))
{
    Remove-Item -Path:($FolderPath_Docs) -Recurse -Force
}
If (Test-Path -Path:($FolderPath_enUS))
{
    Remove-Item -Path:($FolderPath_enUS) -Recurse -Force
}
Write-Host ('[status]Creating help files')
$Files = Get-ChildItem -Path:($ModuleFolderPath) -File | Where-Object { $_.Extension -eq '.ps1' }
$Files | ForEach-Object {
    $FunctionName = $_.BaseName
        Write-Host ('Creating: ' + $FunctionName + '.md')
        New-MarkdownHelp -Command:($FunctionName) -OutputFolder:($FolderPath_Docs) -Force -ExcludeDontShow -OnlineVersionUrl:($GitHubWikiUrl + $FunctionName) -UseFullTypeName
}
# Create new ExternalHelp file.
Write-Host ('[status]Creating new external help file')
New-ExternalHelp -Path:($FolderPath_Docs) -OutputPath:($FolderPath_enUS) -Force