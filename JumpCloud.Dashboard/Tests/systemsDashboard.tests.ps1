Describe "Testing JumpCloud Systems Dashboard" {
    BeforeAll {
        $Driver = Start-SeFirefox -Headless
        Enter-SeUrl "http://127.0.0.1:8003/Systems" -Driver $Driver
    }
    Context "Verifying System Dashboard Components" {

        It "Verifies the OS component" {
            $Element = Find-SeElement -Driver $Driver -TagName "OS"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the SystemsMFA component" {
            $Element = Find-SeElement -Driver $Driver -TagName "SystemsMFA"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the NewSystems component" {
            $Element = Find-SeElement -Driver $Driver -TagName "NewSystems"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the AgentVersion component" {
            $Element = Find-SeElement -Driver $Driver -TagName "AgentVersion"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the OSVersion component" {
            $Element = Find-SeElement -Driver $Driver -TagName "OSVersion"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the LastContact component" {
            $Element = Find-SeElement -Driver $Driver -TagName "LastContact"
            $Element.Displayed | Should Be $true
        }

    }
    #TODO:add mock or attach to org returning no results
    Context "Testing the cases where no systems are to be displayed" {
        # It "No MFA Systems"{
        #     $MFASystems = Get-SystemsWithLastContactWithinXDays -days 7
        #     If ($MFASystems.Length -eq 0) {
        #         $Element = Find-SeElement -Driver $Driver -TagName "SystemsMFA"
        #         $Element.Text | Should BeLike "*None of your systems have MFA enabled."
        #     }
        # }
        # It "No New Systems" {
        #     $MFASystems = Get-SystemsWithLastContactWithinXDays -days 7
        #     If ($MFASystems.Length -eq 0) {
        #         $Element = Find-SeElement -Driver $Driver -TagName "NewSystems"
        #         $Element.Text | Should BeLike "*No new systems have been added to your JumpCloud Organization*"
        #     }
        # }
    }
    AfterAll {
        Stop-SeDriver $Driver
    }
}