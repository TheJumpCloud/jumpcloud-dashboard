Feature: Recent Password Updates

    As JumpCloud, I want to provide admins with a dashboard component that informs admins of end users recent password changes.

    Scenario: A JumpCloud admin of a tenant that has users and has password expiration enabled views the recent password update component

        Given the onboarding dashboard loads
        And the organization has JumpCloud users
        And the JumpCloud organization has password expiration enabled
        When the recent password update component loads
        Then the recent password updates component shows a tabular list of recent user password update information

    Scenario: A JumpCloud admin of a tenant that has users and does not have password expiration enabled views the recent password update component

        Given the onboarding dashboard loads
        And the organization has JumpCloud users
        When the recent password update component loads
        Then the recent password updates component informs the admin that password expiration must be enabled to view the component


    Scenario: A JumpCloud admin of a tenant that does not have users views the recent password update component

        Given the onboarding dashboard loads
        And the JumpCloud organization has password expiration enabled
        When the recent password update component loads
        Then the User Activation component directs the admin to the getting started users guide.
