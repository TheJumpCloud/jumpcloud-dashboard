Describe 'Build Tests' {
    BeforeAll {
        Get-UDDashboard | Stop-UDDashboard
        Start-JCDashboard -JumpCloudAPIKey $TestOrgAPIKey -NoUpdate
        $Driver = Start-SeFirefox -Headless
        $waitTime = 300
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
    Context "Verifying SystemUsers Dashboard Components" {
        Enter-SeUrl "http://127.0.0.1:8003/SystemUsers" -Driver $Driver
        It "Verifies the NewUsers component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "user_newUsers"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the UserState component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "user_userStates"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the PrivilegedUsers component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "user_privilegedUsers"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the UsersMFA component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "user_mfaStatus"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the PasswordExpiration component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "user_passwordExpirations"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the PasswordChanges component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "user_passwordChanges"
            $Element.Displayed | Should Be $true
        }
    }
    Context "Verifying System Dashboard Components" {
        Enter-SeUrl "http://127.0.0.1:8003/Systems" -Driver $Driver
        It "Verifies the OS component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "system_os"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the SystemsMFA component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "system_mfaStatus"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the NewSystems component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "system_newSystems"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the AgentVersion component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "system_agentVersion"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the OSVersion component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "system_version"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the LastContact component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "system_lastContact"
            $Element.Displayed | Should Be $true
        }
    }
    Context "Verifying associations Dashboard Components" {
        Enter-SeUrl "http://127.0.0.1:8003/associations" -Driver $Driver
        It "Verifies the gsuite component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "associations_gsuite"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the ldap component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "associations_ldap"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the office365 component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "associations_o365"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the radius component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "associations_radius"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the systemuserassociation component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "associations_syspolicy"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the userState component" {
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "associations_useractivationstatus"
            $Element.Displayed | Should Be $true
        }
    }
    AfterAll {
        Stop-SeDriver $Driver
        Get-UDDashboard | Stop-UDDashboard
    }
}