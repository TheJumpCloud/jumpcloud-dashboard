function UDElement-associations_gsuite()
{
    param (
        $refreshInterval,
        $unDrawColor
    )

    $Users = Get-JCUser
    $Selected = Get-JCAssociation -Type g_suite -Name "G Suite" -TargetType User | Select-Object targetId
    $AllResults = @()
    $Users | ForEach-Object {
        $usrObject = [PSCustomObject]@{
            ID   = $_.id
            Dir  = ''
            Name = $_.username
        }
        if ($Selected.targetId -eq $_.id)
        {
            $usrObject.Dir = "Bound"
        }
        else
        {
            $usrObject.Dir = "Not Bound"
        }
        $AllResults += $usrObject
    }


    New-UDElement -Tag "associations_gsuite" -Id "associations_gsuite"  -RefreshInterval  $refreshInterval -AutoRefresh -Content {
        if ($Selected)
        {
            $LegendOptions = New-UDChartLegendOptions -Position bottom
            $CircleChartOptions = New-UDLineChartOptions -LegendOptions $LegendOptions
            New-UDChart -Title "G Suite Binding Status" -Type Doughnut -AutoRefresh -RefreshInterval $refreshInterval  -Endpoint {
                try
                {
                    # $Cache:DisplaySystems | Group-Object -Property os | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor @("#2cc692", "#ffb000", "#006cac", "#e54852", "#9080e0") -HoverBackgroundColor @("#2cc692", "#ffb000", "#006cac", "#e54852", "#9080e0")
                    $AllResults | Group-Object -Property Dir | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor @("#e54852", "#2cc692") -HoverBackgroundColor @("#e54852", "#2cc692")
                }
                catch
                {
                    0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                }
            } -Options $CircleChartOptions -OnClick {
                if ($EventData -ne "[]")
                {
                    $TabNames = $AllResults | Group-Object -Property Dir | Select-object Name
                    Show-UDModal -Content {
                        New-UDTabContainer -Tabs {
                            foreach ($TabName in $TabNames)
                            {
                                New-UDTab -Text $TabName.Name -Content {
                                    $script:DirType = $TabName.Name
                                    New-UDGrid -Header @("Username", "Directory Binding Status", "User ID") -Properties @("Name", "Dir", "ID") -Endpoint {
                                        $AllResults | Where-Object { $_.Dir -eq $DirType } | ForEach-Object {
                                            [PSCustomObject]@{
                                                Name = $_.Name
                                                Dir  = $_.Dir
                                                ID   = $_.ID;
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
        else
        {
            New-UDCard -Title "G Suite Binding Status" -Content {
                New-UDunDraw -Name "add-user" -Color $unDrawColor
                New-UDParagraph -Text "No G Suite users have been bound"
            }
        }
    }
}