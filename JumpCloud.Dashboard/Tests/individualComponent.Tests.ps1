BeforeAll {
    Get-UDDashboard | Stop-UDDashboard
}
Describe 'Individual Components Tests' {
    function Get-myUDPages {
        $componenets = @(
            "system_agentVersion",
            "system_lastContact",
            "system_newSystems",
            "system_os",
            "system_version",
            "system_mfaStatus",
            "user_mfaStatus",
            "user_newUsers",
            "user_passwordChanges",
            "user_passwordExpirations",
            "user_privilegedUsers",
            "user_userStates",
            "associations_o365",
            "associations_gsuite",
            "associations_ldap",
            "associations_radius",
            "associations_useractivationstatus",
            "associations_syspolicy",
            "directoryinsights_systemCreateDelete",
            "directoryinsights_userCreateDelete",
            "directoryinsights_dailyUserPortalLoginAttempts",
            "directoryinsights_userGroupChanges",
            "directoryinsights_systemGroupChanges",
            "directoryinsights_dailyAdminConsoleLoginAttempts"
        )
        $testDashboard = Start-JCDashboard -JumpCloudAPIKey $TestOrgAPIKey -NoUpdate -Layout singleComponent -IncludeComponent $componenets -cycleInterval 5
        $Driver = Start-SeFirefox -Headless
        Enter-SeUrl "http://127.0.0.1:8003/" -Driver $Driver
        $waitTime = 300
        $Pages = $testDashboard.DashboardService.Dashboard.Pages.Name
        $PageTestCases = @()
        foreach ($Page in $Pages) {
            $PageTestCases += @{
                testDescription = "Individual Component: $Page"
                tag             = $Page
                Element         = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName $Page
            }
        }
        Return $PageTestCases
    }
    It '<testDescription>' -TestCases:(Get-myUDPages) {
        write-host("Testing: " + $tag)
        While ($Element.Displayed -eq $false) {
            $Element.Displayed | Should -Be $true
        }
    }
    AfterAll {
        # Get-SEDriver | Stop-SeDriver
        Get-UDDashboard | Stop-UDDashboard
    }
}