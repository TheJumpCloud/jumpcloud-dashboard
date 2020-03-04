Function 2Get-UDSystems ()
{
    [CmdletBinding()]

    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        $lastContactDays,

        [Parameter(ValueFromPipelineByPropertyName)]
        $refreshInterval
    )

    $PageName = 'Systems'
    $UDPage = New-UDPage -Name:($PageName) -AutoRefresh -RefreshInterval $refreshInterval -Content {

        [int]$refreshInterval = $refreshInterval

        $PageLayout = '{"lg":[{"w":12,"h":3,"x":0,"y":0,"i":"grid-element-SystemsDownload"},{"w":4,"h":10,"x":0,"y":5,"i":"grid-element-system_os"},{"w":4,"h":10,"x":4,"y":5,"i":"grid-element-system_mfaStatus"},{"w":4,"h":10,"x":9,"y":5,"i":"grid-element-system_newSystems"},{"w":4,"h":10,"x":0,"y":15,"i":"grid-element-system_agentVersion"},{"w":4,"h":10,"x":4,"y":15,"i":"grid-element-system_version"},{"w":4,"h":10,"x":9,"y":15,"i":"grid-element-system_lastContact"}]}'
        $unDrawColor = "#006cac"

        New-SystemCache -lastContactDays:($lastContactDays) -refreshInterval:($refreshInterval)

        New-UDGridLayout -Layout $PageLayout -Content {

            Write-Debug "Loading SystemsDownload $(Get-Date)"
            UDCard-SystemsDownload -RefreshInterval $refreshInterval -lastContactDays $lastContactDays

            Write-Debug "Loading system_os $(Get-Date)"
            UDElement-system_os -RefreshInterval $refreshInterval -lastContactDays $lastContactDays

            Write-Debug "Loading system_mfaStatus $(Get-Date)"
            UDElement-system_mfaStatus -RefreshInterval $refreshInterval -lastContactDays $lastContactDays -unDrawColor $unDrawColor

            Write-Debug "Loading system_agentVersion $(Get-Date)"
            UDElement-system_agentVersion -RefreshInterval $refreshInterval -lastContactDays $lastContactDays

            Write-Debug "Loading system_version $(Get-Date)"
            UDElement-system_version -RefreshInterval $refreshInterval -lastContactDays $lastContactDays

            Write-Debug "Loading system_lastContact $(Get-Date)"
            UDElement-system_lastContact -RefreshInterval $refreshInterval -lastContactDays $lastContactDays

            Write-Debug "Loading system_newSystems $(Get-Date)"
            UDElement-system_newSystems -RefreshInterval $refreshInterval -lastContactDays $lastContactDays -unDrawColor $unDrawColor
        }

    }
    Return [PSCustomObject]@{
        'UDPage' = $UDPage;
    }
}