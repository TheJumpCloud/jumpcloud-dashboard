Describe 'Build Tests' {

    Context 'Check Files Exist' {
        It 'DashboardSettings.json exists' {
            (Test-Path -Path ((Split-Path ($PSScriptRoot).ToString()) + '\DashboardSettings.json') | Should Be $true)
        }
        It 'README.md exists' {
            (Test-Path -Path ((Split-Path ($PSScriptRoot).ToString()) + '\README.md') | Should Be $true)
        }
        It 'Start-JCDashboard.ps1 exists' {
            (Test-Path -Path ((Split-Path ($PSScriptRoot).ToString()) + '\Start-JCDashboard.ps1') | Should Be $true)
        }
    }
}