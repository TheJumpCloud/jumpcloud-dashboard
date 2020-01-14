Function 1Get-UDSystemUsers ()
{
    [CmdletBinding()]

    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        $lastContactDays
    )

    $PageText = 'Users'
    $PageName = 'SystemUsers'
    $PageLayout = '{"lg":[{"w":4,"h":9,"x":0,"y":0,"i":"grid-element-NewUsers"},{"w":4,"h":9,"x":4,"y":0,"i":"grid-element-UserState"},{"w":4,"h":9,"x":9,"y":0,"i":"grid-element-PrivilegedUsers"},{"w":4,"h":9,"x":0,"y":10,"i":"grid-element-MFAConfigured"},{"w":4,"h":9,"x":4,"y":10,"i":"grid-element-PasswordExpiration"},{"w":12,"h":4,"x":4,"y":20,"i":"grid-element-UsersDownload"}]}'

    $LegendOptions = New-UDChartLegendOptions -Position bottom
    $Options = New-UDLineChartOptions -LegendOptions $LegendOptions

    $UDPage = New-UDPage -Name:($PageName) -Content {


        New-UDCard -Title "Coming Soon" -Content {
            New-UDParagraph -Text "This is a prerelease of this module"

        }
    }
    $UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('Users')
    Return [PSCustomObject]@{
        'UDPage'        = $UDPage;
        'UDSideNavItem' = $UDSideNavItem;
    }
}