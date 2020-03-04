Function New-SystemCache
{
    param(
        $lastContactDays,
        $refreshInterval
    )

    New-UDElement -Tag "SystemCache" -Id "SystemCache" -Content {
        Write-Debug "Loading system Content cache $(Get-Date)"
        $Cache:DisplaySystems = Get-SystemsWithLastContactWithinXDays -days $lastContactDays
    }

    New-UDElement -Tag "SystemEndpointCache" -Id "SystemEndpointCache" -AutoRefresh -RefreshInterval $refreshInterval -Endpoint {
        Write-Debug "Loading system Endpoint cache $(Get-Date)"
        $Cache:DisplaySystems = Get-SystemsWithLastContactWithinXDays -days $lastContactDays
    }
}