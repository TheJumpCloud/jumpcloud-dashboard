function UDElement-onboarding_radius() {
    param (
        $refreshInterval,
        $unDrawColor
    )

    $ServerDict = New-Object System.Collections.Specialized.OrderedDictionary
    $pServers = Get-JCRadiusServer
    $rServers = Get-JCRadiusServer | Get-JCAssociation
    foreach ($server in $rServers) {
        if ($ServerDict -notcontains ($server.id)) {
            $ServerDict[$server.id] += @($server.targetID)
        }
        else {
            $ServerDict.Add($server.id, @($server.targetID))
        }
    }
    New-UDElement -Tag "onboarding_radius" -Id "onboarding_radius" -Endpoint {
        if ($pServers){
            New-UDGrid -Title "Radius Servers"  -Headers @("Server Name", "Bound Groups") -Properties @("Server Name", "Bound Groups") -NoFilter -Endpoint {
                $pServers | ForEach-Object {
                    if ($_.id -in $ServerDict.Keys) {
                        [PSCustomObject]@{
                            "Server Name"  = (New-UDLink -Text $_.name -Url "https://console.jumpcloud.com/#/radius/$($_._id)/details" -OpenInNewWindow);
                            "Bound Groups" = $ServerDict[$_.id].Length;
                        }
                    }
                    else{
                        [PSCustomObject]@{
                            "Server Name"  = (New-UDLink -Text $_.name -Url "https://console.jumpcloud.com/#/radius/$($_._id)/details" -OpenInNewWindow);
                            "Bound Groups" = 0;
                        }
                    }
                } | Out-UDGridData
            } -NoExport
        }
        else {
            New-UDCard -Title "Radius Servers" -Content {
                New-UDunDraw -Name "safe" -Color $unDrawColor
                New-UDParagraph -Text "You have not configured any Radius Servers."
            }
        }
    }
}