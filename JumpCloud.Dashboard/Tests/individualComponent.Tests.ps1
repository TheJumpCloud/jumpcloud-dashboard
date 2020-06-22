BeforeAll {
    Get-UDDashboard | Stop-UDDashboard
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
    $testDashboard = Start-JCDashboard -JumpCloudAPIKey $TestOrgAPIKey -NoUpdate -Layout singleComponent -IncludeComponent $componenets -cycleInterval 3
    $Driver = Start-SeFirefox -Headless
    Enter-SeUrl "http://127.0.0.1:8003/" -Driver $Driver
    # Start-Sleep -s 20
    $waitTime = 300
}
Describe "Testing JumpCloud Individual Component Dashboard" {
    function Get-Components() {
        $components = @("system_agentVersion", "system_lastContact", "system_newSystems", "system_os", "system_version", "system_mfaStatus", "user_mfaStatus", "user_newUsers", "user_passwordChanges", "user_passwordExpirations", "user_privilegedUsers", "user_userStates", "associations_gsuite", "associations_ldap", "associations_o365", "associations_radius", "associations_syspolicy", "associations_useractivationstatus", "directoryinsights_userCreateDelete", "directoryinsights_systemCreateDelete", "directoryinsights_dailyUserPortalLoginAttempts", "directoryinsights_userGroupChanges", "directoryinsights_systemGroupChanges", "directoryinsights_dailyAdminConsoleLoginAttempts")
        return $components
    }
    BeforeAll {
        Get-UDDashboard | Stop-UDDashboard
        # $components = @("system_agentVersion", "system_lastContact", "system_newSystems")
        $components = Get-Components
        $testDashboard = Start-JCDashboard -JumpCloudAPIKey $TestOrgAPIKey -NoUpdate -Layout singleComponent -IncludeComponent $components -cycleInterval 1
        $Driver = Start-SeFirefox -Headless
        Enter-SeUrl "http://127.0.0.1:8003/" -Driver $Driver
        # Start-Sleep -s 20
        $waitTime = 300
    }
    Context "Verify Dashboard is running" {
        It "Test that the dashboard is actually running" {
            $testDashboard.Running | Should -Be $true
        }
    }
    Context 'Test individal Pages' {
        It '<testDescription>' -TestCases @(
            @{ testDescription = 'Test that all the components are loaded'
                tag            = @(
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
            }
        ) {
            forEach ($item in $tag) {
                # write-host("Testing: " + $item)
                $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName $item
                While ($Element.Displayed -eq $false) {
                    $Element.Displayed | Should -Be $true
                }
            }
        }
    }
    AfterAll {
        Stop-SeDriver $Driver
        Get-UDDashboard | Stop-UDDashboard
    }
}