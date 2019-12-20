Feature: User State Information

    As JumpCloud, I want to provide admins with components in the user dashboard that informs admins of the user states "suspended", "account_locked", "password_expired".

    Scenario: An admin looks at User State Information component and has users in one of the following states: "suspended", "account_locked", "password_expired".

        Given the User Dashboard loads
        When the user looks at the User State Information component
        Then the component informs the admin of the users in an actionable state.