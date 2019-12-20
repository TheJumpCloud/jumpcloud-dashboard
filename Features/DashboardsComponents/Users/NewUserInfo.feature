Feature: User Dashboard New Users Component

    As JumpCloud, I want to provide a Users dashboard to JumpCloud admins that provides the admins with at a glance insights into newly registered JumpCloud Users

    Scenario: New Users tabular component loads

        Given the User Dashboard loads
        When the user looks at the new Users table
        Then then the table loads an sorted list of newly registered Users.