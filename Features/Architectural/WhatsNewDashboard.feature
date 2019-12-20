Feature: JumpCloud-Dashboard Whats New Dashboard Page

    As JumpCloud, I want to provide a whats new dashboard that gives insights into version updates and releases to the JumpCloud-Dashboard module

    Scenario: JumpCloud dashboard module updates

        Given a web browser is at the Whats-Dashboard page
        And the dashboard has updated
        When the dashboard loads
        Then the components of the whats-new dashboard informs admins of the changes
