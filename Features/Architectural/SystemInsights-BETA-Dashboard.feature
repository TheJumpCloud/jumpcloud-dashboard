Feature: JumpCloud-Dashboard Beta System Insights Dashboard

    As JumpCloud, I want to provide an BETA system insights dashboard.

    Scenario: Admin has system insights enabled for their org

        Given the Start-JCDashboard command has been called to launch the dashboard
        And the -Beta parameter has been used
        And system insights is enabled for the org
        When the system insights dashboard loads
        Then the components of the system insights dashboard loads

    Scenario: Admin does not have system insights enabled for their org

        Given the Start-JCDashboard command has been called to launch the dashboard
        And the -Beta parameter has been used
        And system insights is not enabled for the org
        When the system insights dashboard loads
        Then the admin is informed that they must enable system insights to view the components of the dashboard