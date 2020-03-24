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

        $PageLayout = '{"lg":[{"w":4,"h":10,"x":0,"y":0,"i":"grid-element-onboarding_ldap"},{"w":4,"h":10,"x":4,"y":0,"i":"grid-element-useractivationstatus"},{"w":4,"h":10,"x":0,"y":1,"i":"grid-element-onboarding_gsuite"},{"w":4,"h":10,"x":9,"y":0,"i":"grid-element-onboarding_o365"}]}'
        $unDrawColor = "#006cac"

        New-UDGridLayout -Layout $PageLayout -Content {
            # Functions defining elementfs can be found in the /Private/UDElements/Onboarding folder

            UDElement-onboarding_ldap -refreshInterval $refreshInterval -unDrawColor $unDrawColor
            UDElement-onboarding_o365 -refreshInterval $refreshInterval -unDrawColor $unDrawColor
            UDElement-onboarding_useractivationstatus -refreshInterval $refreshInterval -unDrawColor $unDrawColor
            UDElement-onboarding_gsuite -refreshInterval $refreshInterval -unDrawColor $unDrawColor
        }
    }

    Return [PSCustomObject]@{
        'UDPage' = $UDPage;
    }
}