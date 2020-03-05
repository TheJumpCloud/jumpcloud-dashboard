function UDCard-SystemsDownload
{
    param (
        $lastContactDays
    )

    New-UDCard -Horizontal -Title "Systems" -Id "SystemsDownload" -Content {

        $ContentType = "application/json"
        $URL = 'https://console.jumpcloud.com/api/systems?limit=1&skip=0'
        $systemInfo = Invoke-RestMethod  -Method Get -Uri $URL -Header @{ "X-Api-Key" = $JCAPIKEY } -ContentType $ContentType
        $TotalSystems = $systemInfo.totalCount
        $ShowingSystems = $Cache:DisplaySystems | Measure-Object | Select-Object -ExpandProperty Count
        New-UDParagraph -Text "Displaying information from systems that have checked in within the last $lastContactDays days. Displaying $ShowingSystems of $TotalSystems systems."
        New-UDButton -Icon 'cloud_download' -Text "Download All System Information" -OnClick {
            $DownloadsPath = '~' + '\' + 'Downloads'
            Set-Location $DownloadsPath
            Get-JCBackup -Systems
            Show-UDToast -Message "System Information Downloaded To CSV In Downloads" -Duration 10000;
        }
    }
}