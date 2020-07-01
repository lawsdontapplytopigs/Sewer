module Programs.WinampRipoff exposing 
    ( WinampRipoff 
    , init
    , openMainWindow
    , openPlaylistWindow
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

type alias WinampRipoff = 
    { windows : Windows 
    , specifics : WinampSpecifics
    }

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
        { windows = initWindows 
        , specifics = winampSpecifics
        }

openMainWindow winamp =
    let
        openWindow = Window.open winamp.windows.mainWindow
        updatedWindows = 
            let
                oldWindows = winamp.windows
            in
            { oldWindows
                | mainWindow = openWindow
            }
    in
        { winamp
            | windows = updatedWindows
        }

openPlaylistWindow winamp =
    let
        openWindow = Window.open winamp.windows.playlistWindow
        updatedWindows = 
            let
                oldWindows = winamp.windows
            in
            { oldWindows
                | mainWindow = openWindow
            }
    in
        { winamp
            | windows = updatedWindows
        }







