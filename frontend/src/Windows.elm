module Windows exposing
    ( Windows
    , changeZIndex
    , get
    , initWindows
    , initFileExplorerMainWindow
    , initWinampMainWindow
    , initPoorMansOutlookMainWindow
    , isOpen
    , openWindow
    , moveWindow
    , closeWindow
    , focus
    , unFocus
    , minimize
    , unMinimize
    , toDefault
    )

import Dict
import Window

type alias Windows =
    Dict.Dict String Window.Window

initFileExplorerMainWindow =
    Window.Window
        Window.FileExplorerMainWindow
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
        , shouldBeDisplayedInNavbar = True
        , icon = "./icons/2.ico"
        , isFocused = False
        , zIndex = 0
        }

initWinampMainWindow =
    -- since we're using webamp, a lot of this data is now not really useful
    Window.Window
        Window.WinampMainWindow
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
        , shouldBeDisplayedInNavbar = True
        , icon = "./icons/3.ico"
        , isFocused = False
        , zIndex = 0
        }

initPoorMansOutlookMainWindow =
    Window.Window
        Window.PoorMansOutlookMainWindow
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
        , shouldBeDisplayedInNavbar = True
        , icon = "./icons/4.ico"
        , isFocused = False
        , zIndex = 0
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
        ,   (   "PoorMansOutlookMainWindow"
            ,   initPoorMansOutlookMainWindow
            )
        ]

get : Window.WindowType -> Windows -> Window.Window
get windowType windows =
    let
        key = Window.toString windowType
        maybeWin = 
            Dict.get key windows
    in
        case maybeWin of
            Just win ->
                win
            Nothing -> -- This can never happen
                toDefault windowType

toDefault : Window.WindowType -> Window.Window
toDefault windowType =
    case windowType of
        Window.FileExplorerMainWindow ->
            initFileExplorerMainWindow
        Window.WinampMainWindow ->
            initWinampMainWindow
        Window.PoorMansOutlookMainWindow ->
            initPoorMansOutlookMainWindow

openWindow : Window.WindowType -> Windows -> Windows
openWindow windowType windows =
    let
        win =
            case windowType of
                Window.FileExplorerMainWindow ->
                    initFileExplorerMainWindow
                Window.WinampMainWindow ->
                    initWinampMainWindow
                Window.PoorMansOutlookMainWindow ->
                    initPoorMansOutlookMainWindow
        windowKey = Window.toString windowType
    in
        -- TODO: test this. we really don't want to have the user type out a
        -- long email, try to open the email program even though it's already 
        -- open, and throw away all the message
        -- TODO: replace this with `isOpen`
        case Dict.member windowKey windows of 
            True ->
                windows
            False ->
                Dict.insert 
                    windowKey win windows

moveWindow : Window.WindowType -> { x : Int, y : Int } -> Windows -> Windows
moveWindow windowType to windows =
    let
        windowKey = Window.toString windowType

        move_ win_ =
            case win_ of
                Just (Window.Window type_ geometry_ ) ->
                    Just (Window.Window type_ (Window.move to geometry_))
                Nothing ->
                    Nothing
    in
        Dict.update windowKey move_ windows

closeWindow : Window.WindowType -> Windows -> Windows
closeWindow windowType windows =
    Dict.remove (Window.toString windowType) windows

focus : Window.WindowType -> Windows -> Windows
focus windowType windows =
    let
        winKey = Window.toString windowType

        sel : Maybe Window.Window -> Maybe Window.Window
        sel maybeWin = 
            case maybeWin of
                Just (Window.Window t_ geometry) ->
                    Just (Window.Window t_
                        { geometry
                            | isFocused = True
                        }
                    )
                Nothing ->
                    Nothing
                    

        allUnFocused =
            Dict.map unFocus windows
    in
        Dict.update winKey sel allUnFocused

changeZIndex : Window.WindowType -> Int -> Windows -> Windows
changeZIndex windowType z windows =
    let
        winKey = Window.toString windowType

        newZ maybeWin =
            case maybeWin of
                Just (Window.Window t_ geometry) ->
                    Just (Window.Window t_
                        { geometry
                            | zIndex = z
                        }
                    )
                Nothing ->
                    Nothing
    in
        Dict.update winKey newZ windows

unFocus : String -> Window.Window -> Window.Window
unFocus k (Window.Window t_ geometry) =
    (Window.Window t_ 
        { geometry
            | isFocused = False
        }
    )

minimize : Window.WindowType -> Windows -> Windows
minimize windowType windows =
    let
        winKey = Window.toString windowType

        minim_ : Maybe Window.Window -> Maybe Window.Window
        minim_ maybeWin =
            case maybeWin of
                Just (Window.Window t_ geometry) ->
                    Just (Window.Window t_
                        { geometry
                            | isMinimized = True
                            , isFocused = False
                        }
                    )
                Nothing ->
                    Nothing
    in
        Dict.update winKey minim_ windows

unMinimize : Window.WindowType -> Windows -> Windows
unMinimize windowType windows =
    let
        winKey = Window.toString windowType

        unMinim_ : Maybe Window.Window -> Maybe Window.Window
        unMinim_ maybeWin =
            case maybeWin of
                Just (Window.Window t_ geometry) ->
                    Just (Window.Window t_
                        { geometry
                            | isMinimized = False
                            , isFocused = True
                        }
                    )
                Nothing ->
                    Nothing
        -- when we 'un-minimize' a window, that window now becomes the one focused
        allUnFocused =
            Dict.map unFocus windows
    in
        Dict.update winKey unMinim_ allUnFocused

isOpen : Window.WindowType -> Windows -> Bool
isOpen windowType windows =
    Dict.member (Window.toString windowType) windows


toString : Window.Window -> String
toString (Window.Window t_ _ ) =
    Window.toString t_

