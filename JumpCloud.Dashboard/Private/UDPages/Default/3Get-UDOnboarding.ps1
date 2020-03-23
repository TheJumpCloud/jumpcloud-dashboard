Function 3Get-UDOnboarding() {
    [CmdletBinding()]

    param (

        [Parameter(ValueFromPipelineByPropertyName)]
        $refreshInterval
    )
    $UserCache = New-UserCache
    $PageName = 'Onboarding'

    $UDPage = New-UDPage -Name:($PageName) -Content {

        [int]$refreshInterval = $refreshInterval

        $PageLayout = '{"lg":[{"w":4,"h":10,"x":0,"y":0,"i":"grid-element-onboarding_ldap","moved":false,"static":false},{"w":4,"h":10,"x":4,"y":0,"i":"grid-element-useractivationstatus","moved":false,"static":false},{"w":4,"h":10,"x":0,"y":1,"i":"grid-element-onboarding_gsuite","moved":false,"static":false}]}'
        $unDrawColor = "#006cac"

        New-UDGridLayout -Layout $PageLayout -Content {
            # Functions defining elements can be found in the /Private/UDElements/Onboarding folder

            UDElement-onboarding_ldap -refreshInterval $refreshInterval -unDrawColor $unDrawColor
            UDElement-onboarding_useractivationstatus -refreshInterval $refreshInterval -unDrawColor $unDrawColor
            UDElement-onboarding_gsuite -refreshInterval $refreshInterval -unDrawColor $unDrawColor
        }
    }

    Return [PSCustomObject]@{
        'UDPage' = $UDPage;
    }
}