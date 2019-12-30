function Get-SystemsWithLastContactWithinXDays
{
    param (
        [int]$days
    )

    $SystemsArray = @()

    $GetActiveSystems = Get-JCSystem -active $True

    $SystemsArray += $GetActiveSystems

    $GetInactiveSystems = Get-JCSystem -active $false -filterDateProperty lastContact -dateFilter after -date (Get-Date).AddDays(-$days)

    $SystemsArray += $GetInactiveSystems

    Return $SystemsArray
}