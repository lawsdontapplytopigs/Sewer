module Programs.FileExplorer exposing
    ( FileExplorer
    , init
    , openMainWindow
    )

import Window

type alias Windows =
    { mainWindow : Window.WindowData
    }

type alias FileExplorerSpecifics =
    { path : String
    }

type alias FileExplorer =
    { windows : Windows 
    , specifics : FileExplorerSpecifics
    }

init: FileExplorer
init =
    let
        path = "C:\\\\MyDocuments\\Albums"

        initFileManagerSpecifics =
            { path = path
            }

        windows : Windows
        windows = 
            { mainWindow =
                { x = 200
                , y = 70
                , width = 500
                , height = 300
                , minWidth = 300
                , minHeight = 200
                , isOpen = True
                , isClosable = True
                , isMinimized = False
                , isMaximized = False
                , title = "File Explorer - " ++ path
                }
            }
    in
        { windows = windows
        , specifics = initFileManagerSpecifics
        }

openMainWindow : FileExplorer -> FileExplorer
openMainWindow f =
    let
        openWindow = 
            Window.open f.windows.mainWindow
    in
        { f
            | windows = { mainWindow = openWindow }
        }










