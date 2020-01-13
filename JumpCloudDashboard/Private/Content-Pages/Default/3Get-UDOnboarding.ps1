Function 3Get-UDOnboarding () {
    $PageText = 'Onboarding'
    $PageName = 'Onboarding'

    $PageLayout = '{"lg":[{"w":4,"h":9,"x":0,"y":0,"i":"grid-element-MFAConfigured"},{"w":4,"h":9,"x":4,"y":0,"i":"grid-element-PrivilegedUsers"},{"w":4,"h":9,"x":0,"y":10,"i":"grid-element-UserStateInformation"},{"w":4,"h":9,"x":4,"y":10,"i":"grid-element-NewUsers"}]}'

    $UDPage = New-UDPage -Name:($PageName) -Content {
    }
    $UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('Laptop')
    Return [PSCustomObject]@{
        'UDPage'        = $UDPage;
        'UDSideNavItem' = $UDSideNavItem;
    }
}