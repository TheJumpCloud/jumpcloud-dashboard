Describe 'Build Tests' {

    Context 'Check Files Exist' {
        It 'DashboardSettings.json exists' {
            (Test-Path -Path ((Split-Path ($PSScriptRoot).ToString()) + '\DashboardSettings.json') | Should Be $true)
        }
    }
}