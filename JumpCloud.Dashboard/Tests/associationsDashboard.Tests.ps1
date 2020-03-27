Describe "Testing JumpCloud associations Dashboard" {
    BeforeAll {
        Start-JCDashboard -JumpCloudAPIKey $TestOrgAPIKey -NoUpdate
        $Driver = Start-SeFirefox -Headless
        Enter-SeUrl "http://127.0.0.1:8003/associations" -Driver $Driver
        # wait for large orgs
        $TotalUsers = Get-JCUser -returnProperties username | Measure-Object | Select-Object -ExpandProperty Count
        if ($TotalUsers -gt 1000) {
            Start-Sleep -s 30
        }
    }
    Context "Verifying associations Dashboard Components" {
        It "Verifies the gsuite component" {
            $Element = Find-SeElement -Driver $Driver -TagName "associations_gsuite"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the ldap component" {
            $Element = Find-SeElement -Driver $Driver -TagName "associations_ldap"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the office365 component" {
            $Element = Find-SeElement -Driver $Driver -TagName "associations_o365"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the radius component" {
            $Element = Find-SeElement -Driver $Driver -TagName "associations_radius"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the systemuserassociation component" {
            $Element = Find-SeElement -Driver $Driver -TagName "associations_systemuserassociations"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the userState component" {
            $Element = Find-SeElement -Driver $Driver -TagName "associations_useractivationstatus"
            $Element.Displayed | Should Be $true
        }
    }
    AfterAll {
        Stop-SeDriver $Driver
        Get-UDDashboard | Stop-UDDashboard
    }
}