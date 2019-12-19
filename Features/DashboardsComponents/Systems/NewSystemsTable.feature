Feature: System Dashboard New Systems Component

    As JumpCloud, I want to provide a systems dashboard to JumpCloud admins that provides the admins with at a glance insights into newly registered JumpCloud systems

    Scenario: New systems tabular component loads

        Given the System Dashboard loads
        When the user looks at the new systems table
        Then then the table loads an sorted list of systems added in the last 7 days