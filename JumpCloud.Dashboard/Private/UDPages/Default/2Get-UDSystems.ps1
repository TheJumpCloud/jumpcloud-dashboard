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
    

    $UDPage = New-UDPage -Name:($PageName) -AutoRefresh -RefreshInterval $refreshInterval -Content {

        [int]$refreshInterval = $refreshInterval

        $PageLayout = '{"lg":[{"w":12,"h":3,"x":0,"y":0,"i":"grid-element-SystemsDownload"},{"w":4,"h":10,"x":0,"y":5,"i":"grid-element-OS"},{"w":4,"h":10,"x":4,"y":5,"i":"grid-element-SystemsMFA"},{"w":4,"h":10,"x":9,"y":5,"i":"grid-element-NewSystems"},{"w":4,"h":10,"x":0,"y":15,"i":"grid-element-AgentVersion"},{"w":4,"h":10,"x":4,"y":15,"i":"grid-element-OSVersion"},{"w":4,"h":10,"x":9,"y":15,"i":"grid-element-LastContact"}]}'
        $unDrawColor = "#006cac"


        New-UDElement -Tag "SystemCache" -Id "SystemCache" -Content {
            Write-Debug "Loading system Content cache $(Get-Date)"
            $Cache:DisplaySystems = Get-SystemsWithLastContactWithinXDays -days $lastContactDays
        }

        New-UDElement -Tag "SystemEndpointCache" -Id "SystemEndpointCache" -AutoRefresh -RefreshInterval $refreshInterval -Endpoint {
            Write-Debug "Loading system Endpoint cache $(Get-Date)"
            $Cache:DisplaySystems = Get-SystemsWithLastContactWithinXDays -days $lastContactDays
        }

        New-UDGridLayout -Layout $PageLayout -Content {

            Write-Debug "Loading SystemsDownload $(Get-Date)"
            UDCard-SystemsDownload -RefreshInterval $refreshInterval -lastContactDays $lastContactDays

            Write-Debug "Loading OS $(Get-Date)"
            UDElement-OS -RefreshInterval $refreshInterval -lastContactDays $lastContactDays

            Write-Debug "Loading SystemsMFA $(Get-Date)"
            UDElement-SystemsMFA -RefreshInterval $refreshInterval -lastContactDays $lastContactDays -unDrawColor $unDrawColor

            Write-Debug "Loading AgentVersion $(Get-Date)"
            UDElement-AgentVersion -RefreshInterval $refreshInterval -lastContactDays $lastContactDays

            Write-Debug "Loading OSVersion $(Get-Date)"
            UDElement-OSVersion -RefreshInterval $refreshInterval -lastContactDays $lastContactDays

            Write-Debug "Loading LastContact $(Get-Date)"
            UDElement-LastContact -RefreshInterval $refreshInterval -lastContactDays $lastContactDays

            Write-Debug "Loading NewSystems $(Get-Date)"
            UDElement-NewSystems -RefreshInterval $refreshInterval -lastContactDays $lastContactDays -unDrawColor $unDrawColor
        }

    }

    #$UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('Laptop')
    Return [PSCustomObject]@{
        'UDPage' = $UDPage;
        #    'UDSideNavItem' = $UDSideNavItem;
    }
}