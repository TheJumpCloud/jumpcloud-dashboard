Feature: System User Association Information

    As JumpCloud, I want to provide admins with a component that informs them of the number of users associated to each system.

    Scenario: A JumpCloud Admin of tenant that has systems views the system user association information component.

        Given the onboarding dashboard loads
        And the organization has JumpCloud systems
        When the system user association loads
        Then the system user association component shows a bar graph of systems system to user association counts

    Scenario: A JumpCloud Admin of tenant that has systems clicks on the system user association information component.

        Given the onboarding dashboard loads
        And the organization has JumpCloud systems
        When the admin clicks on a column on the system user association graph
        Then a tabular list of the systems represented by the column is revealed to the admin


    Scenario: A JumpCloud Admin of tenant that does not have systems views the system user association information component.

        Given the onboarding dashboard loads
        And the organization has JumpCloud systems
        When the system user association loads
        Then the system user association component directs the admin to the getting started systems guide.
