
Describe "Testing JumpCloud Users Dashboard" {
    BeforeAll {
        Get-UDDashboard | Stop-UDDashboard
        Start-JCDashboard -JumpCloudAPIKey $TestOrgAPIKey -NoUpdate
        $Driver = Start-SeFirefox -Headless
        Enter-SeUrl "http://127.0.0.1:8003/SystemUsers" -Driver $Driver
    }
   Context "Verifying SystemUsers Dashboard Components" {

        It "Verifies the NewUsers component" {
            $Element = Find-SeElement -Driver $Driver -TagName "NewUsers"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the UserState component" {
            $Element = Find-SeElement -Driver $Driver -TagName "UserState"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the PrivilegedUsers component" {
            $Element = Find-SeElement -Driver $Driver -TagName "PrivilegedUsers"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the MFAConfigured component" {
            $Element = Find-SeElement -Driver $Driver -TagName "UsersMFA"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the PasswordExpiration component" {
            $Element = Find-SeElement -Driver $Driver -TagName "PasswordExpiration"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the PasswordChanges component" {
            $Element = Find-SeElement -Driver $Driver -TagName "PasswordChanges"
            $Element.Displayed | Should Be $true
        }

        AfterAll {
            Stop-SeDriver $Driver
            Get-UDDashboard | Stop-UDDashboard
        }
    }
}
