module Windows exposing
    ( WindowType(..)
    , Window
    , Windows
    , toString
    , initWindows
    , initFileExplorerMainWindow
    , initWinampMainWindow
    , initWinampPlaylistWindow
    , initPoorMansOutlookMainWindow
    , openWindow
    , moveWindow
    , closeWindow
    )

import Dict
import WindowGeometry


type alias Window = WindowType
-- TODO: Can I use a union type as the key to the dictionary?
toString : WindowType -> String
toString window =
    case window of
        FileExplorerMainWindow ->
            "FileExplorerMainWindow"
        WinampMainWindow ->
            "WinampMainWindow"
        WinampPlaylistWindow ->
            "WinampPlaylistWindow"
        PoorMansOutlookMainWindow ->
            "PoorMansOutlookMainWindow"

type WindowType
    = FileExplorerMainWindow
    | WinampMainWindow
    | WinampPlaylistWindow
    | PoorMansOutlookMainWindow

type alias Windows =
    Dict.Dict String WindowGeometry.WindowGeometry

initFileExplorerMainWindow =
    { x = 200
    , y = 70
    , width = 500
    , height = 300
    , minWidth = 300
    , minHeight = 200
    , wantsToNotBeClosed = False
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
    , wantsToNotBeClosed = False
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
    , wantsToNotBeClosed = False
    , isMinimized = False
    , isMaximized = False
    , title = "Swamp playlist"
    }

initPoorMansOutlookMainWindow =
    { x = 1200
    , y = 150
    , width = 800
    , height = 600
    , minWidth = 200
    , minHeight = 400
    , wantsToNotBeClosed = False
    , isMinimized = False
    , isMaximized = False
    , title = "BONK"
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
        ,   (   "PoorMansOutlookMainWindow"
            ,   initPoorMansOutlookMainWindow
            )
        ]

openWindow : WindowType -> Windows -> Windows
openWindow win windows =
    let
        windowKey = toString win

        value =
            case win of
                FileExplorerMainWindow ->
                    initFileExplorerMainWindow
                WinampMainWindow ->
                    initWinampMainWindow
                WinampPlaylistWindow ->
                    initWinampPlaylistWindow
                PoorMansOutlookMainWindow ->
                    initPoorMansOutlookMainWindow
    in
        -- TODO: test this. we really don't want to have the user type out a
        -- long email, try to open the email program even though it's already 
        -- open, and throw away all the message
        case Dict.member windowKey windows of 
            True ->
                windows
            False ->
                Dict.insert windowKey value windows

moveWindow : { x : Int, y : Int } -> WindowType -> Windows -> Windows
moveWindow to win windows =
    let
        windowKey = toString win

        move_ win_ =
            case win_ of
                Just w_ ->
                    Just (WindowGeometry.move to w_)
                Nothing ->
                    Nothing

    in
        Dict.update windowKey move_ windows

closeWindow : WindowType -> Windows -> Windows
closeWindow win windows =
        Dict.remove (toString win) windows



