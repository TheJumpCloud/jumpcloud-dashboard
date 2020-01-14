Feature: Users Bound To G Suite

    As JumpCloud, I want to provide admins with a component that gives them at a glance info into G Suite integration

    Scenario: A JumpCloud admin of a tenant that has users bound to G Suite views the Users Bound To G Suite component

        Given the onboarding dashboard loads
        And the organizations has JumpCloud users bound to G Suite
        When the component loads
        Then the G Suite component shows a visualization that informs the admins of the percentage of users bound to G Suite

    Scenario: A JumpCloud admin of a tenant that has users bound to G Suite clicks the Users Bound To G Suite component

        Given the onboarding dashboard loads
        And the organizations has JumpCloud users bound to G Suite
        And the component loads
        When the admin clicks the component
        Then the G Suite component shows a tabular view that informs the admins of users who are and are not bound to G Suite

    Scenario: A JumpCloud tenant that does not have any users bound to G Suite views the Users Bound to G Suite component

        Given the onboarding dashboard loads
        And the organizations does not have JumpCloud users bound to G Suite
        When the component loads
        Then the G Suite component directs the admin to the getting stated guide for G Suite
