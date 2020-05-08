Describe 'Build Tests' {
    BeforeAll {
        Get-UDDashboard | Stop-UDDashboard
        Start-JCDashboard -JumpCloudAPIKey $TestOrgAPIKey -NoUpdate
        $Driver = Start-SeFirefox -Headless
        $waitTime = 45

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
            waitForElement 'user_newUsers' $waitTime -byName
            $Element = Find-SeElement -Driver $Driver -TagName "user_newUsers"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the UserState component" {
            waitForElement 'user_userStates' $waitTime -byName
            $Element = Find-SeElement -Driver $Driver -TagName "user_userStates"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the PrivilegedUsers component" {
            waitForElement 'user_privilegedUsers' $waitTime -byName
            $Element = Find-SeElement -Driver $Driver -TagName "user_privilegedUsers"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the UsersMFA component" {
            waitForElement 'user_mfaStatus' $waitTime -byName
            $Element = Find-SeElement -Driver $Driver -TagName "user_mfaStatus"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the PasswordExpiration component" {
            waitForElement 'user_passwordExpirations' $waitTime -byName
            $Element = Find-SeElement -Driver $Driver -TagName "user_passwordExpirations"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the PasswordChanges component" {
            waitForElement 'user_passwordChanges' $waitTime -byName
            $Element = Find-SeElement -Driver $Driver -TagName "user_passwordChanges"
            $Element.Displayed | Should Be $true
        }
    }
    Context "Verifying System Dashboard Components" {
        Enter-SeUrl "http://127.0.0.1:8003/Systems" -Driver $Driver
        It "Verifies the OS component" {
            waitForElement 'system_os' $waitTime -byName
            $Element = Find-SeElement -Driver $Driver -TagName "system_os"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the SystemsMFA component" {
            waitForElement 'system_mfaStatus' $waitTime -byName
            $Element = Find-SeElement -Driver $Driver -TagName "system_mfaStatus"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the NewSystems component" {
            waitForElement 'system_newSystems' $waitTime -byName
            $Element = Find-SeElement -Driver $Driver -TagName "system_newSystems"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the AgentVersion component" {
            waitForElement 'system_agentVersion' $waitTime -byName
            $Element = Find-SeElement -Driver $Driver -TagName "system_agentVersion"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the OSVersion component" {
            waitForElement 'system_version' $waitTime -byName
            $Element = Find-SeElement -Driver $Driver -TagName "system_version"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the LastContact component" {
            waitForElement 'system_lastContact' $waitTime -byName
            $Element = Find-SeElement -Driver $Driver -TagName "system_lastContact"
            $Element.Displayed | Should Be $true
        }
    }
    Context "Verifying associations Dashboard Components" {
        Enter-SeUrl "http://127.0.0.1:8003/associations" -Driver $Driver
        It "Verifies the gsuite component" {
            waitForElement 'associations_gsuite' $waitTime -byName
            $Element = Find-SeElement -Driver $Driver -TagName "associations_gsuite"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the ldap component" {
            waitForElement 'associations_ldap' $waitTime -byName
            $Element = Find-SeElement -Driver $Driver -TagName "associations_ldap"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the office365 component" {
            waitForElement 'associations_o365' $waitTime -byName
            $Element = Find-SeElement -Driver $Driver -TagName "associations_o365"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the radius component" {
            waitForElement 'associations_radius' $waitTime -byName
            $Element = Find-SeElement -Driver $Driver -TagName "associations_radius"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the systemuserassociation component" {
            waitForElement 'associations_syspolicy' $waitTime -byName
            $Element = Find-SeElement -Driver $Driver -TagName "associations_syspolicy"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the userState component" {
            waitForElement 'associations_useractivationstatus' $waitTime -byName
            $Element = Find-SeElement -Driver $Driver -TagName "associations_useractivationstatus"
            $Element.Displayed | Should Be $true
        }
    }
    AfterAll {
        Stop-SeDriver $Driver
        Get-UDDashboard | Stop-UDDashboard
    }
}