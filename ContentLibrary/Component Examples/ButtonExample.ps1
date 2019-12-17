New-UDGrid -Title "Locked Out Users" -AutoRefresh -RefreshInterval 1 -Properties @("Username", "Email", "Unlock") -Endpoint {
    Get-JCUser -account_locked $true | ForEach-Object {
        [PSCustomObject]@{
            Username = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_.id)/details" -OpenInNewWindow);
            Email    = $_.email;
            Unlock   = (New-UDButton -Text "Unlock" -OnClick {
                    Set-JCUser $_.username -account_locked $false;
                    Show-UDToast -Message "User $($_.username) is unlocked!";
                });
        }
    } | Out-UDGridData
}