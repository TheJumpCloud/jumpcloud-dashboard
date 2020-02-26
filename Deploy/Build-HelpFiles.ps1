Install-Module  "UniversalDashboard.Community", "UniversalDashboard.UDunDraw", "JumpCloud",  "JumpCloud.Dashboard"  -Force -Scope CurrentUser
. ($PSScriptRoot + '/' + 'Get-Config.ps1')
###########################################################################
Write-Host ('[status]Importing current module: ' + $ModuleName)
$FilePath_psd1 = (Split-Path ($PSScriptRoot).ToString()) + '\JumpCloud.Dashboard.psd1'
Import-Module ($FilePath_psd1) -Force
Write-Host ('[status]Installing module: PlatyPS')
Install-Module -Name:('PlatyPS') -Force -Scope:('CurrentUser')
Write-Host ('[status]Creating/Updating help files')
    $FunctionName = 'Start-JCDashboard'
    $FolderPath_Docs = (Split-Path ($PSScriptRoot).ToString()) + '\Docs\'
    $FilePath_Md = $FolderPath_Docs + 'Start-JCDashboard.md'

    If (Test-Path -Path:($FilePath_Md))
    {
        # Write-Host ('Updating: ' + $FunctionName + '.md')
        Update-MarkdownHelp -Path:($FilePath_Md) -Force -ExcludeDontShow -UpdateInputOutput -UseFullTypeName
    }
    Else
    {
        # Write-Host ('Creating: ' + $FunctionName + '.md')
        New-MarkdownHelp  -Command:($FunctionName) -OutputFolder:($FolderPath_Docs) -Force -ExcludeDontShow -OnlineVersionUrl:($GitHubWikiUrl + $FunctionName) -UseFullTypeName
    }
# Create new ExternalHelp file.
Write-Host ('[status]Creating new external help file')
New-ExternalHelp -Path:($FolderPath_Docs) -OutputPath:($FolderPath_enUS) -Force