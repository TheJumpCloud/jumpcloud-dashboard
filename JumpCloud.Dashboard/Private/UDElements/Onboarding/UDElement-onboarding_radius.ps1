function UDElement-onboarding_radius() {
    param (
        $refreshInterval,
        $unDrawColor
    )

    $ServerHash = New-Object System.Collections.Specialized.OrderedDictionary

    $rServers = Get-JCRadiusServer | Get-JCAssociation
    foreach ($server in $rServers) {
        if ($ServerHash -notcontains ($server.id)) {
            $ServerHash[$server.id] += @($server.targetID)
        }
        else {
            $ServerHash.Add($server.id, @($server.targetID))
        }
    }
    # return $ServerHash

    New-UDElement -Tag "onboarding_radius" -Id "onboarding_radius" -Endpoint {

        # if ($ServerHash) {
        New-UDGrid -Title "Radius Servers"  -Headers @("Server ID", "Bound Groups") -Properties @("Server ID", "Bound Groups") -NoFilter -Endpoint {
            # write-output $ServerHash.Length
            $ServerHash.Keys | ForEach-Object {
                # $listArray = @()
                # foreach ($grp in $ServerHash[$_]) {
                #     $listArray += (New-UDLink -Text $grp -Url "https://console.jumpcloud.com/#/groups/users/$grp/details" -OpenInNewWindow)
                # }
                [PSCustomObject]@{
                    "Server ID" = $_;
                    "Bound Groups" = $ServerHash[$_];
                }
                # # Write-Output $item
                # Write-Output "Server: " $_
                # Write-Output "Groups: " $ServerHash[$_]
            } | Out-UDGridData
            # $ServerHash | ForEach-Object {
            #         [PSCustomObject]@{
            #             Key = $ServerHash[$_]
            #         }
            #     } | Out-UDGridData
            # } -NoExport
        # }
        # else {
        #     New-UDCard -Title "New Users (Created in the last 14 days)" -Content {
        #         New-UDunDraw -Name "add-user" -Color $unDrawColor
        #         New-UDParagraph -Text "No new users have been added to your JumpCloud Organization in the past 14 days."
        #     }
        # }
    }
    }
}