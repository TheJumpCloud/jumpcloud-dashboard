BeforeAll {
    Get-UDDashboard | Stop-UDDashboard
    Start-JCDashboard -JumpCloudAPIKey $TestOrgAPIKey -NoUpdate
    Start-Sleep -s 60
    $Driver = Start-SeFirefox -Headless -Verbose
    $waitTime = 300
    $ModuleRootPath = (Get-Item -Path($PSScriptRoot)).Parent.FullName
}
Describe 'Build Tests' {
    Context 'Check Files Exist' {
        It 'README.md exists' {
            (Test-Path -Path:($ModuleRootPath + '/README.md') | Should -Be $true)
        }
        It 'DashboardSettings.json exists' {
            (Test-Path -Path:($ModuleRootPath + '/Public/DashboardSettings.json') | Should -Be $true)
        }
        It 'Start-JCDashboard.ps1 exists' {
            (Test-Path -Path:($ModuleRootPath + '/Public/Start-JCDashboard.ps1') | Should -Be $true)
        }
    }
    Context "Verifying SystemUsers Dashboard Components" {
        BeforeEach{
            Enter-SeUrl "http://127.0.0.1:8003/SystemUsers" -Driver $Driver
        }
        It "Verifies the NewUsers component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "user_newUsers"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the UserState component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "user_userStates"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the PrivilegedUsers component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "user_privilegedUsers"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the UsersMFA component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "user_mfaStatus"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the PasswordExpiration component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "user_passwordExpirations"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the PasswordChanges component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "user_passwordChanges"
            $Element.Displayed | Should -Be $true
        }
    }
    Context "Verifying System Dashboard Components" {
        BeforeEach{
            Enter-SeUrl "http://127.0.0.1:8003/Systems" -Driver $Driver
        }
        It "Verifies the OS component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "system_os"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the SystemsMFA component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "system_mfaStatus"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the NewSystems component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "system_newSystems"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the AgentVersion component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "system_agentVersion"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the OSVersion component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "system_version"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the LastContact component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "system_lastContact"
            $Element.Displayed | Should -Be $true
        }
    }
    Context "Verifying associations Dashboard Components" {
        BeforeEach{
            Enter-SeUrl "http://127.0.0.1:8003/associations" -Driver $Driver
        }
        It "Verifies the gsuite component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "associations_gsuite"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the ldap component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "associations_ldap"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the office365 component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "associations_o365"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the radius component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "associations_radius"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the systemuserassociation component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "associations_syspolicy"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the userState component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "associations_useractivationstatus"
            $Element.Displayed | Should -Be $true
        }
    }
    Context "Verifying Directory Insights Dashboard Components" {
        BeforeEach{
            Enter-SeUrl "http://127.0.0.1:8003/DirectoryInsights" -Driver $Driver
        }
        It "Verifies the user create / delete component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "directoryinsights_userCreateDelete"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the system create / delete component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "directoryinsights_systemCreateDelete"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the daily user portal auth component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "directoryinsights_dailyUserPortalLoginAttempts"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the user group changes component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "directoryinsights_userGroupChanges"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the system group changes component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "directoryinsights_systemGroupChanges"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the daily admin portal auth component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "directoryinsights_dailyAdminConsoleLoginAttempts"
            $Element.Displayed | Should -Be $true
        }
    }
    AfterAll {
        Stop-SeDriver $Driver
        Get-UDDashboard | Stop-UDDashboard
    }
}