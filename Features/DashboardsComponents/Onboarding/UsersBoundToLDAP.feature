Feature: Users Bound To LDAP

    As JumpCloud, I want to provide admins with a component that gives them at a glance info into LDAP integration

    Scenario: A JumpCloud admin of a tenant that has users bound to LDAP views the Users Bound To LDAP component

        Given the onboarding dashboard loads
        And the organizations has JumpCloud users bound to LDAP
        When the component loads
        Then the LDAP component shows a visualization that informs the admins of the percentage of users bound to LDAP

    Scenario: A JumpCloud admin of a tenant that has users bound to LDAP clicks the Users Bound To LDAP component

        Given the onboarding dashboard loads
        And the organizations has JumpCloud users bound to LDAP
        And the component loads
        When the admin clicks the component
        Then the LDAP component shows a tabular view that informs the admins of users who are and are not bound to LDAP

    Scenario: A JumpCloud tenant that does not have any users bound to LDAP views the Users Bound to LDAP component

        Given the onboarding dashboard loads
        And the organizations does not have JumpCloud users bound to LDAP
        When the component loads
        Then the LDAP component directs the admin to the getting stated guide for LDAP
