Describe "Testing JumpCloud Onboarding Dashboard" {
    BeforeAll {
        Start-JCDashboard -JumpCloudAPIKey $TestOrgAPIKey -NoUpdate
        $Driver = Start-SeFirefox -Headless
        Enter-SeUrl "http://127.0.0.1:8003/Onboarding" -Driver $Driver
        # wait for large orgs
        $TotalUsers = Get-JCUser -returnProperties username | Measure-Object | Select-Object -ExpandProperty Count
        if ($TotalUsers -gt 1000) {
            Start-Sleep -s 30
        }
    }
    Context "Verifying Onboarding Dashboard Components" {

        It "Verifies the user activation status component" {
            $Element = Find-SeElement -Driver $Driver -TagName "useractivationstatus"
            $Element.Displayed | Should Be $true
        }

        It "Verifies the system user associations component" {
            $Element = Find-SeElement -Driver $Driver -TagName "systemuserassociations"
            $Element.Displayed | Should Be $true
        }

        AfterAll {
            Stop-SeDriver $Driver
            Get-UDDashboard | Stop-UDDashboard
        }
    }
}