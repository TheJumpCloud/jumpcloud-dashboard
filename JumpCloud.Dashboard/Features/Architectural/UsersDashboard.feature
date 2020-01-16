Feature: JumpCloud-Dashboard Users Dashboard

    As JumpCloud, I want to provide a Users dashboard to JumpCloud admins that provides the admins with at a glance insights into their JumpCloud Users.

    Scenario: JumpCloud Users registered for an org

        Given a web browser is at the Users-Dashboard page
        And there are Users resisted in the JumpCloud org
        When the dashboard loads
        Then the components of the Users dashboard load

    Scenario: No JumpCloud Users registered for an org
        Given the Users Dashboard loads
        And there are no JumpCloud Users for the org
        When the dashboard loads
        Then the admin is presented with a screen that informs them there are no Users in their JumpCloud org
        And the admin is presented with a link that informs them how to install the JumpCloud agent