Function 4Get-UDDirectoryInsights() {
    [CmdletBinding()]

    param (

        [Parameter(ValueFromPipelineByPropertyName)]
        $refreshInterval
    )
    $UserCache = New-UserCache -refreshInterval $refreshInterval
    $PageName = 'Directory'

    $UDPage = New-UDPage -Name:($PageName) -Content {

        [int]$refreshInterval = $refreshInterval

        # $PageLayout = '{"lg":[{"w":4,"h":10,"x":0,"y":0,"i":"grid-element-associations_ldap","moved":false,"static":false},{"w":4,"h":10,"x":4,"y":0,"i":"grid-element-associations_useractivationstatus","moved":false,"static":false},{"w":4,"h":10,"x":0,"y":1,"i":"grid-element-associations_gsuite","moved":false,"static":false},{"w":4,"h":10,"x":4,"y":1,"i":"grid-element-associations_syspolicy","moved":false,"static":false},{"w":4,"h":10,"x":8,"y":0,"i":"grid-element-associations_radius","moved":false,"static":false},{"w":4,"h":10,"x":8,"y":1,"i":"grid-element-associations_o365","moved":false,"static":false}]}'
        $unDrawColor = "#006cac"

        # New-UDGridLayout -Layout $PageLayout -Content {
            # Functions defining elements can be found in the /Private/UDElements/associations folder

            # UDElement-associations_ldap -refreshInterval $refreshInterval -unDrawColor $unDrawColor
            # UDElement-associations_useractivationstatus -refreshInterval $refreshInterval -unDrawColor $unDrawColor
            # UDElement-associations_gsuite -refreshInterval $refreshInterval -unDrawColor $unDrawColor
            # UDElement-associations_radius -refreshInterval $refreshInterval -unDrawColor $unDrawColor
            # UDElement-associations_o365 -refreshInterval $refreshInterval -unDrawColor $unDrawColor
            # UDElement-associations_syspolicy -refreshInterval $refreshInterval -unDrawColor $unDrawColor
        # }
    }

    Return [PSCustomObject]@{
        'UDPage' = $UDPage;
    }
}