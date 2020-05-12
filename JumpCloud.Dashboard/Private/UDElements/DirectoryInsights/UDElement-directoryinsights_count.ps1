function UDElement-directoryinsights_count
{
    param (
        $refreshInterval,
        $unDrawColor,
        $eventDays
    )

    New-UDElement -Tag "directoryinsights_count" -Id "directoryinsights_count" -refreshInterval $refreshInterval -AutoRefresh -Content {
        New-UDCounter -Title "Events" -TextSize Large -Endpoint {
            50
        }
    }
}