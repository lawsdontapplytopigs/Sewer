module Programs.FileExplorer exposing
    ( FileExplorer(..)
    , init
    )

import Window

type alias Windows =
    { mainWindow : Window.WindowData
    }

type alias FileExplorerSpecifics =
    { path : String
    }

type FileExplorer =
    FileExplorer Windows FileExplorerSpecifics

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
        FileExplorer windows initFileManagerSpecifics
