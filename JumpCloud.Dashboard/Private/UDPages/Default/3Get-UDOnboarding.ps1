Function 3Get-UDOnboarding() {
    [CmdletBinding()]

    param (

        [Parameter(ValueFromPipelineByPropertyName)]
        $refreshInterval
    )

    $PageName = 'Onboarding'

    $UDPage = New-UDPage -Name:($PageName) -Content {

        [int]$refreshInterval = $refreshInterval

        $PageLayout = '{"lg":[{"x":0,"y":0,"i":"grid-element-onboarding_ldap"}]}'
        $unDrawColor = "#006cac"

        New-UDGridLayout -Layout $PageLayout -Content {
            # Functions defining elements can be found in the /Private/UDElements/Onboarding folder

            UDElement-onboarding_ldap -refreshInterval $refreshInterval -unDrawColor $unDrawColor

        }
    }

    Return [PSCustomObject]@{
        'UDPage' = $UDPage;
    }
}