Feature: System Dashboard Agent MFA info component

    As JumpCloud, I want to provide a component in the systems dashboard to JumpCloud admins that provides admins with at a glance insights into the MFA status of their JumpCloud systems.

    Scenario: Agent Last Contact MFA Chart Loads

        Given the Systems Dashboard loads
        When the user looks at the Agent MFA Chart
        Then the MFA Chart shows an accurate reflection of the MFA status of their JumpCloud systems

    Scenario: Agent Last Contact Table Loads

        Given the Systems Dashboard Loads
        When the user clicks to expand the MFA status table
        Then the user is presented with a tabular list of the System MFA status.