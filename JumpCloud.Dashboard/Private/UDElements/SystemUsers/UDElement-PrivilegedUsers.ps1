function UDElement-PriviledgedUsers ()
{
    param (
        $refreshInterval,
        $unDrawColor
    )
    New-UDElement -Tag "PrivilegedUsers" -Id "PrivilegedUsers" -RefreshInterval $refreshInterval -AutoRefresh -Endpoint {

        $PrivilegedUsers = @()

        $Sudo = Get-JCUser -sudo $true

        $PrivilegedUsers += $Sudo

        $SambaService = Get-JCUser -samba_service_user $true

        $PrivilegedUsers += $SambaService

        $LdapBinding = Get-JCUser -ldap_binding_user $true

        $PrivilegedUsers += $LdapBinding

        $script:UniquePrivilegedUsers = $PrivilegedUsers | Sort-Object username -Unique

        if ($UniquePrivilegedUsers)
        {

            New-UDGrid -Title "Privileged Users" -Properties @("Username", "GlobalAdmin", "LDAPBindUser", "SambaServiceUser") -NoFilter -Endpoint {


                $UniquePrivilegedUsers | ForEach-Object {
                    [PSCustomObject]@{
                        Username         = (New-UDLink -Text $_.username -Url "https://console.jumpcloud.com/#/users/$($_._id)/details" -OpenInNewWindow);
                        GlobalAdmin      = $(if ($_.sudo) { New-UDIcon -Icon check } else { "" });
                        LDAPBindUser     = $(if ($_.ldap_binding_user) { New-UDIcon -Icon check } else { "" });
                        SambaServiceUser = $(if ($_.samba_service_user) { New-UDIcon -Icon check } else { "" });
                    }
                } | Out-UDGridData
            } -NoExport

        }

        else
        {
            New-UDCard -Title "Privileged Users"  -Content {
                New-UDunDraw -Name "safe" -Color $unDrawColor
                New-UDParagraph -Text "None of your users are configured as Global Admin, LDAP Bind, or Samba Service users."
            }
        }
    }
}