Describe "Testing GridView" {
    BeforeAll {
        Get-UDDashboard | Stop-UDDashboard
        Start-JCDashboard -JumpCloudAPIKey $TestOrgAPIKey -Layout gridView -IncludeComponent system_agentVersion,system_lastContact,system_mfaStatus,system_newSystems,system_os,system_version,user_mfaStatus,user_newUsers,user_passwordChanges,user_passwordExpirations,user_privilegedUsers,user_userStates -NoUpdate
        $Driver = Start-SeFirefox -Headless
        Enter-SeUrl "http://127.0.0.1:8003/Custom" -Driver $Driver
    }

    Context "Verifying System Dashboard Components" {
        It "Verifies the OS component" {
            $Element = Find-SeElement -Driver $Driver -TagName "system_os"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the SystemsMFA component" {
            $Element = Find-SeElement -Driver $Driver -TagName "system_mfaStatus"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the NewSystems component" {
            $Element = Find-SeElement -Driver $Driver -TagName "system_newSystems"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the AgentVersion component" {
            $Element = Find-SeElement -Driver $Driver -TagName "system_agentVersion"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the OSVersion component" {
            $Element = Find-SeElement -Driver $Driver -TagName "system_version"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the LastContact component" {
            $Element = Find-SeElement -Driver $Driver -TagName "system_lastContact"
            $Element.Displayed | Should Be $true
        }

        Context "Verifying SystemUsers Dashboard Components" {
            It "Verifies the NewUsers component" {
                $Element = Find-SeElement -Driver $Driver -TagName "user_newUsers"
                $Element.Displayed | Should Be $true
            }
            It "Verifies the UserState component" {
                $Element = Find-SeElement -Driver $Driver -TagName "user_userStates"
                $Element.Displayed | Should Be $true
            }
            It "Verifies the PrivilegedUsers component" {
                $Element = Find-SeElement -Driver $Driver -TagName "user_privilegedUsers"
                $Element.Displayed | Should Be $true
            }
            It "Verifies the UsersMFA component" {
                $Element = Find-SeElement -Driver $Driver -TagName "user_mfaStatus"
                $Element.Displayed | Should Be $true
            }
            It "Verifies the PasswordExpiration component" {
                $Element = Find-SeElement -Driver $Driver -TagName "user_passwordExpirations"
                $Element.Displayed | Should Be $true
            }
            It "Verifies the PasswordChanges component" {
                $Element = Find-SeElement -Driver $Driver -TagName "user_passwordChanges"
                $Element.Displayed | Should Be $true
            }
    }
    AfterAll {
        Stop-SeDriver $Driver
        Get-UDDashboard | Stop-UDDashboard
    }
}