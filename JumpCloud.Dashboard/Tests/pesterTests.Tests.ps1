$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"


# Describe "pesterTests" {
#     It "New Directory Should Exist" {
#         (Test-Path -Path $Path) | Should Be $true
#     }
# }

Describe "Start Dashboard, web server results" {
    $Path = "../Private/Content-Pages/Default/"
    $Name = "DashboardPester"
    $pageCount = 0
    pesterTests -Path $Path -Name $Name
    # Connect-JCOnline
    $that = Start-JCDashboard
    # Start-Sleep -s 5

    It "Launched Web Server" {
        $that.Running | Should Be $true
    }

    # Gather expected pages from /Default/ page directory
    Get-ChildItem $Path -Filter *.ps1 |
    Foreach-Object {
        $content = $_.FullName
        $pageCount = $pageCount + 1
        It "page stuff" {
            Write-Output($content)
            $content | Should -Exist
        }
    }
    # var of displayed pages
    $num = $that.DashboardService.Dashboard.Pages.Count
    It "Expected Page Count based on templates" {
        $pageCount | Should Be $num
    }
}
