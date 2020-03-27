function UDElement-onboarding_systemuserassociations ()
{
    param (
        $refreshInterval,
        $lastContactDays,
        $unDrawColor
    )

    $AllResults = $Cache:DisplaySystems | Select-Object _id

    # foreach ($result in $AllResults)
    # {
    #     Get-JCAssociation -Type system -Id $result._id -TargetType user
    #     Write-Output $result._id
    #     $count ++
    # }
    # ####
    # $busers = foreach ($result in $AllResults)
    # {
    #     Get-JCSystemUser -SystemID $result._id
    # }
    # $busers | Group-Object -Property HostName | Group-Object -Property Count| Select-Object Name, Count

    New-UDElement -Tag "onboarding_systemuserassociations" -Id "onboarding_systemuserassociations"  -RefreshInterval $refreshInterval -AutoRefresh -Content {

        $LegendOptions = New-UDChartLegendOptions -Position bottom
        $CircleChartOptions = New-UDLineChartOptions -LegendOptions $LegendOptions

        New-UDChart -Title "System User Associations"  -Type Bar -AutoRefresh -RefreshInterval $refreshInterval  -Endpoint {
            try
            {
                $Cache:DisplayUsers | Group-Object activated | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor @("#e54852", "#2cc692") -HoverBackgroundColor @("#e54852", "#2cc692")
            }
            catch
            {
                0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
            }
        } -Options $CircleChartOptions -OnClick {
            if ($EventData -ne "[]")
            {
                $TabNames = $Cache:DisplayUsers | Group-Object activated | Select-object Name
                Show-UDModal -Content {
                    New-UDTabContainer -Tabs {
                        foreach ($TabName in $TabNames)
                        {
                            New-UDTab -Text $TabName.Name -Content {
                                $script:systemuserassociations = [System.Convert]::ToBoolean($TabName.Name)
                                New-UDGrid -Header @("Username", "Activated", "UserID") -Properties @("Username", "Activated", "UserID") -Endpoint {
                                    $Cache:DisplayUsers |  Where-Object { $_.activated -eq $systemuserassociations } | ForEach-Object {
                                        [PSCustomObject]@{
                                            Username = $_.Username;
                                            Activated = $_.activated;
                                            UserID = $_._id;
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