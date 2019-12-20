Feature: Password Expiration Information

    As JumpCloud, I want to provide admins with a component in the users dashboard that informs admins of upcoming user password expirations.

    Scenario: An admin has password expiration enabled for their JumpCloud org

        Given the User Dashboard loads
        And a JumpCloud organization is enabled for password expiration
        When the user looks at the password expiration table
        Then the table loads an sorted list of upcoming password expirations


    Scenario: An admin does not have password expiration enabled for their JumpCloud org

        Given the User Dashboard loads
        And a JumpCloud organization is NOT enabled for password expiration
        When the user looks at the User Dashboard
        Then the password expiration table does not load