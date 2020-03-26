function UDElement-onboarding_radius() {
    param (
        $refreshInterval,
        $unDrawColor
    )

    $ServerHash = New-Object System.Collections.Specialized.OrderedDictionary
    $pServers = Get-JCRadiusServer
    $rServers = Get-JCRadiusServer | Get-JCAssociation
    foreach ($server in $rServers) {
        if ($ServerHash -notcontains ($server.id)) {
            $ServerHash[$server.id] += @($server.targetID)
        }
        else {
            $ServerHash.Add($server.id, @($server.targetID))
        }
    }
    New-UDElement -Tag "onboarding_radius" -Id "onboarding_radius" -Endpoint {
        New-UDGrid -Title "Radius Servers"  -Headers @("Server Name", "Bound Groups") -Properties @("Server Name", "Bound Groups") -NoFilter -Endpoint {
            $ServerHash.Keys | ForEach-Object {
                for ($i = 0; $i -le $pServers.Length; $i++) {
                    if ($pServers[$i].id -eq $_) {
                        # Write-Output "Server: " $pServers[$i].name $_
                        [PSCustomObject]@{
                            "Server Name"    = (New-UDLink -Text $pServers[$i].name -Url "https://console.jumpcloud.com/#/radius/$_/details" -OpenInNewWindow);
                            "Bound Groups" = $ServerHash[$_].Length;
                        }
                    }
                }
            } | Out-UDGridData
        } -NoExport
    }
}