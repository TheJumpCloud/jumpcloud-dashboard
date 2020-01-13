Feature: User Dashboard Privileged User Info Component

    As JumpCloud, I want to provide a component in the User Dashboard that gives at a glance insights into users with Privileged accounts

    Scenario: Privileged User tabular component loads

        Given the User Dashboard loads
        When an admin looks at the Privileged User table
        Then the table informs admin of users configured with Global Admin (sudo = true) permissions and ldap binding users permissions