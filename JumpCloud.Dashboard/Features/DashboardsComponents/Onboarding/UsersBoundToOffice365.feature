Feature: Users Bound To Office365

    As JumpCloud, I want to provide admins with a component that gives them at a glance info into Office365 integration

    Scenario: A JumpCloud admin of a tenant that has users bound to Office365 views the Users Bound To Office365 component

        Given the onboarding dashboard loads
        And the organizations has JumpCloud users bound to Office365
        When the component loads
        Then the Office365 component shows a visualization that informs the admins of the percentage of users bound to Office365

    Scenario: A JumpCloud admin of a tenant that has users bound to Office365 clicks the Users Bound To Office365 component

        Given the onboarding dashboard loads
        And the organizations has JumpCloud users bound to Office365
        And the component loads
        When the admin clicks the component
        Then the Office365 component shows a tabular view that informs the admins of users who are and are not bound to Office365

    Scenario: A JumpCloud tenant that does not have any users bound to Office365 views the Users Bound to Office365 component

        Given the onboarding dashboard loads
        And the organizations does not have JumpCloud users bound to Office365
        When the component loads
        Then the Office365 component directs the admin to the getting stated guide for Office365
