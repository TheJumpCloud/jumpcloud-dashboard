
Describe "Testing JumpCloud Users Dashboard" {
    BeforeAll {
        Start-JCDashboard -JumpCloudAPIKey $TestOrgAPIKey -NoUpdate
        $Driver = Start-SeFirefox -Headless
        Enter-SeUrl "http://127.0.0.1:8003/SystemUsers" -Driver $Driver
        # wait for large orgs
        $TotalUsers = Get-JCUser -returnProperties username | Measure-Object | Select-Object -ExpandProperty Count
        if ($TotalUsers -gt 1000) {
            Start-Sleep -s 30
        }
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

        AfterAll {
            Stop-SeDriver $Driver
            Get-UDDashboard | Stop-UDDashboard
        }
    }
}
