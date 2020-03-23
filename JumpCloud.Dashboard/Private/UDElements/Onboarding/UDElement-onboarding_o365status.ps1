function UDElement-onboarding_0365Status {
    param (
        $refreshInterval,
        $lastContactDays,
        $unDrawColor
    )

    $Users = Get-JCUser
    # 1. Get the id of the resource you want
    # 2. Assign to a variabl
    $Selected = Get-JCAssociation -Type ldap_server -Id 5d643a7745886d6f626593b7 -TargetType User

    New-UDElement -Tag "onboarding_0365status" -Id "onboarding_0365status"  -RefreshInterval  $refreshInterval -AutoRefresh -Content {

        $LegendOptions = New-UDChartLegendOptions -Position bottom
        $CircleChartOptions = New-UDLineChartOptions -LegendOptions $LegendOptions

        New-UDChart -Title "onboarding_0365status" -Type Doughnut -AutoRefresh -RefreshInterval $refreshInterval  -Endpoint {
            try {
                # $Cache:DisplaySystems | Group-Object -Property os | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor @("#2cc692", "#ffb000", "#006cac", "#e54852", "#9080e0") -HoverBackgroundColor @("#2cc692", "#ffb000", "#006cac", "#e54852", "#9080e0")
                $Selected | Group-Object -Property Name | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor @("#2cc692", "#ffb000", "#006cac", "#e54852", "#9080e0") -HoverBackgroundColor @("#2cc692", "#ffb000", "#006cac", "#e54852", "#9080e0")

            }
            catch {
                0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
            }
        } -Options $CircleChartOptions -OnClick {
            if ($EventData -ne "[]") {
                $TabNames = $Cache:DisplaySystems | Group-Object -Property os | Select-object Name
                Show-UDModal -Content {
                    New-UDTabContainer -Tabs {
                        foreach ($TabName in $TabNames) {
                            New-UDTab -Text $TabName.Name -Content {
                                $script:OSType = $TabName.Name
                                New-UDGrid -Header @("Hostname", "Operating System", "System ID") -Properties @("Hostname", "OS", "SystemID") -Endpoint {
                                    $Cache:DisplaySystems | Where-Object { $_.os -eq $OSType } | ForEach-Object {
                                        [PSCustomObject]@{
                                            Hostname = $_.hostname;
                                            OS       = $_.os + " " + $_.version;
                                            SystemID = $_._id;
                                        }
                                    } | Out-UDGridData
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}