Feature: System Dashboard OS Version Component

    As JumpCloud, I want to provide pie charts inside the system dashboard that show at a glance information to JumpCloud admins.

    Scenario: Systems OS % Pie Chart

        Given the System Dashboard loads
        When the user looks at the Systems OS% Pie Chart
        Then the Systems OS% chart shows an accurate reflection of the systems OS type (Mac, Windows, Linux) percentages in a pie chart

    Scenario: Systems MFA Enabled % Pie Chart

        Given the System Dashboard loads
        When the user looks at the Systems MFA% Pie Chart
        Then the Systems MFA % chart shows an accurate reflection of MFA enabled systems

    Scenario: Systems Insights Enabled % Pie Chart

        Given the System Dashboard loads
        When the user looks at the Systems Insights Enabled % pie chart
        Then the Systems Insights Enabled % chart shows an accurate reflection of System Insights enabled systems
