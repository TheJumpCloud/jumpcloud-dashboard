function UDElement-directoryinsights_count
{
    param (
        $refreshInterval,
        $eventDays,
        $unDrawColor
    )

    New-UDElement -Tag "directoryinsights_count" -Id "directoryinsights_count" -refreshInterval $refreshInterval -AutoRefresh -Content {
        New-UDCounter -Title "Events" -Endpoint {
            $Cache:DirectoryInsightsEvents.Length
        }
    }
}