Function New-UserCache
{
    param(
        #$lastContactDays,
        #$refreshInterval
    )

    New-UDElement -Tag "SystemCache" -Id "SystemCache" -Content {
        Write-Debug "Loading user Content cache $(Get-Date)"
        $Cache:DisplayUsers = Get-JCUser
    }

}