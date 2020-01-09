Feature: JumpCloud-Dashboard Onboarding Dashboard

    As JumpCloud, I want to provide an onboarding dashboard to JumpCloud admins that provides the admins with at a glance insights into their JumpCloud tenants onboarding information.

    Scenario: Admin onboarding to JumpCloud

        Given a web browser is on the Onboarding Dashboard page
        When the dashboard loads
        Then the components of the onboarding dashboard loads
