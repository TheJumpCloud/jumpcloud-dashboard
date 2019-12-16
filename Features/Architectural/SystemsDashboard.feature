Feature: JumpCloud-Dashboard Systems Dashboard

    As JumpCloud, I want to provide a systems dashboard to JumpCloud admins that provides the admins with at a glance insights into their JumpCloud systems.

    Scenario: JumpCloud Systems Dashboard opens in web browser

        Given a web browser is at the Systems-Dashboard page
        When the dashboard loads
        Then the components of the systems dashboard load

    Scenario: No JumpCloud systems in an org
        Given the Systems Dashboard loads
        And there are no JumpCloud systems for the org
        When the user looks at the Agent