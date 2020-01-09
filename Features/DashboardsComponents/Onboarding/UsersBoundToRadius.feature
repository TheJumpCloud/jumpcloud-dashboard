Feature: Users Bound To RADIUS

    As JumpCloud, I want to provide admins with a component that gives them at a glance info into RADIUS integration

    Scenario: A JumpCloud admin of a tenant that has users bound to RADIUS views the Users Bound To RADIUS component

        Given the onboarding dashboard loads
        And the organizations has JumpCloud users bound to RADIUS
        When the component loads
        Then the RADIUS component shows a visualization that informs the admins of the percentage of users bound to RADIUS

    Scenario: A JumpCloud admin of a tenant that has users bound to RADIUS clicks the Users Bound To RADIUS component

        Given the onboarding dashboard loads
        And the organizations has JumpCloud users bound to RADIUS
        And the component loads
        When the admin clicks the component
        Then the RADIUS component shows a tabular view that informs the admins of users who are and are not bound to RADIUS

    Scenario: A JumpCloud tenant that does not have any users bound to RADIUS views the Users Bound to RADIUS component

        Given the onboarding dashboard loads
        And the organizations does not have JumpCloud users bound to RADIUS
        When the component loads
        Then the RADIUS component directs the admin to the getting stated guide for RADIUS
