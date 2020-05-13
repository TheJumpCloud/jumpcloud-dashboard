Describe "Testing JumpCloud Individual Component Dashboard" {
    BeforeAll {
        Get-UDDashboard | Stop-UDDashboard
        $testDashboard = Start-JCDashboard -JumpCloudAPIKey $TestOrgAPIKey -NoUpdate -Layout singleComponent -IncludeComponent "system_agentVersion", "system_lastContact", "system_newSystems", "system_os", "system_version", "system_mfaStatus", "user_mfaStatus", "user_newUsers", "user_passwordChanges", "user_passwordExpirations", "user_privilegedUsers", "user_userStates", "associations_gsuite", "associations_ldap", "associations_o365", "associations_radius", "associations_syspolicy", "associations_useractivationstatus"-cycleInterval 5
        $Driver = Start-SeFirefox -Headless
        Enter-SeUrl "http://127.0.0.1:8003/" -Driver $Driver
        $waitTime = 300
    }
    Context "Verify Dashboard is running" {
        It "Test that the dashboard is actually running" {
            # variable from setupDashboard.ps1
            $testDashboard.Running | Should Be $true
        }
    }
    Context "Tests of individual components" {
        $timeout = $testDashboard.DashboardService.Dashboard.CyclePagesInterval
        $timeout = $timeout * 2
        $pagename = @()
        $expected = $testDashboard.DashboardService.Dashboard.Pages
        For ($i=0; $i -lt $expected.Count; $i++){
            $pagename += $expected[$i].Name
        }
        It "Verifies the requested pages exist in the dashboard object" {
            For ($i = 0; $i -lt $expected.Count; $i++) {
                $expected[$i].Name | Should Be $pagename[$i]
            }
        }
        For ($i = 0; $i -lt $expected.Count; $i++) {
            $testname = $expected[$i].Name
            It "Verify the individualComponent: $testname is displayed" {
                For ($t = 0; $t -lt $timeout; $t++) {
                    $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName $expected[$i].Name
                    If ($Element -ne $null) {
                        $Capture = $Element
                        break
                    }
                }
                # $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName $expected[$i].Name
                $Capture.Displayed | Should Be $true
            }
        }
    }
    #TODO:add mock or attach to org returning no results
    Context "Testing the cases where no systems are to be displayed" {
        # It "No MFA Systems"{
        #     $MFASystems = Get-SystemsWithLastContactWithinXDays -days 7
        #     If ($MFASystems.Length -eq 0) {
        #         $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "SystemsMFA"
        #         $Element.Text | Should BeLike "*None of your systems have MFA enabled."
        #     }
        # }
        # It "No New Systems" {
        #     $MFASystems = Get-SystemsWithLastContactWithinXDays -days 7
        #     If ($MFASystems.Length -eq 0) {
        #         $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "NewSystems"
        #         $Element.Text | Should BeLike "*No new systems have been added to your JumpCloud Organization*"
        #     }
        # }
    }
    AfterAll {
        Stop-SeDriver $Driver
        Get-UDDashboard | Stop-UDDashboard
    }
}