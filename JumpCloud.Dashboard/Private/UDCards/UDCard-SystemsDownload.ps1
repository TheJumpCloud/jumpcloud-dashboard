function UDCard-SystemsDownload
{
    param (
        $lastContactDays
    )

    New-UDCard -Horizontal -Title "Systems" -Id "SystemsDownload" -Content {
        $TotalSystems = Get-JCSystem -returnProperties hostname | Measure-Object | Select-Object -ExpandProperty Count
        $ShowingSystems = Get-SystemsWithLastContactWithinXDays -days $lastContactDays | Measure-Object | Select-Object -ExpandProperty Count

        New-UDParagraph -Text "Displaying information from systems that have checked in within the last $lastContactDays days. Displaying $ShowingSystems of $TotalSystems systems."
        New-UDButton -Icon 'cloud_download' -Text "Download All System Information" -OnClick {
            $DownloadsPath = '~' + '\' + 'Downloads'
            Set-Location $DownloadsPath
            Get-JCBackup -Systems
            Show-UDToast -Message "System Information Downloaded To CSV In Downloads" -Duration 10000;
        }
    }
    
}