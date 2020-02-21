
function UDCard-UsersDownload ()
{
    param (

    )

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


}


