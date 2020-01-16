Feature: JumpCloud-Dashboard Systems Dashboard

    As JumpCloud, I want to provide a systems dashboard to JumpCloud admins that provides the admins with at a glance insights into their JumpCloud systems.

    Scenario: JumpCloud systems registered for an org

        Given a web browser is at the Systems-Dashboard page
        And there are systems resisted in the JumpCloud org
        When the dashboard loads
        Then the components of the systems dashboard load

    Scenario: No JumpCloud systems registered for an org
        Given the Systems Dashboard loads
        And there are no JumpCloud systems for the org
        When the dashboard loads
        Then the admin is presented with a screen that informs them there are no systems in their JumpCloud org
        And the admin is presented with a link that informs them how to install the JumpCloud agent