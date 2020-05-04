Function New-DirectoryInsightsCache
{
    param(
        $eventDays,
        $refreshInterval
    )

    New-UDElement -Tag "DirectoryInsightsCache" -Id "DirectoryInsightsCache" -Content {
        Write-Debug "Loading system Content cache $(Get-Date)"
        $Cache:DirectoryInsightsEvents = Get-JCEvent -Service:('all') -StartTime:((Get-Date.AddDays(-$eventDays)))
    }

    New-UDElement -Tag "DirectoryInsightsEndpointCache" -Id "DirectoryInsightsEndpointCache" -AutoRefresh -RefreshInterval $refreshInterval -Endpoint {
        Write-Debug "Loading system Endpoint cache $(Get-Date)"
        $Cache:DirectoryInsightsEvents = Get-JCEvent -Service:('all') -StartTime:((Get-Date.AddDays(-$eventDays)))
}