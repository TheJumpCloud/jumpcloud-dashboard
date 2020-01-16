Feature: User Activation Information

    As JumpCloud, I want to provide admins with a component that informs them with at a glance info into user activation information.

    Scenario: A JumpCloud admin of a tenant that has users views the user activation information component

        Given the onboarding dashboard loads
        And the organization has JumpCloud users
        When the User Activation Information component loads
        Then the User Activation component shows an accurate representation of "active" vs "pending" users


    Scenario: A JumpCloud admin of a tenant with zero users views the user activation information component

        Given the onboarding dashboard loads
        When the User Activation Information component loads
        Then the User Activation component directs the admin to the getting started users guide.
