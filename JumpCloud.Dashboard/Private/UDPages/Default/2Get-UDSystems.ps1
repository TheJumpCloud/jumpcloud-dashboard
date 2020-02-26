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

        $PageLayout = '{"lg":[{"w":25,"h":24,"x":1,"y":1,"i":"grid-element-OS"}]}'
        $unDrawColor = "#006cac"


        New-UDGridLayout -Layout $PageLayout -Content {

            #UDCard-SystemsDownload -lastContactDays $lastContactDays

            UDElement-OS -RefreshInterval $refreshInterval -lastContactDays $lastContactDays

            #UDElement-SystemsMFA -RefreshInterval $refreshInterval -lastContactDays $lastContactDays -unDrawColor $unDrawColor

            #UDElement-AgentVersion -RefreshInterval $refreshInterval -lastContactDays $lastContactDays

            #UDElement-OSVersion -RefreshInterval $refreshInterval -lastContactDays $lastContactDays

            #UDElement-LastContact -RefreshInterval $refreshInterval -lastContactDays $lastContactDays

            #UDElement-NewSystems -RefreshInterval $refreshInterval -lastContactDays $lastContactDays -unDrawColor $unDrawColor
        }

    }

    #$UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('Laptop')
    Return [PSCustomObject]@{
        'UDPage' = $UDPage;
        #    'UDSideNavItem' = $UDSideNavItem;
    }
}
