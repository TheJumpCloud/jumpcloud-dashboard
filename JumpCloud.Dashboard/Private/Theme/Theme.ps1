Return New-UDTheme -Name "Theme" -Definition @{
    '.ud-dashboard' = @{
        'font' = "Muli"
    }
    '.sidenav'            = @{
        'background-color' = "#202e38"
        'color'            = "#414c55"
        'margin-top'       = "75px"
        'height'           = "80%"
        'border-radius'    = "0px 8px 8px 0px"
    }
    '.sidenav li > a'     = @{
        'color'     = "#f1f1f1"
        'font-size' = "18px"
    }
    'li'                  = @{
        'background-color' = "#ffffff"
        'color'            = "#414c55"
    }
    'nav'                 = @{
        'left'  = "0"
        'right' = "0"
    }
    'nav ul a' = @{
        'background-color' = "#202e38"
    }
    'nav ul li' = @{
        'background-color' = "inherit"
    }
    ".collapsible-header" = @{
        'background-color' = "#ffffff"
        'color'            = "#414c55"
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
    UDNavBar              = @{
        BackgroundColor = "#202e38"
        FontColor       = "#414c55"
    }
    ".right hide-on-med-and-down" = @{
        'background-color' = "#202e38"
    }
    ".ud-navbar"          = @{
        'width'    = "100%"
        'position' = "fixed"
        'z-index'  = "9999"
    }
    ".btn" = @{
        'color' = "#ffffff"
        'background-color' = "#2cc692"
    }
    UDDashboard           = @{
        BackgroundColor = "#fcfcfc"
        FontColor       = "#414c55"
    }
    ".ud-card"            = @{
        'background-color' = "#ffffff"

        'color' = "#414c55"
    }
    ".ud-card p" = @{
        'color' = "#414c55 !important"
    }
    ".card" = @{
        'height' = "100%"
        'width' = "100%"
        'overflow-y' = "auto"
        # Works for Microsoft browsers (IE & Edge)
        '-ms-overflow-style' = "-ms-autohiding-scrollbar"
    }
    # Works for WebKit browsers (Chrome, Safari, Opera, etc)
    ".card::-webkit-scrollbar" = @{
        'background-color' = "#ffffff"
        #'border-radius' = "0px 8px 8px 0px"
    }
    ".card::-webkit-scrollbar-thumb" = @{
        'background' = "#a7a7a7"
        #'border-radius' = "8px"
        'opacity' = "50%"
    }
    # End of WebKit specifics
    ".card-content" = @{
        'height' = "100%"
        'width' = "100%"
        'display' = "inline-block"
    }
    ".react-grid-item" = @{
        'margin-top' = "-2vh"
    }
    ".tabs" = @{
        'overflow-x' = "auto"
        'display' = "inherit"
        # Works for Microsoft browsers (IE & Edge)
        '-ms-overflow-style' = "-ms-autohiding-scrollbar"
    }
    # Works for WebKit browsers (Chrome, Safari, Opera, etc)
    ".tabs::-webkit-scrollbar" = @{
        'height' = "0.66vh"
        'background-color' = "#ffffff"
        #'border-radius' = "0px 0px 8px 8px"
    }
    ".tabs::-webkit-scrollbar-thumb" = @{
        'background' = "#a7a7a7"
        'opacity' = "50%"
        'width' = "50%"
    }
    ".tabs .tab a" = @{
        'color' = "#a7a7a7"
        'opacity' = "50%"
    }
    ".tabs .tab a:hover" = @{
        'color' = "#414c55"
    }
    ".tabs .tab a.active" = @{
        'color' = "#414c55"
        'opacity' = "100%"
    }
    ".tabs .indicator" = @{
        'background-color' = "#a7a7a7"
    }
    UDChart               = @{
        BackgroundColor = "#ffffff"
        FontColor       = "#414c55 !important"
    }
    ".grey-text" = @{
        'color' = "#414c55 !important"
    }
    ".ud-grid"            = @{
        'background-color' = "#ffffff"
        'color' = "#414c55"
    }
    ".ud-button" = @{
        'float' = "right"
    }
    "#SystemsDownload" = @{
        'box-shadow' = "none"
        'background-color' = "inherit"
    }
    "#SystemsDownload .card-title" = @{
        'font-weight' = "bold"
    }
    "#UsersDownload" = @{
        'box-shadow' = "none"
        'background-color' = "inherit"
    }
    "#UsersDownload .card-title" = @{
        'font-weight' = "bold"
    }
    ".left-align p" = @{
        'float' = "left"
    }
    ".left-align button" = @{
        'float' = "right"
        'margin' = "-2vh 0 0 0"
    }
    UDFooter              = @{
        BackgroundColor = "#ffffff"
        FontColor       = "#414c55"
    }
    'main'                = @{
        'flex'       = "1 0 auto"
        'margin-top' = "4.7rem"
    }
    # table header allignment
    "th.griddle-table-heading-cell:first-child" = @{
        'text-align' = "left"
    }
    "th.griddle-table-heading-cell" = @{
        'text-align' = "center"
    }
    # cell text and checkmnark allignment
    "td.griddle-cell:first-child"   = @{
        'text-align' = "left"
    }
    "td.griddle-cell"    = @{
        'text-align' = "center"
    }
}