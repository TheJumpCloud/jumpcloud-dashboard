Function 3Get-UDLayout ()
{
    $PageText = 'Layout'
    $PageName = 'Layout'

    $UDPage = New-UDPage -Name:($PageName) -Content {
        New-UDRow {


            New-UDRow {
                New-UDColumn -Size 12 -Content {
                
               
                    New-UDCollapsible -Popout -Id "Collapsible" -Items {
    
                        New-UDCollapsibleItem -Title "View Details" -Icon table -Content {
        
                            $Systems = Get-SystemsWithLastContactWithinXDays -days 365
                            #$Properties = $('displayName', 'os', '_id')
                            $Properties = ($Systems | Get-Member -MemberType:('NoteProperty') | Where-Object { $_.Name -notin ('connectionHistory', 'networkInterfaces', 'sshdParams', 'systemInsights') } | Select-Object -Unique -Property:('Name'))
                            New-UDGrid  -Headers @($Properties.name) -Properties @($Properties.name) -ArgumentList:($Systems) -Endpoint {
                                Get-SystemsWithLastContactWithinXDays -days 365 | Out-UDGridData
                            }
                            
                        }
                
                    }
                 
    
                }
            }
            New-UDColumn -Size 12 -Content {
                
               
                New-UDCollapsible -Id "Collapsible" -Items {

                    New-UDCollapsibleItem -Title "View Details" -Icon table -Content {
    
                        $Systems = Get-SystemsWithLastContactWithinXDays -days 365
                        #$Properties = $('displayName', 'os', '_id')
                        $Properties = ($Systems | Get-Member -MemberType:('NoteProperty') | Where-Object { $_.Name -notin ('connectionHistory', 'networkInterfaces', 'sshdParams', 'systemInsights') } | Select-Object -Unique -Property:('Name'))
                        New-UDGrid  -Headers @($Properties.name) -Properties @($Properties.name) -ArgumentList:($Systems) -Endpoint {
                            Get-SystemsWithLastContactWithinXDays -days 365 | Out-UDGridData
                        }
                        
                    }
            
                }
             

            }
            New-UDColumn -Size 4 -Content {
                New-UDCard -Title "Details" -Text "These are some details about my dashboard" -Links @(New-UDLink -Url http://www.google.com -Text "Google a little more info")

                New-UDCollapsible -Id "Collapsible" -Items {
                    New-UDCollapsibleItem -Title "Report" -Icon table -Content {
                        New-UDCard -Title "First"
                    }
                    New-UDCollapsibleItem -Title "Second" -Icon group -Content {
                        New-UDCard -Title "Second"
                    }
                    New-UDCollapsibleItem -Title "Third" -Icon user -Content {
                        New-UDCard -Title "Third"
                    }
                }

 
            }
            New-UDColumn -Size 4 -Content {
                New-UDCard -Title "Details" -Text "These are some details about my dashboard" -Links @(New-UDLink -Url http://www.google.com -Text "Google a little more info")
            }

        }

        # New-UDRow {

        #     New-UDColumn -Endpoint {
                
        #         $Systems = Get-SystemsWithLastContactWithinXDays -days 365
        #         $Properties = ($Systems | Get-Member -MemberType:('NoteProperty') | Where-Object { $_.Name -notin ('connectionHistory', 'networkInterfaces', 'sshdParams', 'systemInsights') } | Select-Object -Unique -Property:('Name'))
        #         New-UDGrid -Title:("Systems") -Headers @($Properties.Name) -Properties @($Properties.Name) -ArgumentList:($Systems) -Endpoint {
        #             Get-SystemsWithLastContactWithinXDays -days 365 | Out-UDGridData
        #         }

        #     }
        # }
    }

    $UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('Laptop')
    Return [PSCustomObject]@{
        'UDPage'        = $UDPage;
        'UDSideNavItem' = $UDSideNavItem;
    }
}