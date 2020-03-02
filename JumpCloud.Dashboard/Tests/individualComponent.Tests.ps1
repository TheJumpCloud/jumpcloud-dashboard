$JumpCloudAPIKEY = ""
Import-Module ../JumpCloud.Dashboard.psd1
$testDashboard = Start-JCDashboard -JumpCloudAPIKey $JumpCloudAPIKEY -NoUpdate -Layout singleComponent -IncludeComponent "AgentVersion", "LastContact", "NewSystems", "OS", "OSVersion", "SystemsMFA", "UsersMFA", "NewUsers", "PasswordChanges", "PasswordExpiration", "PrivilegedUsers", "UserState" -cycleInterval 5
Describe "Testing JumpCloud Systems Dashboard" {
    BeforeAll {

        # Run setupDashboardt.ps1
        # REQUIRED: Firefox must be installed

        $Driver = Start-SeFirefox -Headless
        Enter-SeUrl "http://127.0.0.1:8003/" -Driver $Driver
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
            # $Element = Find-SeElement -Driver $Driver -TagName "OS"
            # $Element.Displayed | Should Be $true
        }
        For ($i = 0; $i -lt $expected.Count; $i++) {
            $testname = $expected[$i].Name
            It "Verify the individualComponent: $testname is displayed" {
                For ($t = 0; $t -lt $timeout; $t++) {
                    $Element = Find-SeElement -Driver $Driver -TagName $expected[$i].Name
                    If ($Element -ne $null) {
                        $Capture = $Element
                        break
                    }
                }
                # $Element = Find-SeElement -Driver $Driver -TagName $expected[$i].Name
                $Capture.Displayed | Should Be $true
            }
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
        Stop-UDDashboard -port 8003
    }
}