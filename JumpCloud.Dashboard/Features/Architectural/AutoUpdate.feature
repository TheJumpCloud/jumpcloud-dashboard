Feature: JumpCloud-Dashboard module auto-update

    As JumpCloud, I want to ensure the JumpCloud-Dashboard module updates itself automatically so that end users of the module receive the most up to date functionality

    Scenario: JumpCloud-Dashboard module running locally is the latest version.

        Given that a user is in the PowerShell terminal
        And the PowerShell version is >= 5
        And the locally installed JumpCloud-Dashboard PowerShell module version number is equal to the version number of the JumpCloud-Dashboard hosted in the PowerShell gallery
        When the user calls the Start-JCDashboard command
        Then the JumpCloud-Dashboard module remains at the current version
        And the dashboard process starts
        And the most up to date dashboard loads in the default web browser

    Scenario: JumpCloud-Dashboard module running locally is not running the latest version.

        Given that a user is in the PowerShell terminal
        And the PowerShell version is >= 5
        And the locally installed JumpCloud-Dashboard PowerShell module version number is less than the version number of the JumpCloud-Dashboard hosted in the PowerShell gallery
        When the user calls the Start-JCDashboard command
        Then the JumpCloud-Dashboard module updates to the latest version
        And the dashboard process starts
        And the most up to date dashboard loads in the default web browser