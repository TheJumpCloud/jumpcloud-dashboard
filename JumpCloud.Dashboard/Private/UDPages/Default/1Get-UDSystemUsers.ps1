Function 1Get-UDSystemUsers ()
{
    [CmdletBinding()]

    param (

        [Parameter(ValueFromPipelineByPropertyName)]
        $refreshInterval
    )

    $PageText = 'Users'
    $PageName = 'SystemUsers'

    $UDPage = New-UDPage -Name:($PageName) -Content {

        [int]$refreshInterval = $refreshInterval

        $PageLayout = '{"lg":[{"w":12,"h":3,"x":0,"y":0,"i":"grid-element-UsersDownload"},{"w":4,"h":10,"x":0,"y":4,"i":"grid-element-NewUsers"},{"w":4,"h":10,"x":4,"y":4,"i":"grid-element-UserState"},{"w":4,"h":10,"x":9,"y":4,"i":"grid-element-PrivilegedUsers"},{"w":4,"h":10,"x":0,"y":15,"i":"grid-element-UsersMFA"},{"w":4,"h":10,"x":4,"y":15,"i":"grid-element-PasswordExpiration"},{"w":4,"h":10,"x":9,"y":15,"i":"grid-element-PasswordChanges"}]}'
        $unDrawColor = "#006cac"

        New-UDGridLayout -Layout $PageLayout -Content {

            # Functions defining elements can be found in the /Private/UDElements/SytemUsers folder

            UDCard-UsersDownload

            UDElement-NewUsers -refreshInterval $refreshInterval -unDrawColor $unDrawColor

            UDElement-UserState -refreshInterval $refreshInterval -unDrawColor $unDrawColor

            UDElement-PrivilegedUsers -refreshInterval $refreshInterval -unDrawColor $unDrawColor

            UDElement-UsersMFA -refreshInterval $refreshInterval -unDrawColor $unDrawColor

            UDElement-PasswordExpiration -refreshInterval $refreshInterval -unDrawColor $unDrawColor

            UDElement-PasswordChanges -refreshInterval $refreshInterval -unDrawColor $unDrawColor

        }
    }

    #$UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('Users')
    Return [PSCustomObject]@{
        'UDPage' = $UDPage;
        #    'UDSideNavItem' = $UDSideNavItem;
    }
}