BeforeAll {
    Get-UDDashboard | Stop-UDDashboard
    # $components = @("system_agentVersion")
    $components = @("system_agentVersion", "system_lastContact", "system_newSystems", "system_os", "system_version", "system_mfaStatus", "user_mfaStatus", "user_newUsers", "user_passwordChanges", "user_passwordExpirations", "user_privilegedUsers", "user_userStates", "associations_gsuite", "associations_ldap", "associations_o365", "associations_radius", "associations_syspolicy", "associations_useractivationstatus", "directoryinsights_userCreateDelete", "directoryinsights_systemCreateDelete", "directoryinsights_dailyUserPortalLoginAttempts", "directoryinsights_userGroupChanges", "directoryinsights_systemGroupChanges", "directoryinsights_dailyAdminConsoleLoginAttempts")
    $testDashboard = Start-JCDashboard -JumpCloudAPIKey $TestOrgAPIKey -NoUpdate -Layout singleComponent -IncludeComponent $components -cycleInterval 100
    $Driver = Start-SeChrome -Headless
    Enter-SeUrl "http://127.0.0.1:8003/" -Driver $Driver
    # Start-Sleep -s 20
    $waitTime = 600
}
Describe "Testing JumpCloud Individual Component Dashboard" {
    Context "Verify Dashboard is running" {
        It "Test that the dashboard is actually running" {
            $testDashboard.Running | Should -Be $true
        }
    }
    Context 'Test individal Pages' {
        It '<testDescription>' -TestCases @(
            @{ testDescription = 'all other cases'
                tag            = @("system_agentVersion", "system_lastContact", "system_newSystems", "system_os", "system_version", "system_mfaStatus", "user_mfaStatus", "user_newUsers", "user_passwordChanges", "user_passwordExpirations", "user_privilegedUsers", "user_userStates", "associations_gsuite", "associations_ldap", "associations_o365", "associations_radius", "associations_syspolicy", "associations_useractivationstatus", "directoryinsights_userCreateDelete", "directoryinsights_systemCreateDelete", "directoryinsights_dailyUserPortalLoginAttempts", "directoryinsights_userGroupChanges", "directoryinsights_systemGroupChanges", "directoryinsights_dailyAdminConsoleLoginAttempts")
            }
        ) {
            forEach ($item in $tag) {
                write-host("Testing: " + $item)
                Enter-SeURL -URL "http://127.0.0.1:8003/$($item)" -Driver $Driver
                $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName $item
                While ($Element.Displayed -eq $false) {
                    Start-Sleep -s 1
                }
                $Element.Displayed | Should -Be $true
            }
        }
    }
    AfterAll {
        Stop-SeDriver $Driver
        Get-UDDashboard | Stop-UDDashboard
    }
}