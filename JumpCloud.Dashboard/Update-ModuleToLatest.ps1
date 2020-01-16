Function Update-ModuleToLatest
{
    Param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Specify the names of the modules which to update.')][System.String[]]$Name
        , [Parameter(HelpMessage = 'ByPasses user prompts.')][Switch]$Force
    )
    Try
    {
        $ModuleInfo = $Name | ForEach-Object {
            [PSCustomObject]@{
                PSGallery      = Find-Module -Name:($_) -AllowPrerelease
                LocalInstalled = Get-InstalledModule -Name:($_) -AllVersions -ErrorAction:('Ignore') | Sort-Object -Property:('Version')
                LocalImported  = Get-Module -Name:($_) -All -ErrorAction:('Ignore') | Sort-Object -Property:('Version') | Select-Object -Last 1
            }
        }
        If (-not [System.String]::IsNullOrEmpty($ModuleInfo))
        {
            ForEach ($ModuleData In $ModuleInfo)
            {
                If (-not [System.String]::IsNullOrEmpty($ModuleData.LocalInstalled))
                {
                    If ($ModuleData.PSGallery.Version -gt ($ModuleData.LocalInstalled | Measure-Object -Property:('Version') -Maximum).Maximum)
                    {

                        $WelcomePage = New-Object -TypeName:('PSCustomObject') | Select-Object `
                        @{Name = 'STATUS'; Expression = { 'An update is available for the "' + $ModuleData.PSGallery.Name + '" PowerShell module.' } } `
                            , @{Name = 'INSTALLED VERSION(S)'; Expression = { $ModuleData.LocalInstalled | ForEach-Object { $_.Version + ' (' + (Get-Date $_.PublishedDate).ToString('MMMM dd, yyyy') + ')' } } } `
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
                                        If (($_) -like '*!!!*')
                                        {
                                            Write-Host (($_).Replace('!!!', '').Trim())-BackgroundColor:('Black') -ForegroundColor:('Red')
                                        }
                                        ElseIf (($_) -like '*http*' -or ($_) -like '*www.*' -or ($_) -like '*.com*')
                                        {
                                            Write-Host (($_).Trim())-BackgroundColor:('Black') -ForegroundColor:('Blue')
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
                        If ($Force -eq $false)
                        {
                            Do
                            {
                                Write-Host ('Would you like to update the "' + $ModuleData.PSGallery.Name + '" PowerShell module to the latest version? [Y/N]:') -BackgroundColor:('Black') -ForegroundColor:('Yellow') -NoNewline
                                $UserInput = (Read-Host).ToUpper()
                            }
                            Until ($UserInput -in ('Y', 'N'))
                        }
                        If ($UserInput -eq 'Y' -or $Force -eq $true)
                        {
                            # Remove existing module from the session
                            If (-not [System.String]::IsNullOrEmpty($ModuleData.LocalImported.Name))
                            {
                                Write-Verbose ('Removing "' + $ModuleData.LocalImported.Name + '" PowerShell module ' + ($ModuleData.LocalImported.Version -join ', ') + ' from session.') #-BackgroundColor:('Black') -ForegroundColor:('Gray')
                                Remove-Module -Name:($ModuleData.LocalImported.Name) -Force
                            }
                            If (-not [System.String]::IsNullOrEmpty($ModuleData.LocalInstalled.Name))
                            {
                                Write-Verbose ('Uninstalling "' + ($ModuleData.LocalInstalled.Name | Select-Object -Unique) + '" PowerShell module ' + ($ModuleData.LocalInstalled.Version -join ', ')) #-BackgroundColor:('Black') -ForegroundColor:('Gray')
                                Uninstall-Module -Name:($ModuleData.LocalInstalled.Name) -AllVersions -Force
                            }
                            Write-Verbose ('Installing "' + $ModuleData.PSGallery.Name + ' - ' + $ModuleData.PSGallery.Version + '" PowerShell module.') #-BackgroundColor:('Black') -ForegroundColor:('Gray')
                            Install-Module -Name:($ModuleData.PSGallery.Name) -Force -AllowPrerelease
                            Import-Module -Name:($ModuleData.PSGallery.Name) -Force -Scope:('Global')
                            If (Get-Module -Name:($ModuleData.PSGallery.Name) | Where-Object { $ModuleData.PSGallery.Version -like ([System.String]$_.Version + '*') })
                            {
                                Write-Host ('The "' + $ModuleData.PSGallery.Name + ' - ' + $ModuleData.PSGallery.Version + '" PowerShell module has successfully been installed.') -BackgroundColor:('Black') -ForegroundColor:('Gray')
                            }
                            Else
                            {
                                Write-Error ('Unable to find "' + $ModuleData.PSGallery.Name + ' - ' + $ModuleData.PSGallery.Version + '" PowerShell module loaded within session.')
                            }
                        }
                        Else
                        {
                            Write-Host ('Exiting the ' + $Name + ' PowerShell module update process.') -BackgroundColor:('Black') -ForegroundColor:('Gray')
                        }
                    }
                    Else
                    {
                        Write-Verbose ('The "' + $ModuleData.PSGallery.Name + '" PowerShell module is up to date.')
                    }
                }
                Else
                {
                    Write-Host ('Installing the ' + $Name + ' PowerShell module.') -BackgroundColor:('Black') -ForegroundColor:('Gray')
                    Install-Module -Name:($Name) -Force -AllowPrerelease
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