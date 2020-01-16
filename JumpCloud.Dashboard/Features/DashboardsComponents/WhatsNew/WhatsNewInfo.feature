Feature: Whats New Dashboard Component

    As JumpCloud, I want to provide admins with a dashboard component that provides dashboard viewers with information regarding what is new in the JumpCloud-Dashboard module.

    Scenario: An admin looks at the Whats New component

        Given the JumpCloud-Dashboard loads
        When the admin looks at the Whats-New component
        When then the whats new component shows new release updates
