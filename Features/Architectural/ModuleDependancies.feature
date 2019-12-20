Feature: JumpCloud-Dashboard Module Dependencies

    As JumpCloud, I want to create a module that uses functions in the UniversalDashboard.Community and JumpCloud PowerShell module.

    Scenario: Admin installs the JumpCloud-Dashboard on macOS system

        Given PowerShell core is installed
        When the admin installs the JumpCloud Dashboard
        Then the JumpCloud PowerShell module install
        And the UniversalDashboard.Community install


    Scenario: Admin installs the JumpCloud-Dashboard on Windows system
        Given Windows PowerShell is installed
        When the admin installs the JumpCloud Dashboard
        Then the JumpCloud PowerShell module install
        And the UniversalDashboard.Community install

    Scenario: Admin installs the JumpCloud-Dashboard on Linux system

        Given PowerShell core is installed
        When the admin installs the JumpCloud Dashboard
        Then the JumpCloud PowerShell module install
        And the UniversalDashboard.Community install