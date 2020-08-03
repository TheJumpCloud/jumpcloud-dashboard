BeforeAll {
    Get-UDDashboard | Stop-UDDashboard
    # $components = @("system_agentVersion", "system_lastContact", "system_newSystems")
    $components = @("system_agentVersion",
                    "system_lastContact",
                    "system_mfaStatus",
                    "system_newSystems",
                    "system_os",
                    "system_version",
                    "user_mfaStatus",
                    "user_newUsers",
                    "user_passwordChanges",
                    "user_passwordExpirations",
                    "user_privilegedUsers",
                    "user_userStates",
                    "associations_gsuite",
                    "associations_ldap",
                    "associations_o365",
                    "associations_radius",
                    "associations_syspolicy",
                    "associations_useractivationstatus",
                    "directoryinsights_dailyAdminConsoleLoginAttempts",
                    "directoryinsights_dailyUserPortalLoginAttempts",
                    "directoryinsights_systemCreateDelete",
                    "directoryinsights_systemGroupChanges",
                    "directoryinsights_userCreateDelete",
                    "directoryinsights_userGroupChanges"
    )
    $testDashboard = Start-JCDashboard -JumpCloudAPIKey $TestOrgAPIKey -NoUpdate -Layout singleComponent -IncludeComponent $components -cycleInterval 60
    $Driver = Start-SeFirefox -Headless
    Start-Sleep -s 20
    Enter-SeUrl "http://127.0.0.1:8003/" -Driver $Driver
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
                tag            = @(
                    "system_agentVersion",
                    "system_lastContact",
                    "system_mfaStatus",
                    "system_newSystems",
                    "system_os",
                    "system_version",
                    "user_mfaStatus",
                    "user_newUsers",
                    "user_passwordChanges",
                    "user_passwordExpirations",
                    "user_privilegedUsers",
                    "user_userStates",
                    "associations_gsuite",
                    "associations_ldap",
                    "associations_o365",
                    "associations_radius",
                    "associations_syspolicy",
                    "associations_useractivationstatus",
                    "directoryinsights_dailyAdminConsoleLoginAttempts",
                    "directoryinsights_dailyUserPortalLoginAttempts",
                    "directoryinsights_systemCreateDelete",
                    "directoryinsights_systemGroupChanges",
                    "directoryinsights_userCreateDelete",
                    "directoryinsights_userGroupChanges"
                )
            }
        ) {
            forEach ($item in $tag) {
                write-host("Testing: " + $item)
                Enter-SeUrl "http://127.0.0.1:8003/$($item)" -Driver $Driver
                $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName $item
                $Element.Displayed | Should -Be $true
            }
        }
    }
    AfterAll {
        Stop-SeDriver $Driver
        Get-UDDashboard | Stop-UDDashboard
    }
}