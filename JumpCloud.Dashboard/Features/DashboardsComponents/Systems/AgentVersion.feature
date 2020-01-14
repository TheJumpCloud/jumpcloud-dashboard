Feature: System Dashboard Agent Version Component

    As JumpCloud, I want to provide a component in the systems dashboard to JumpCloud admins that provides the admins with at a glance insights into the JumpCloud agent version their systems are running.

    Scenario: Agent Version Component Graph Loads

        Given the System Dashboard loads
        When the user looks at the Agent Version graph
        Then the user sees a graph that shows an accurate refection of the agent version running on systems that have checked in in the last 7 days.

    Scenario: Systems Agent Version Table Loads

        Given the System Dashboard loads
        When the user clicks on the Systems Agent Version table
        Then the user is presented with a tabular list of Systems grouped by agent version.

