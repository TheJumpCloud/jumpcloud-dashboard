function Get-AlternatingColors
{
    [CmdletBinding()]
    param (
        [int]$Rows,
        [string]$Color1,
        [string]$Color2
    )

    $ColorArray = @()

    1..$rows | % { if ($_ % 2 -eq 1) { $ColorArray += $Color1 } else { $ColorArray += $Color2 } }

    return $ColorArray
}

