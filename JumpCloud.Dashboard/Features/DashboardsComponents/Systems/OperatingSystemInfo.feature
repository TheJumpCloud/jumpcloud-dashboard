Feature: System Dashboard OS Info Component

    As JumpCloud, I want to provide donut charts inside the system dashboard that show at a glance Operating System version information to JumpCloud admins.

    Scenario: Systems OS Donut Chart

        Given the System Dashboard loads
        When the user looks at the Systems OS% Donut Chart
        Then the Systems OS% chart shows an accurate reflection of the systems OS type (Mac, Windows, Linux) percentages in a donut chart

    Scenario: Systems Granular OS Version Donut Chart

        Given the System Dashboard loads
        When the user looks at the Systems OS% Donut Chart
        Then the Systems OS% chart shows an accurate reflection of the systems OS type (Mac, Windows, Linux) versions in a donut chart

    Scenario: Granular Systems OS Version Table

        Given the System Dashboard loads
        When the user clicks on the Systems OS Version table
        Then a table loads with JumpCloud system os information