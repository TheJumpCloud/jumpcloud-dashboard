function UDElement-associations_radius() {
    param (
        $refreshInterval,
        $unDrawColor
    )

    $ServerDict = New-Object System.Collections.Specialized.OrderedDictionary
    $allServers = Get-JCRadiusServer
    $filteredServers = Get-JCRadiusServer | Get-JCAssociation
    foreach ($server in $filteredServers) {
        if ($ServerDict -notcontains ($server.id)) {
            $ServerDict[$server.id] += @($server.targetID)
        }
        else {
            $ServerDict.Add($server.id, @($server.targetID))
        }
    }
    New-UDElement -Tag "associations_radius" -Id "associations_radius" -Endpoint {
        if ($allServers){
            New-UDGrid -Title "Radius Servers"  -Headers @("Server Name", "IP Address", "Bound User Groups") -Properties @("Server Name", "IP Address", "Bound User Groups") -NoFilter -Endpoint {
                $allServers | ForEach-Object {
                    if ($_.id -in $ServerDict.Keys) {
                        [PSCustomObject]@{
                            "Server Name"  = (New-UDLink -Text $_.name -Url "https://console.jumpcloud.com/#/radius/$($_._id)/details" -OpenInNewWindow);
                            "IP Address" = $_.networkSourceIp;
                            "Bound User Groups" = $ServerDict[$_.id].Length;
                        }
                    }
                    else{
                        [PSCustomObject]@{
                            "Server Name"  = (New-UDLink -Text $_.name -Url "https://console.jumpcloud.com/#/radius/$($_._id)/details" -OpenInNewWindow);
                            "IP Address" = $_.networkSourceIp;
                            "Bound User Groups" = 0;
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