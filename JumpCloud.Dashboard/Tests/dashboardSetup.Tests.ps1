Describe 'Build Tests' {
    BeforeAll {
        Get-UDDashboard | Stop-UDDashboard
        Start-JCDashboard -JumpCloudAPIKey $TestOrgAPIKey -NoUpdate
    }
    Context 'Check Files Exist' {
        $ModuleRootPath = (Get-Item -Path($PSScriptRoot)).Parent.FullName
        It 'README.md exists' {
            (Test-Path -Path:($ModuleRootPath + '/README.md') | Should Be $true)
        }
        It 'DashboardSettings.json exists' {
            (Test-Path -Path:($ModuleRootPath + '/Public/DashboardSettings.json') | Should Be $true)
        }
        It 'Start-JCDashboard.ps1 exists' {
            (Test-Path -Path:($ModuleRootPath + '/Public/Start-JCDashboard.ps1') | Should Be $true)
        }
    }
    AfterAll {
        Get-UDDashboard | Stop-UDDashboard
    }
}