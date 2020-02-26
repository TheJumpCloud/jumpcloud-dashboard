function UDElement-NewUsers ()
{
    param (
        [Parameter(Mandatory=$False)]
        $refreshInterval = 600,
        [Parameter(Mandatory =$False)]
        $unDrawColor = "#006cac"
    )

    New-UDElement -Tag "NewUsers" -Id "NewUsers" -RefreshInterval $refreshInterval -AutoRefresh -Endpoint {

        $Script:NewUsers = Get-JCUser -filterDateProperty created -dateFilter after  -date (Get-Date).AddDays(-14)
        if ($NewUsers)
        {
            New-UDGrid -Title "New Users (Created in the last 14 days)"  -Headers @("Username", "Activated", "Created") -Properties @("Username", "Activated", "Created") -NoFilter -Endpoint {
                $NewUsers | Sort-Object created -Descending | ForEach-Object {
                    [PSCustomObject]@{
                        Username  = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                        Activated = $(if ($_.activated) { New-UDIcon -Icon check } else { "" });
                        Created   = $_.created;
                    }
                } | Out-UDGridData
            } -NoExport
        }
        else
        {
            New-UDCard -Title "New Users (Created in the last 14 days)" -Content {
                New-UDunDraw -Name "add-user" -Color $unDrawColor
                New-UDParagraph -Text "No new users have been added to your JumpCloud Organization in the past 14 days."
            }
        }
    }
    
}