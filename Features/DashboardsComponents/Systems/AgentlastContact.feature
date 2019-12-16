Feature: System Dashboard Agent Last Contact Component

    As JumpCloud, I want to provide a component in the systems dashboard to JumpCloud admins that provides admins with at a glance insights into the last contact of their JumpCloud managed systems.

    Note the dashboard will not load unless there are JumpCloud systems.

    Scenario: Agent Last Contact Graph Loads

        Given the Systems Dashboard loads
        When the user looks at the Agent Last Contact graph
        Then the agent last contact graph shows an accurate reflection of the last contact date of systems grouped into date ranges



    Scenario: Agent Last Contact Table Loads

        Given the Systems Dashboard Loads
        When the user clicks to expand the Agent Last Contact Table
        Then the user is presented with a tabular list of the Systems grouped into last contact date ranges.