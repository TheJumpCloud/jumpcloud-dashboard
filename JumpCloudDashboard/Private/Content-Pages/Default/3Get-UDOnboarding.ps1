Function 3Get-UDOnboarding () {
    $PageText = 'Onboarding'
    $PageName = 'Onboarding'

    $PageLayout = '{"lg":[{"w":4,"h":9,"x":0,"y":0,"i":"grid-element-UserActivation"},{"w":4,"h":9,"x":4,"y":0,"i":"grid-element-PasswordResets"},{"w":4,"h":9,"x":0,"y":10,"i":"grid-element-SystemUserAssociations"}]}'

    $UDPage = New-UDPage -Name:($PageName) -Content {
        New-UDGridLayout -Draggable -Resizable -Layout $PageLayout -Content {
            New-UDCard -Title "User Activation" -Id "UserActivation" -Content
        }
    }

    $UDSideNavItem = New-UDSideNavItem -Text:($PageText) -PageName:($PageName) -Icon:('Laptop')
    Return [PSCustomObject]@{
        'UDPage'        = $UDPage;
        'UDSideNavItem' = $UDSideNavItem;
    }
}