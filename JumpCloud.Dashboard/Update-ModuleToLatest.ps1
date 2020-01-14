Function Update-ModuleToLatest
{
    Param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Specify the names of the modules which to update.')][System.String[]]$ModuleName
        , [Parameter(HelpMessage = 'ByPasses user prompts.')][Switch]$Force
    )
    Try
    {
        $ModuleInfo = $ModuleName | ForEach-Object {
            [PSCustomObject]@{
                PSGallery      = Find-Module -Name:($_) -Repository:LocalRepository
                LocalInstalled = Get-InstalledModule -Name:($_) -AllVersions -ErrorAction:('Ignore') | Sort-Object -Property:('Version') | Select-Object -Last 1
                LocalImported  = Get-Module -Name:($_) -All -ErrorAction:('Ignore') | Sort-Object -Property:('Version') | Select-Object -Last 1
            }
        }
        If (-not [System.String]::IsNullOrEmpty($ModuleInfo))
        {
            ForEach ($ModuleData In $ModuleInfo)
            {
                If (-not [System.String]::IsNullOrEmpty($ModuleData.LocalInstalled))
                {
                    If ($ModuleData.PSGallery.Version -gt $ModuleData.LocalInstalled.Version)
                    {

                        $WelcomePage = New-Object -TypeName:('PSCustomObject') | Select-Object `
                        @{Name = 'STATUS'; Expression = { 'An update is available for the "' + $ModuleData.PSGallery.Name + '" PowerShell module.' } } `
                            , @{Name = 'INSTALLED VERSION'; Expression = { $ModuleData.LocalInstalled.Version } } `
                            , @{Name = 'LATEST VERSION'; Expression = { $ModuleData.PSGallery.Version + ' (' + (Get-Date $ModuleData.PSGallery.PublishedDate).ToString('MMMM dd, yyyy') + ')' } } `
                            , @{Name = 'RELEASE NOTES'; Expression = { $ModuleData.PSGallery.ReleaseNotes } } `

                        # Display message
                        $WelcomePage.PSObject.Properties.Name | ForEach-Object {
                            If (-not [System.String]::IsNullOrEmpty($WelcomePage.($_)))
                            {
                                Write-Host (($_) + ': ') -BackgroundColor:('Black') -ForegroundColor:('Magenta')
                                $WelcomePage.($_).Trim() -split ("`n") | ForEach-Object {
                                    If (-not [System.String]::IsNullOrEmpty(($_)))
                                    {
                                        Write-Host ('    + ') -BackgroundColor:('Black') -ForegroundColor:('Gray') -NoNewline
                                        If (($_) -like '*http*' -or ($_) -like '*www.*' -or ($_) -like '*.com*')
                                        {
                                            Write-Host (($_).Trim())-BackgroundColor:('Black') -ForegroundColor:('Blue')
                                        }
                                        ElseIf (($_) -like '*!!!*')
                                        {
                                            Write-Host (($_).Replace('!!!', '').Trim())-BackgroundColor:('Black') -ForegroundColor:('Red')
                                        }
                                        Else
                                        {
                                            Write-Host (($_).Trim())-BackgroundColor:('Black') -ForegroundColor:('Green')
                                        }
                                    }
                                }
                            }
                        }
                        # Ask user if they want to update the module
                        If (!($Force))
                        {
                            Do
                            {
                                Write-Host ('Would you like to update the "' + $ModuleData.PSGallery.Name + '" PowerShell module to the latest version? [Y/N]:') -BackgroundColor:('Black') -ForegroundColor:('Yellow') -NoNewline
                                $UserInput = Read-Host
                            }
                            Until ($UserInput.ToUpper() -in ('Y', 'N'))
                        }
                        If ($UserInput.ToUpper() -eq 'Y' -or $Force)
                        {
                            # Remove existing module from the session
                            If (-not [System.String]::IsNullOrEmpty($ModuleData.LocalImported.Name))
                            {
                                Remove-Module -Name:($ModuleData.LocalImported.Name) -Force
                            }
                            # If (-not [System.String]::IsNullOrEmpty($ModuleData.LocalInstalled.Name))
                            # {
                            #     Uninstall-Module -Name:($ModuleData.LocalInstalled.Name) -AllVersions -Force
                            # }
                            Write-Host ('Updating "' + $ModuleData.PSGallery.Name + '" PowerShell module to version: ' + $ModuleData.PSGallery.Version) -BackgroundColor:('Black') -ForegroundColor:('Gray')
                            Update-Module -Force -Name:($ModuleData.PSGallery.Name)
                            Import-Module -Name:($ModuleData.PSGallery.Name) -RequiredVersion:($ModuleData.PSGallery.Version) -Force -Scope:('Global')
                        }
                        Else
                        {
                            Write-Host ('Exiting the ' + $ModuleName + ' PowerShell module update process.') -BackgroundColor:('Black') -ForegroundColor:('Gray')
                        }
                    }
                    # Else
                    # {
                    #     Write-Host ('The "' + $ModuleData.PSGallery.Name + '" PowerShell module is up to date.')
                    # }
                }
                Else
                {
                    Install-Module -Name:($ModuleData.PSGallery.Name) -Force -Repository:LocalRepository
                }
            }
        }
        Else
        {
            Write-Error ('Modules not found!')
        }
    }
    Catch
    {
        Write-Error ($_)
    }
}