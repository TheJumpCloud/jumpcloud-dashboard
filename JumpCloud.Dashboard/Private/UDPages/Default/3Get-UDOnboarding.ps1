Function 3Get-UDOnboarding() {
    [CmdletBinding()]

    param (

        [Parameter(ValueFromPipelineByPropertyName)]
        $refreshInterval
    )

    $PageName = 'Onboarding'

    $UDPage = New-UDPage -Name:($PageName) -Content {

        [int]$refreshInterval = $refreshInterval

        $PageLayout = '{"lg":[{"w":12,"h":3,"x":0,"y":0,"i":"grid-element-onboarding_0365status"},{"w":4,"h":10,"x":0,"y":4,"i":"grid-element-user_newUsers"},{"w":4,"h":10,"x":4,"y":4,"i":"grid-element-user_userStates"},{"w":4,"h":10,"x":9,"y":4,"i":"grid-element-user_privilegedUsers"},{"w":4,"h":10,"x":0,"y":15,"i":"grid-element-user_mfaStatus"},{"w":4,"h":10,"x":4,"y":15,"i":"grid-element-user_passwordExpirations"},{"w":4,"h":10,"x":9,"y":15,"i":"grid-element-user_passwordChanges"}]}'
        $unDrawColor = "#006cac"

        New-UDGridLayout -Layout $PageLayout -Content {

            # Functions defining elements can be found in the /Private/UDElements/Onboarding folder

            UDElement-onboarding_0365status -refreshInterval $refreshInterval -unDrawColor $unDrawColor

            UDElement-user_userStates -refreshInterval $refreshInterval -unDrawColor $unDrawColor

            UDElement-user_privilegedUsers -refreshInterval $refreshInterval -unDrawColor $unDrawColor

            UDElement-user_mfaStatus -refreshInterval $refreshInterval -unDrawColor $unDrawColor

            UDElement-user_passwordExpirations -refreshInterval $refreshInterval -unDrawColor $unDrawColor

            UDElement-user_passwordChanges -refreshInterval $refreshInterval -unDrawColor $unDrawColor

        }
    }

    Return [PSCustomObject]@{
        'UDPage' = $UDPage;
    }
}