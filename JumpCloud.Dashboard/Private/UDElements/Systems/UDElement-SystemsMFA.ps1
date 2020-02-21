function UDElement-SystemsMFA
{
    param (
        $refreshInterval,
        $lastContactDays,
        $unDrawColor
    )

    New-UDElement -Tag "SystemsMFA" -Id "SystemsMFA"  -RefreshInterval  $refreshInterval -AutoRefresh -Endpoint {

        $LegendOptions = New-UDChartLegendOptions -Position bottom
        $CircleChartOptions = New-UDLineChartOptions -LegendOptions $LegendOptions

        $Script:MFASystems = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | ? { $_.allowMultiFactorAuthentication }
        if ($MFASystems)
        {
            New-UDChart -Title "MFA Enabled Systems"  -Type Doughnut -AutoRefresh -RefreshInterval 60  -Endpoint {
                try
                {
                    Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object allowMultiFactorAuthentication | Select-object Count, Name | Out-UDChartData -DataProperty "Count" -LabelProperty "Name" -BackgroundColor @("#e54852", "#2cc692") -HoverBackgroundColor @("#e54852", "#2cc692")
                }
                catch
                {
                    0 | Out-UDChartData -DataProperty "Count" -LabelProperty "Name"
                }
            } -Options $CircleChartOptions -OnClick {
                if ($EventData -ne "[]")
                {
                    $TabNames = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Group-Object allowMultiFactorAuthentication | Select-object Name
                    Show-UDModal -Content {
                        New-UDTabContainer -Tabs {
                            foreach ($TabName in $TabNames)
                            {
                                New-UDTab -Text $TabName.Name -Content {
                                    $script:MFAEnabled = [System.Convert]::ToBoolean($TabName.Name)
                                    New-UDGrid -Header @("Hostname", "Operating System", "System ID") -Properties @("Hostname", "OS", "SystemID") -Endpoint {
                                        Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Where-Object { $_.allowMultiFactorAuthentication -eq $MFAEnabled } | ForEach-Object {
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
        else
        {
            New-UDCard -Title "MFA Enabled Systems" -Content {
                New-UDunDraw -Name "authentication" -Color $unDrawColor
                New-UDParagraph -Text "None of your systems have MFA enabled."
            }
        }
    }

   
}