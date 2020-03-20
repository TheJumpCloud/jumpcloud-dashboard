Function 3Get-OnboardingDashboard ()
{
    [CmdletBinding()]

    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        $lastContactDays,

        [Parameter(ValueFromPipelineByPropertyName)]
        $refreshInterval
    )

    $PageName = 'Onboarding'
    $UDPage = New-UDPage -Name:($PageName) -AutoRefresh -RefreshInterval $refreshInterval -Content {

        [int]$refreshInterval = $refreshInterval

        $PageLayout = '{"lg":[{"w":12,"h":3,"x":0,"y":0,"i":"grid-element-SystemsDownload"},{"w":4,"h":10,"x":0,"y":5,"i":"grid-element-system_os"},{"w":4,"h":10,"x":4,"y":5,"i":"grid-element-system_mfaStatus"},{"w":4,"h":10,"x":9,"y":5,"i":"grid-element-system_newSystems"},{"w":4,"h":10,"x":0,"y":15,"i":"grid-element-system_agentVersion"},{"w":4,"h":10,"x":4,"y":15,"i":"grid-element-system_version"},{"w":4,"h":10,"x":9,"y":15,"i":"grid-element-system_lastContact"}]}'
        $unDrawColor = "#006cac"

        New-SystemCache -lastContactDays:($lastContactDays) -refreshInterval:($refreshInterval)

        New-UDGridLayout -Layout $PageLayout -Content {

        }

    }
    Return [PSCustomObject]@{
        'UDPage' = $UDPage;
    }
}