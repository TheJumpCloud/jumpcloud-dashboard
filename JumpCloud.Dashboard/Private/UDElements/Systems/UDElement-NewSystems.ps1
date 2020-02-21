function UDElement-NewSystems
{
    param (
        $refreshInterval,
        $lastContactDays,
        $unDrawColor
    )


    New-UDElement -Tag "NewSystems" -Id "NewSystems"  -RefreshInterval  $refreshInterval -AutoRefresh -Endpoint {
                
        $Script:NewSystems = Get-JCSystem -filterDateProperty created -dateFilter after  -date (Get-Date).AddDays(-7)
        if ($NewSystems)
        {
            New-UDGrid -Title "New Systems (Created in the last 7 days)" -Properties @("Hostname", "OS", "Created") -Headers @("Hostname", "OS", "Created") -Endpoint {
                Get-JCSystem -filterDateProperty created -dateFilter after  -date (Get-Date).AddDays(-7) | Sort-Object created -Descending | ForEach-Object {
                    [PSCustomObject]@{
                        Hostname = (New-UDLink -Text $_.hostname -Url "https://console.jumpcloud.com/#/systems/$($_._id)/details" -OpenInNewWindow);
                        Created  = $_.created;
                        OS       = $_.os + " " + $_.version;
                    }
                } | Out-UDGridData
            } -NoExport
        }
        else
        {
            New-UDCard -Title "New Systems (Created in the last 7 days)" -Content {
                New-UDunDraw -Name "operating-system" -Color $unDrawColor
                New-UDParagraph -Text "No new systems have been added to your JumpCloud Organization in the past 7 days."
            }
        }
    }
   
}