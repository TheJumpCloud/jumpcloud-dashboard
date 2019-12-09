### Poorly optimized functions for making graphs

# Count policy success 
# $goodpolicy = 0
# $badpolicy = 0
# $r = (Get-JCPolicy | Select-Object -Property id)
# foreach ($i in $r) {
#     # Write-Output $i "adsfsdaf"
#     $k = (Get-JCPolicyResult -PolicyID $i.id)
    
#     if ($k.success -eq "True") {
#         $goodpolicy += 1
#     }
#     elseif ($_.success -eq "False") {
#         $badpolicy += 1
#     }
# }

## function?
function c_newchart {
    
    param (
        $c_name,
        $p_1 = 0,
        $p_2 = 0,
        $c_id

    )
    $c_r = (Get-JCPolicyResult -ByPolicyID $c_id)
     foreach ($i in $c_r) {
    #     # Write-Output $i "adsfsdaf"
    # $k = (Get-JCPolicyResult -PolicyID $i.id)

    if ($i.success -eq "True") {
        $p_1 += 1
    }
    elseif ($i.success -eq "False") {
        $p2 += 1
        }
    }
    $total = $p_1 + $p_2
New-UDColumn -size 3 {
    New-UDChart -Title "$c_name : on $total systems " -Type Doughnut -Endpoint {
        $ph = (0, 0)
        $ph[1] = $p_1
        $ph[0] = $p_2

        $hash = [ordered]@{"Successful" = $ph[1]; "Unsuccessful" = $ph[0] }

        $hash | Out-UdChartData -DataProperty "Values" -BackgroundColor @("#803AE8CE", "#80962F23") -LabelProperty "Keys"
    } -Options @{
        legend = @{
            display  = $true;
            position = 'right'
            labels   = @{
                # fontColor = '#000000'; 
                # fontSize  = 16
            }
        }       
    }
}
}


###
Function 3Get-UDPolicies ()
{
    $PageText = 'Policies'
    $PageName = 'Policies'
    $UDPage = New-UDPage -Name:($PageName) -Content {
        New-UDRow {
            New-UDColumn -size 12{

                New-UDGrid -Title "Active Policies" -Properties @("Name", "Count") -Endpoint {
                    Get-JCPolicy | Select-object  Name | ForEach-Object {
                        [PSCustomObject]@{
                            "Policy Name"  = $_.Name;
                        }
                    } | Out-UDGridData
                }

                $LegendOptions = New-UDChartLegendOptions -Position bottom
                $Options = New-UDLineChartOptions -LegendOptions $LegendOptions

                $testing = (Get-JCPolicy | Select-Object -Property name, id)
                $cnt = 0
                foreach ($p in $testing) {
                    $cnt += 1
                    if ($cnt -notmatch 4) {
                        c_newchart $p.name 0 0 $p.id 
                    }
                    elseif ($cnt -eq 4) {
                        New-UDRow{
                            c_newchart $p.name 0 0 $p.id
                        }
                    }

                }
            }
        }
    }
    $UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('shield_alt')
    Return [PSCustomObject]@{
        'UDPage'        = $UDPage;
        'UDSideNavItem' = $UDSideNavItem;
    }
}