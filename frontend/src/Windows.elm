module Windows exposing
    ( Window(..)
    , Windows
    , toString
    , initWindows
    , initFileExplorerMainWindow
    , initWinampMainWindow
    , initWinampPlaylistWindow
    , openWindow
    , moveWindow
    )

import Dict
import Window

toString : Window -> String
toString window =
    case window of
        FileExplorerMainWindow ->
            "FileExplorerMainWindow"
        WinampMainWindow ->
            "WinampMainWindow"
        WinampPlaylistWindow ->
            "WinampPlaylistWindow"

type Window 
    = FileExplorerMainWindow
    | WinampMainWindow
    | WinampPlaylistWindow

type alias Windows =
    Dict.Dict String Window.WindowData

initFileExplorerMainWindow =
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
    , title = "File Explorer - "
    }

initWinampMainWindow =
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

initWinampPlaylistWindow =
    { x = 600
    , y = 400
    , width = 400
    , height = 300
    , minWidth = 300
    , minHeight = 200
    , isOpen = False
    , isClosable = True
    , isMinimized = False
    , isMaximized = False
    , title = "Swamp playlist"
    }

initWindows : Windows
initWindows =
    Dict.fromList
        [ 
            (   "FileExplorerMainWindow"
            ,   initFileExplorerMainWindow
            )
        ,   (   "WinampMainWindow"
            ,   initWinampMainWindow
            )
        ,   (   "WinampPlaylistWindow"
            ,   initWinampPlaylistWindow
            )
        ]

openWindow : Window -> Windows -> Windows
openWindow win windows =
    let
        windowKey = case win of
            FileExplorerMainWindow ->
                "FileExplorerMainWindow"
            WinampMainWindow ->
                "WinampMainWindow"
            WinampPlaylistWindow ->
                "WinampPlaylistWindow"

        open_ win_ =
            case win_ of
                Just w_ ->
                    Just (Window.open w_)
                Nothing ->
                    Nothing

    in
        Dict.update windowKey open_ windows

moveWindow : { x : Int, y : Int } -> Window -> Windows -> Windows
moveWindow to win windows =
    let
        windowKey = case win of
            FileExplorerMainWindow ->
                "FileExplorerMainWindow"
            WinampMainWindow ->
                "WinampMainWindow"
            WinampPlaylistWindow ->
                "WinampPlaylistWindow"

        move_ win_ =
            case win_ of
                Just w_ ->
                    Just (Window.move to w_)
                Nothing ->
                    Nothing

    in
        Dict.update windowKey move_ windows


