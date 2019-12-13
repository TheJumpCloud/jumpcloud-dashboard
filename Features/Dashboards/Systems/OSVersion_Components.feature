Feature: JumpCloud-Dashboard Systems Dashboard

    As JumpCloud, I want to provide a systems dashboard to JumpCloud admins that provides the admins with at a glance insights into their JumpCloud managed systems.

    Scenario: JumpCloud Systems Dashboard opens in web browser

        Given a web browser is at the Systems-Dashboard page
        When the dashboard loads
        Then the components of the systems dashboard load

    Scenario: Systems OS % visual component

        Given the System Dashboard loads
        When the user looks at the Systems OS% component
        Then the Systems OS% shows an accurate reflection of the systems OS type (Mac, Windows, Linux) percentage in a pie chart

    Scenario: Systems OS % tabular component

        Given the System Dashboard loads
        When the user clicks to expand the Systems OS % tabular component
        Then the user is presented with a tabular list the Systems OS% broken out by Mac, Windows, & Linux.

    Scenario: Systems Mac OS Version % visual component

        Given the System Dashboard loads
        When the user looks at the Systems Mac OS% component
        Then the Systems Mac OS% shows an accurate reflection of the systems OS percentage in a pie chart

    Scenario: Systems Mac OS Version % tabular component

        Given the System Dashboard loads
        When the user clicks to expand the Systems Mac OS Version % tabular component
        Then the user is presented with a tabular list the Systems Mac OS%

    Scenario: Systems Windows OS Version % visual component

        Given the System Dashboard loads
        When the user looks at the Systems Windows OS% component
        Then the Systems Windows OS% shows an accurate reflection of the systems OS percentage in a pie chart

    Scenario: Systems Windows OS Version % tabular component

        Given the System Dashboard loads
        When the user clicks to expand the Systems Windows OS Version % tabular component
        Then the user is presented with a tabular list the Windows Systems OS%

    Scenario: Systems Linux OS Version % visual component

        Given the System Dashboard loads
        When the user looks at the Linux Systems OS% component
        Then the Systems OS% shows an accurate reflection of the Linux systems OS percentage in a pie chart

    Scenario: Systems Linux OS Version % tabular component

        Given the System Dashboard loads
        When the user clicks to expand the Systems Linux OS Version % tabular component
        Then the user is presented with a tabular list the Linux Systems OS%