module Programs.WinampRipoff exposing 
    ( WinampRipoff 
    , init
    )

import Window

type Song
    = CherusTheme

type alias Windows =
    { mainWindow : Window.WindowData
    , playlistWindow : Window.WindowData
    }

type alias WinampSpecifics =
    { currentSong : Song
    }

type WinampRipoff = WinampRipoff Windows WinampSpecifics

init =
    let
        initWindows =
            { mainWindow =
                { x = 400
                , y = 200
                , width = 400
                , height = 300
                , minWidth = 300
                , minHeight = 200
                , isOpen = True
                , isClosable = True
                , isMinimized = False
                , isMaximized = False
                , title = "Swamp"
                }
            , playlistWindow =
                { x = 600
                , y = 400
                , width = 400
                , height = 300
                , minWidth = 300
                , minHeight = 200
                , isOpen = True
                , isClosable = True
                , isMinimized = False
                , isMaximized = False
                , title = "Swamp playlist"
                }
            }
        winampSpecifics =
            { currentSong = CherusTheme
            }
    in
        WinampRipoff initWindows winampSpecifics
