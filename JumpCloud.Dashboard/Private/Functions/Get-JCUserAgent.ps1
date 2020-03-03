Function Get-JCUserAgent
{
    param(
        [switch]$ShowUserAgent
    )
    # Get information about the module
    If ($MyInvocation.MyCommand.Module)
    {
        $UserAgent_ModuleName = $MyInvocation.MyCommand.Module.Name
        $UserAgent_ModuleVersion = $MyInvocation.MyCommand.Module.Version
    }
    Else
    {
        $ModuleRoot = (Get-Item -Path:($PSScriptRoot)).Parent.Parent.FullName
        $ModulePsd1 = Get-ChildItem -Path:($ModuleRoot) -Filter:('*.psd1')
        If ($ModulePsd1)
        {
            $Psd1Info = Import-LocalizedData -BaseDirectory:($ModulePsd1.Directory) -FileName:($ModulePsd1.Name)
            $UserAgent_ModuleName = $Psd1Info.RootModule.Replace('.psm1', '')
            $UserAgent_ModuleVersion = $Psd1Info.ModuleVersion
        }
        Else
        {
            Write-Error ('Unable to locate the module psd1 file!')
        }
    }
    #Build UserAgent String
    $UserAgent_ModuleName = 'JumpCloud_' + $UserAgent_ModuleName
    $Template_UserAgent = "{0}/{1}"
    $CustomUserAgent = $Template_UserAgent -f $UserAgent_ModuleName, $UserAgent_ModuleVersion

    # Show the UserAgent to the console if parameter is passed in
    if ($PSBoundParameters.ShowUserAgent)
    {
        $CurrentVerbosePreference = $VerbosePreference
        $VerbosePreference = 'Continue'
        Write-Verbose ($CustomUserAgent)
        $VerbosePreference = $CurrentVerbosePreference
    }
    Return $CustomUserAgent
}
