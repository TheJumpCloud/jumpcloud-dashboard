Function 2Get-UDSystems () {
    [CmdletBinding()]

    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        $lastContactDays
    )

    $PageText = 'Systems'
    $PageName = 'Systems'
    $PageLayout = '{"lg":[{"w":4,"h":9,"x":0,"y":0,"i":"grid-element-OS"},{"w":4,"h":9,"x":4,"y":0,"i":"grid-element-SystemsMFA"},{"w":4,"h":9,"x":9,"y":0,"i":"grid-element-NewSystems"},{"w":4,"h":9,"x":0,"y":10,"i":"grid-element-AgentVersion"},{"w":4,"h":9,"x":4,"y":10,"i":"grid-element-OSVersion"},{"w":4,"h":9,"x":9,"y":10,"i":"grid-element-LastContact"},{"w":12,"h":4,"x":4,"y":20,"i":"grid-element-SystemsDownload"}]}'



    $UDPage = New-UDPage -Name:($PageName) -Content {
        
        New-UDCard -Title "Coming Soon" -Content {
            New-UDParagraph -Text "This is a prerelease of this module"

        }
    }

    $UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('Laptop')
    Return [PSCustomObject]@{
        'UDPage'        = $UDPage;
        'UDSideNavItem' = $UDSideNavItem;
    }
}
