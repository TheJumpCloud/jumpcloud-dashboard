Feature: System Insights Status Component

    As JumpCloud, I want to provide admins with a component that gives them at a glance information into the percentage of their systems enabled for system insights.

    Scenario: A JumpCloud admin of a tenant that has systems views the System Insights Status Component

        Given the system insights dashboard loads
        And systems insights is enabled for the org
        And systems are enrolled in the org
        When the admin looks at the system insights status component it reveals a chart that shows systems enabled or disabled for system insights

    Scenario: A JumpCloud admin of a tenant that has systems clicks the System Insights Status Component

        Given the system insights dashboard loads
        And systems insights is enabled for the org
        And systems are enrolled in the org
        When the admin clicks on the system insights status component it reveals a table that shows systems enabled or disabled for system insights

    Scenario: A JumpCloud admin of a tenant that has no systems views the System Insights Status component

        Given the system insights dashboard loads
        And systems insights is enabled for the org
        And no systems are registered to the org
        When the admin looks at the system insights status component it directs them to the getting started systems dashboard