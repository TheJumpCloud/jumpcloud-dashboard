Feature: JumpCloud-Dashboard module beta feature

    As JumpCloud, I want to provide admins with the option to view "beta" dashboard pages.

    Beta pages would be composed of experimental dashboard components.

    Scenario: Admin launches JumpCloud-Dashboard and includes -Beta parameter

        Given that the user is in the PowerShell terminal
        And the JumpCloud-Dashboard PowerShell module is installed locally
        When the user calls the Start-JCDashboard command with the -Beta parameter
        Then all default dashboard pages will load
        And all beta dashboard pages will load

    Scenario: Admin launches JumpCloud-Dashboard and DOES NOT include the -Beta parameter

        Given that the user is in the PowerShell terminal
        And the JumpCloud-Dashboard PowerShell module is installed locally
        When the user calls the Start-JCDashboard command
        Then all default dashboard pages will load
        And all beta dashboard pages will NOT load
