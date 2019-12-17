Feature: System Dashboard OS Version Component

    As JumpCloud, I want to provide a component in the systems dashboard that provides JumpCloud admins with at a glance insights into their JumpCloud managed systems operating systems.

    Scenario: Systems OS % visual component

        Given the System Dashboard loads
        When the user looks at the Systems OS% component
        Then the Systems OS% shows an accurate reflection of the systems OS type (Mac, Windows, Linux) percentage in a pie chart
