Function Get-UDSystemInsights()
{
    $Tables = (Get-Command 'Get-JCSysteminsights').Parameters.Table.Attributes.ValidValues | Sort-Object
    $UDPage = @()
    $UDSideNavItems = @()
    $Tables | ForEach-Object {
        $Table = $_
        $UDPage += New-UDPage -Name:($Table) -ArgumentList:(@($Table)) -Endpoint {
            #region Loading Indicator
            $Session:DoneLoading = $false
            New-UDRow -Columns {
                New-UDColumn -Endpoint {
                    New-UDElement -Id 'LoadingMessage' -Tag div -Endpoint {
                        if ($Session:DoneLoading -ne $true)
                        {
                            New-UDHeading -Text "Loading...Please wait..." -Size 5
                            New-UDPreloader -Circular
                        }
                    }
                }
            }
            #endregion

            New-UDColumn -Endpoint {
                $SystemInsights = Get-JCSystemInsights -Table:($Table)
                If (-not [System.String]::IsNullOrEmpty($SystemInsights))
                {
                    $Properties = ($SystemInsights | Get-Member -MemberType:('NoteProperty')) | Where-Object { $_.Name -notin ('ById', 'ByName', 'httpMetaData', 'table', 'TargetPlural', 'Targets', 'TargetSingular', 'type', 'TypeName', 'TypeNamePlural', 'TypeNameSingular') } | Select-Object -Unique -Property:('Name')
                    New-UDGrid -Title:($Table) -Headers @($Properties.Name) -Properties @($Properties.Name) -ArgumentList:($SystemInsights) -Endpoint {
                        $ArgumentList[0] | ForEach-Object { $_ | Select-Object -Property:(@{Name = 'system_id'; Expression = { New-UDLink -Text:($_.system_id) -Url:("https://console.jumpcloud.com/#/systems/$($_.system_id)/details") -OpenInNewWindow } }, '*') -ExcludeProperty:('system_id') } | Out-UDGridData
                    }
                }
                Else
                {
                    New-UDCard -Title:($Table) -Text:('No data available for ' + $Table + '.')
                }


                # Remove the Loading Indicator
                $Session:DoneLoading = $true
                Sync-UDElement -Id 'LoadingMessage' -Broadcast
            }
        }
        $UDSideNavItems += New-UDSideNavItem -Text:($_) -PageName:($_)
    }
    $UDSideNavItem = New-UDSideNavItem -Text:('SystemInsights') -Children { $UDSideNavItems } -Icon:('Database')



    Return [PSCustomObject]@{
        'UDPage'        = $UDPage;
        'UDSideNavItem' = $UDSideNavItem;
    }
}