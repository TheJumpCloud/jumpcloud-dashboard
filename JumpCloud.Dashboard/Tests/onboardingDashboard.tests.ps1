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
        It "Verifies the gsuite component" {
            $Element = Find-SeElement -Driver $Driver -TagName "onboarding_gsuite"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the ldap component" {
            $Element = Find-SeElement -Driver $Driver -TagName "onboarding_ldap"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the office365 component" {
            $Element = Find-SeElement -Driver $Driver -TagName "onboarding_o365"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the radius component" {
            $Element = Find-SeElement -Driver $Driver -TagName "onboarding_radius"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the systemuserassociation component" {
            $Element = Find-SeElement -Driver $Driver -TagName "onboarding_systemuserassociations"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the userState component" {
            $Element = Find-SeElement -Driver $Driver -TagName "onboarding_useractivationstatus"
            $Element.Displayed | Should Be $true
        }
    }
    AfterAll {
        Stop-SeDriver $Driver
        Get-UDDashboard | Stop-UDDashboard
    }
}