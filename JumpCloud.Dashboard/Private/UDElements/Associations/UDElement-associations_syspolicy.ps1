function UDElement-associations_syspolicy() {
    param (
        $refreshInterval,
        $unDrawColor
    )

    $p = Get-JCPolicy
    $spa = $p | Get-JCAssociation -Type policy -TargetType system
    $sgpa = $p | Get-JCAssociation -Type policy -TargetType system_group
    New-UDElement -Tag "associations_syspolicy" -Id "associations_syspolicy" -Endpoint {
        if ($p) {
            New-UDGrid -Title "Policy Associations"  -Headers @("Policy Name", "Bound Systems", "Bound Groups") -Properties @("Policy Name", "Bound Systems", "Bound Groups") -NoFilter -Endpoint {
                $p | ForEach-Object {
                    $sysCount = 0
                    $grpCount = 0
                    for ($i = 0; $i -le $spa.Length; $i++) {
                        if ($spa[$i].id -eq $_.id) {
                            $sysCount += $spa[$i].paths.Length
                        }
                    }
                    for ($k = 0; $k -le $sgpa.Length; $k++) {
                        if ($sgpa[$k].id -eq $_.id) {
                            $grpCount += $sgpa[$k].paths.Length
                        }
                    }
                    [PSCustomObject]@{
                        "Policy Name"   = (New-UDLink -Text $_.name -Url "https://console.jumpcloud.com/#/policies/$($_.id)/details" -OpenInNewWindow);
                        "Bound Systems" = $sysCount;
                        "Bound Groups" = $grpCount;
                    }

                } | Out-UDGridData
            } -NoExport
        }
        else {
            New-UDCard -Title "Policy Associations" -Content {
                New-UDunDraw -Name "real-time-sync" -Color $unDrawColor
                New-UDParagraph -Text "You have not configured any system policies."
            }
        }
    }
}