Describe "Testing GridView" {
    BeforeAll {
        Get-UDDashboard | Stop-UDDashboard
        Start-JCDashboard -JumpCloudAPIKey $TestOrgAPIKey -Layout gridView -IncludeComponent system_agentVersion,system_lastContact,system_mfaStatus,system_newSystems,system_os,system_version,user_mfaStatus,user_newUsers,user_passwordChanges,user_passwordExpirations,user_privilegedUsers,user_userStates,associations_gsuite,associations_ldap,associations_o365,associations_radius,associations_syspolicy,associations_useractivationstatus,directoryinsights_userCreateDelete,directoryinsights_systemCreateDelete,directoryinsights_dailyUserPortalLoginAttempts,directoryinsights_userGroupChanges,directoryinsights_systemGroupChanges,directoryinsights_dailyAdminConsoleLoginAttempts -NoUpdate
        Start-Sleep -s 60
        $Driver = Start-SeFirefox -Headless
        $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromSeconds(10)
        $Driver.Manage().Timeouts().Pageload = [TimeSpan]::FromMinutes(3)
        Enter-SeUrl "http://127.0.0.1:8003/Custom" -Driver $Driver
        $waitTime = 600
    }
    Context "Verifying System Dashboard Components" {
        It "Verifies the OS component" {
            Write-Host("Testing: " + "system_os")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "system_os"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the SystemsMFA component" {
            Write-Host("Testing: " + "system_mfaStatus")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "system_mfaStatus"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the NewSystems component" {
            Write-Host("Testing: " + "system_newSystems")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "system_newSystems"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the AgentVersion component" {
            Write-Host("Testing: " + "system_agentVersion")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "system_agentVersion"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the OSVersion component" {
            Write-Host("Testing: " + "system_version")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "system_version"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the LastContact component" {
            Write-Host("Testing: " + "system_lastContact")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "system_lastContact"
            $Element.Displayed | Should -Be $true
        }
    }
    Context "Verifying SystemUsers Dashboard Components" {
        It "Verifies the NewUsers component" {
            Write-Host("Testing: " + "user_newUsers")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "user_newUsers"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the UserState component" {
            Write-Host("Testing: " + "user_userStates")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "user_userStates"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the PrivilegedUsers component" {
            Write-Host("Testing: " + "user_privilegedUsers")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "user_privilegedUsers"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the UsersMFA component" {
            Write-Host("Testing: " + "user_mfaStatus")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "user_mfaStatus"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the PasswordExpiration component" {
            Write-Host("Testing: " + "user_passwordExpirations")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "user_passwordExpirations"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the PasswordChanges component" {
            Write-Host("Testing: " + "user_passwordChanges")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "user_passwordChanges"
            $Element.Displayed | Should -Be $true
        }
    }
    Context "Verifying associations Dashboard Components" {
        It "Verifies the gsuite component" {
            Write-Host("Testing: " + "associations_gsuite")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "associations_gsuite"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the ldap component" {
            Write-Host("Testing: " + "associations_ldap")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "associations_ldap"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the office365 component" {
            Write-Host("Testing: " + "associations_o365")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "associations_o365"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the radius component" {
            Write-Host("Testing: " + "associations_radius")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "associations_radius"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the systemuserassociation component" {
            Write-Host("Testing: " + "associations_syspolicy")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "associations_syspolicy"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the userState component" {
            Write-Host("Testing: " + "associations_useractivationstatus")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "associations_useractivationstatus"
            $Element.Displayed | Should -Be $true
        }
    }
    Context "Verifying Directory Insights Dashboard Components" {
        It "Verifies the user create / delete component" {
            Write-Host("Testing: " + "directoryinsights_userCreateDelete")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "directoryinsights_userCreateDelete"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the system create / delete component" {
            Write-Host("Testing: " + "directoryinsights_systemCreateDelete")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "directoryinsights_systemCreateDelete"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the daily user portal auth component" {
            Write-Host("Testing: " + "directoryinsights_dailyUserPortalLoginAttempts")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "directoryinsights_dailyUserPortalLoginAttempts"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the user group changes component" {
            Write-Host("Testing: " + "directoryinsights_userGroupChanges")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "directoryinsights_userGroupChanges"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the system group changes component" {
            Write-Host("Testing: " + "directoryinsights_systemGroupChanges")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "directoryinsights_systemGroupChanges"
            $Element.Displayed | Should -Be $true
        }
        It "Verifies the daily admin portal auth component" {
            Write-Host("Testing: " + "directoryinsights_dailyAdminConsoleLoginAttempts")
            $Element = Find-SeElement -Driver $Driver -Wait -Timeout $waitTime -TagName "directoryinsights_dailyAdminConsoleLoginAttempts"
            $Element.Displayed | Should -Be $true
        }
    }
    AfterAll {
        Stop-SeDriver $Driver
        Get-UDDashboard | Stop-UDDashboard
    }
}