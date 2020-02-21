Function 1Get-UDSystemUsers ()
{
    [CmdletBinding()]

    param (

        [Parameter(ValueFromPipelineByPropertyName)]
        $refreshInterval
    )

    $PageText = 'Users'
    $PageName = 'SystemUsers'

    $UDPage = New-UDPage -Name:($PageName) -Content {
        
        [int]$refreshInterval = $refreshInterval

        $PageLayout = '{"lg":[{"w":12,"h":3,"x":0,"y":0,"i":"grid-element-UsersDownload"},{"w":4,"h":10,"x":0,"y":4,"i":"grid-element-NewUsers"},{"w":4,"h":10,"x":4,"y":4,"i":"grid-element-UserState"},{"w":4,"h":10,"x":9,"y":4,"i":"grid-element-PrivilegedUsers"},{"w":4,"h":10,"x":0,"y":15,"i":"grid-element-MFAConfigured"},{"w":4,"h":10,"x":4,"y":15,"i":"grid-element-PasswordExpiration"},{"w":4,"h":10,"x":9,"y":15,"i":"grid-element-PasswordChanges"}]}'
        $unDrawColor = "#006cac"

        $LegendOptions = New-UDChartLegendOptions -Position bottom
        $Options = New-UDLineChartOptions -LegendOptions $LegendOptions

        New-UDCard -Title "Users" -Id "UsersDownload" -Content {
            $TotalUsers = Get-JCUser -returnProperties username | Measure-Object | Select-Object -ExpandProperty Count

            New-UDParagraph -Text "Displaying information from all users in your JumpCloud Organization. Displaying $TotalUsers users."
            New-UDButton -Icon 'cloud_download' -Text "Download All User Information" -OnClick {
                $DownloadsPath = '~' + '\' + 'Downloads'
                Set-Location $DownloadsPath
                Get-JCBackup -Users
                Show-UDToast -Message "User Information Downloaded To CSV In Downloads" -Duration 10000;
            }
        }

        New-UDGridLayout -Layout $PageLayout -Content {

            # Functions defining elements can be found in the /Private/UDElements/SytemUsers folder
            
            UDElement-NewUsers -refreshInterval $refreshInterval

            UDElement-UserState -refreshInterval $refreshInterval

            UDElement-PriviledgedUsers -refreshInterval $refreshInterval

            UDElement-MFAConfigured -refreshInterval $refreshInterval

            UDElement-PasswordExpiration -refreshInterval $refreshInterval

            UDElement-PasswordChanges -refreshInterval $refreshInterval

        }
    }

    #$UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('Users')
    Return [PSCustomObject]@{
        'UDPage' = $UDPage;
        #    'UDSideNavItem' = $UDSideNavItem;
    }

}