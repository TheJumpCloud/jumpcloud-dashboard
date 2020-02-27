Function 2Get-UDSystems ()
{
    [CmdletBinding()]

    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        $lastContactDays,

        [Parameter(ValueFromPipelineByPropertyName)]
        $refreshInterval
    )

    $PageText = 'Systems'
    $PageName = 'Systems'
    

    $UDPage = New-UDPage -Name:($PageName) -Content {

        [int]$refreshInterval = $refreshInterval

        $PageLayout = '{"lg":[{"w":12,"h":3,"x":0,"y":0,"i":"grid-element-SystemsDownload"},{"w":4,"h":10,"x":0,"y":5,"i":"grid-element-OS"},{"w":4,"h":10,"x":4,"y":5,"i":"grid-element-SystemsMFA"},{"w":4,"h":10,"x":9,"y":5,"i":"grid-element-NewSystems"},{"w":4,"h":10,"x":0,"y":15,"i":"grid-element-AgentVersion"},{"w":4,"h":10,"x":4,"y":15,"i":"grid-element-OSVersion"},{"w":4,"h":10,"x":9,"y":15,"i":"grid-element-LastContact"}]}'
        $unDrawColor = "#006cac"


        New-UDGridLayout -Layout $PageLayout -Content {

            UDCard-SystemsDownload -lastContactDays $lastContactDays

            UDElement-OS -RefreshInterval $refreshInterval -lastContactDays $lastContactDays

            UDElement-SystemsMFA -RefreshInterval $refreshInterval -lastContactDays $lastContactDays -unDrawColor $unDrawColor

            UDElement-AgentVersion -RefreshInterval $refreshInterval -lastContactDays $lastContactDays

            UDElement-OSVersion -RefreshInterval $refreshInterval -lastContactDays $lastContactDays

            UDElement-LastContact -RefreshInterval $refreshInterval -lastContactDays $lastContactDays

            UDElement-NewSystems -RefreshInterval $refreshInterval -lastContactDays $lastContactDays -unDrawColor $unDrawColor
        }

    }

    #$UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('Laptop')
    Return [PSCustomObject]@{
        'UDPage' = $UDPage;
        #    'UDSideNavItem' = $UDSideNavItem;
    }
}
