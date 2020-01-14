Feature: System Insights Tables

    As JumpCloud, I want to provide admins with a component that gives them at a glance information into their system insights data

    Scenario: A JumpCloud admin of a tenant that has systems views the System Insights Table Component

        Given the system insights dashboard loads
        And systems insights is enabled for the org
        And systems are enrolled in the org
        When the admin looks at the system insights table component it reveals a table that shows them their system insights data

    Scenario: A JumpCloud admin of a tenant that has no systems views the System Insights Table component

        Given the system insights dashboard loads
        And systems insights is enabled for the org
        And no systems are registered to the org
        When the admin looks at the system insights table component it directs them to the getting started systems dashboard