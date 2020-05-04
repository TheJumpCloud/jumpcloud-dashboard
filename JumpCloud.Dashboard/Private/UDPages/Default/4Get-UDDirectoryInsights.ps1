Function 4Get-UDDirectoryInsights() {
    [CmdletBinding()]

    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        $eventDays,

        [Parameter(ValueFromPipelineByPropertyName)]
        $refreshInterval
    )
    
    $PageName = 'DirectoryInsights'
    $UDPage = New-UDPage -Name:($PageName) -Content {

        [int]$refreshInterval = $refreshInterval

        $PageLayout = '{"lg":[{"w":12,"h":3,"x":0,"y":0,"i":"grid-element-<ID>"},{"w":4,"h":10,"x":0,"y":5,"i":"grid-element-<ID>"},{"w":4,"h":10,"x":4,"y":5,"i":"grid-element-<ID>"},{"w":4,"h":10,"x":9,"y":5,"i":"grid-element-system_<ID>"},{"w":4,"h":10,"x":0,"y":15,"i":"grid-element-<ID>"},{"w":4,"h":10,"x":4,"y":15,"i":"grid-element-<ID>"},{"w":4,"h":10,"x":9,"y":15,"i":"grid-element-<ID>"}]}'
        $unDrawColor = "#006cac"

        New-UDGridLayout -Layout $PageLayout -Content {
            # Functions defining elements can be found in the /Private/UDElements/DirectoryInsights folder

            # UDElement-associations_ldap -refreshInterval $refreshInterval -unDrawColor $unDrawColor
            # UDElement-associations_useractivationstatus -refreshInterval $refreshInterval -unDrawColor $unDrawColor
            # UDElement-associations_gsuite -refreshInterval $refreshInterval -unDrawColor $unDrawColor
            # UDElement-associations_radius -refreshInterval $refreshInterval -unDrawColor $unDrawColor
            # UDElement-associations_o365 -refreshInterval $refreshInterval -unDrawColor $unDrawColor
            # UDElement-associations_syspolicy -refreshInterval $refreshInterval -unDrawColor $unDrawColor
        }
    }

    Return [PSCustomObject]@{
        'UDPage' = $UDPage;
    }
}