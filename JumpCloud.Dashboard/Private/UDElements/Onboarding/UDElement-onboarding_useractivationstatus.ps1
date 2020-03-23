function UDElement-onboarding_userActivationStatus ()
{
    param (
        $refreshInterval,
        $lastContactDays,
        $unDrawColor
    )

    New-UDElement -Tag "useractivationstatus" -Id "useractivationstatus"  -RefreshInterval $refreshInterval -AutoRefresh -Content {

        $LegendOptions = New-UDChartLegendOptions -Position bottom
        $CircleChartOptions = New-UDLineChartOptions -LegendOptions $LegendOptions

        New-UDChart -Title "User Activation Status"  -Type Doughnut -AutoRefresh -RefreshInterval $refreshInterval  -Endpoint {
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
                                $script:UserActivateEnabled = [System.Convert]::ToBoolean($TabName.Name)
                                New-UDGrid -Header @("Username", "Activated", "UserID") -Properties @("Username", "Activated", "UserID") -Endpoint {
                                    $Cache:DisplayUsers |  Where-Object { $_.activated -eq $UserActivateEnabled } | ForEach-Object {
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