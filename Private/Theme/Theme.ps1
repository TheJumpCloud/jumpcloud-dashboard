Return New-UDTheme -Name "Theme" -Definition @{
    '.sidenav'            = @{
        'background-color' = "#202e38"
        'color'            = "#ffffff"
        'margin-top'       = "75px"
        'height'           = "80%"
        'border-radius'    = "0px 8px 8px 0px"
    }
    '.sidenav li > a'     = @{
        'color'     = "#f1f1f1"
        'font-size' = "18px"
    }
    'li'                  = @{
        'background-color' = "#202e38"
        'color'            = "#ffffff"
    }
    'nav'                 = @{
        'left'  = "0"
        'right' = "0"
    }
    ".collapsible-header" = @{
        'background-color' = "#202e38"
        'color'            = "#ffffff"
        'font-size'        = "18px"
    }
    '.collapsible-body > ul > li > a'     = @{
        'font-size' = "14px"
    }
    "#LoadingMessage"     = @{
        "padding" = "50%"
    }
    ".pagination li.active" = @{
        'background-color' = "#26a69a"
    }
    ".card .card-action a:not(.btn):not(.btn-large):not(.btn-small):not(.btn-large):not(.btn-floating)" = @{
        'color' = "#039be5"
    }
    UDNavBar              = @{
        BackgroundColor = "#202e38"
        FontColor       = "#ffffff"
    }
    ".ud-navbar"          = @{
        'width'    = "100%"
        'position' = "fixed"
        'z-index'  = "9999"
    }
    ".btn-flat" = @{
        'color' = "#ffffff"
    }
    UDDashboard           = @{
        BackgroundColor = "#f9fafb"
        FontColor       = "#545454"
    }
    ".ud-card"            = @{
        'background-color' = "#202e38"
        'border-radius' = "8px"
        'color' = "#ffffff"
    }
    ".ud-card p" = @{
        'color' = "#ffffff !important"
    }
    UDChart               = @{
        BackgroundColor = "#202e38"
        FontColor       = "#ffffff"
    }
    ".ud-chart"           = @{
        'border-radius' = "8px"
    }
    ".ud-grid"            = @{
        'border-radius' = "8px"
        'background-color' = "#202e38"
        'color' = "#ffffff"
    }
    UDFooter              = @{
        BackgroundColor = "#202e38"
        FontColor       = "#ffffff"
    }
    'main'                = @{
        'flex'       = "1 0 auto"
        'margin-top' = "4.7rem"
    }
}