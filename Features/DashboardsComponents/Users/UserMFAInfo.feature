Feature: User MFA Information Component

    As JumpCloud, I want to provide a component in User Dashboard that gives at a glance insight into user MFA configuration state.

    Scenario: Admin looks at MFA Information component

        Given the User Dashboard loads
        When An admin looks at the MFA component
        Then the MFA component displays the component shows an accureate breakdown of MFA user configuration