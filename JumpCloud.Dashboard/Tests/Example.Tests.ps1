Describe 'Build Tests' {

    Context 'Check Files Exist' {
        It 'DashboardSettings.json exists' {
            (Test-Path -Path ((Split-Path ($PSScriptRoot).ToString()) + '\DashboardSettings.json') | Should Be $true)
        }

        $that = Start-JCDashboard
        It "Launched Web Server" {
            $that.Running | Should Be $true
        }
    }
}