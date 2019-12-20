Feature: User Activation Information

    As JumpCloud, I want to provide admins with a component in the users dashboard that informs admins with at a glance info into user activation information.

    Scenario: An admin looks at the user activation component

        Given the User Dashboard loads
        When the admin looks at the User Activation component
        Then the User Activation component shows an accurate representation of "active" vs "pending" users