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

        $PageLayout = '{"lg":[{"w":4,"h":10,"x":0,"y":5,"i":"grid-element-directoryinsights_count"},{"w":4,"h":10,"x":4,"y":5,"i":"grid-element-directoryinsights_userCreateDelete"},{"w":4,"h":10,"x":9,"y":5,"i":"grid-element-directoryinsights_dailyUserPortalLoginAttempts"},{"w":4,"h":10,"x":0,"y":15,"i":"grid-element-directoryinsights_userGroupChanges"},{"w":4,"h":10,"x":4,"y":15,"i":"grid-element-directoryinsights_systemGroupChanges"},{"w":4,"h":10,"x":9,"y":15,"i":"grid-element-directoryinsights_dailyAdminConsoleLoginAttempts"}]}'
        $unDrawColor = "#006cac"
        $Script:eventDays1 = $eventDays

        New-DirectoryInsightsCache -eventDays:($eventDays) -refreshInterval:($refreshInterval)

        New-UDGridLayout -Layout $PageLayout -Content {
            # Functions defining elements can be found in the /Private/UDElements/DirectoryInsights folder

            UDElement-directoryinsights_count -refreshInterval $refreshInterval -unDrawColor $unDrawColor
            UDElement-directoryinsights_userCreateDelete -refreshInterval $refreshInterval -unDrawColor $unDrawColor
            UDElement-directoryinsights_systemGroupChanges -refreshInterval $refreshInterval -unDrawColor $unDrawColor
            UDElement-directoryinsights_dailyUserPortalLoginAttempts -eventDays $eventDays1 -refreshInterval $refreshInterval -unDrawColor $unDrawColor
            UDElement-directoryinsights_userGroupChanges -refreshInterval $refreshInterval -unDrawColor $unDrawColor
            UDElement-directoryinsights_dailyAdminConsoleLoginAttempts -eventDays $eventDays1 -refreshInterval $refreshInterval -unDrawColor $unDrawColor
        }
    }

    Return [PSCustomObject]@{
        'UDPage' = $UDPage;
    }
}