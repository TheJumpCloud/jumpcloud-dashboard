Function New-UserCache
{
    param(
        #$lastContactDays,
        $refreshInterval
    )

    New-UDElement -Tag "UserCache" -Id "UserCache" -Content {
        Write-Debug "Loading user Content cache $(Get-Date)"
        $Cache:DisplayUsers = Get-JCUser
    }

    New-UDElement -Tag "UserCache" -Id "UserCache" -AutoRefresh $refreshInterval -Endpoint {
        Write-Debug "Loading user Content cache $(Get-Date)"
        $Cache:DisplayUsers = Get-JCUser
    }
}