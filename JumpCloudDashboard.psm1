$Public = @( Get-ChildItem -Path "$PSScriptRoot/*.ps1")

$Private = @( Get-ChildItem -Path "$PSScriptRoot/*/*.ps1" -Recurse)

Foreach ($Function In @($Public + $Private))
{
    Try
    {
        . $Function.FullName
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($Function.FullName): $_"
    }
}
# Export Module Member
Export-ModuleMember -Function $Public.BaseName -Alias *