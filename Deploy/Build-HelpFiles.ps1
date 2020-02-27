. ($PSScriptRoot + '/' + 'setupDashboard.ps1')
###########################################################################
Write-Host ('[status]Importing current module: ' + $ModuleName)
Import-Module ($FilePath_psd1) -Force
Write-Host ('[status]Installing module: PlatyPS')
Install-Module -Name:('PlatyPS') -Force -Scope:('CurrentUser')
Write-Host ('[status]Creating/Updating help files')
If (Test-Path -Path:($FilePath_Md))
{
    # Write-Host ('Updating: ' + $FunctionName + '.md')
    Update-MarkdownHelp -Path:($FilePath_Md) -Force -ExcludeDontShow -UpdateInputOutput -UseFullTypeName
}
Else
{
    # Write-Host ('Creating: ' + $FunctionName + '.md')
    New-MarkdownHelp  -Command:($FunctionName) -OutputFolder:($FolderPath_Docs) -Force -ExcludeDontShow -UseFullTypeName
}
# Create new ExternalHelp file.
Write-Host ('[status]Creating new external help file')
New-ExternalHelp -Path:($FolderPath_Docs) -OutputPath:($FolderPath_enUS) -Force