function UDElement-directoryinsights_count
{
    param (
        $refreshInterval,
        $unDrawColor
    )

    New-UDElement -Tag "directoryinsights_count" -Id "directoryinsights_count" -refreshInterval $refreshInterval -AutoRefresh -Content {
        New-UDCounter -Title "Events" -Endpoint {
            $Cache:DirectoryInsightsEvents.Length
        }
    }
}