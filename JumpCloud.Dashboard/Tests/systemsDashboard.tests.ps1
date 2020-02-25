

Describe "Testing JumpCloud Systems Dashboard" {
    BeforeAll {

        # Run setupDashboardt.ps1
        # REQUIRED: Firefox must be installed

        $Driver = Start-SeChrome -Headless
        Enter-SeUrl "http://127.0.0.1:8003/Systems" -Driver $Driver
    }
    Context "Verifying System Dashboard Components" {

        It "Verifies the OS component" {
            $Element = Find-SeElement -Driver $Driver -TagName "OS"
            $Element.Displayed | Should -Be $true
        }
        $Element = Find-SeElement -Driver $Driver -TagName "SystemsMFA"
        $Element.Displayed | Should -Be $true
    }
    It "Verifies the NewSystems component" {
        $Element = Find-SeElement -Driver $Driver -TagName "NewSystems"
        $Element.Displayed | Should -Be $true
    }
    It "Verifies the AgentVersion component" {
        $Element = Find-SeElement -Driver $Driver -TagName "AgentVersion"
        $Element.Displayed | Should -Be $true
    }
    It "Verifies the OSVersion component" {
        $Element = Find-SeElement -Driver $Driver -TagName "OSVersion"
        $Element.Displayed | Should -Be $true
    }
    It "Verifies the LastContact component" {
        $Element = Find-SeElement -Driver $Driver -TagName "LastContact"
        $Element.Displayed | Should -Be $true
    }

    AfterAll {
        Stop-SeDriver $Driver
    }
}