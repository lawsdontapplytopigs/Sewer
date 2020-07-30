module View.Desktop exposing (view)

import Element as E
import Element.Background as EBackground
import Element.Border as EBorder
import Element.Events as EEvents
import Element.Font as EFont

import Html
import Html.Attributes
import Html.Events

import Icons

import Json.Decode as JDecode

import Msg
import Palette as Palette
import Programs.FileExplorer

import View.FileExplorer
import View.Navbar
import View.PoorMansOutlook
import View.MediaPlayer

import Window
import Windows
import View.Windoze

view model =
    E.el
        [ E.width E.fill
        , E.height E.fill
        , EBackground.color <| E.rgb255 0 120 127 -- #00787f
        , E.behindContent <| desktop model
        ]
        <| E.none

-- TODO: implement this properly: make it so that people can click, drag, drop,
-- desktop items, and have them automatically reposition according to a grid
makeLauncher icon title msg =
    let
        desktopItemWidth = 96
        desktopItemHeight = 96
        iconSize = 32
    in
    E.el
        [ E.height <| E.px desktopItemHeight
        , E.width <| E.px desktopItemWidth
        , EEvents.onDoubleClick msg
        ]
        <| E.column
            [ E.spacing 5
            , E.centerX
            , E.centerY
            ]
            [ E.el
                [ E.width <| E.px iconSize
                , E.height <| E.px iconSize
                , E.centerX
                , E.alignTop
                ]
                <| E.image
                    [ E.width E.fill
                    , E.height E.fill
                    ]
                    { src = icon
                    , description = title
                    }
            , E.el
                [ E.centerX
                , E.alignTop
                , EFont.family
                    [ EFont.typeface Palette.font0
                    ]
                , EFont.size Palette.fontSize0
                , EFont.color <| Palette.white
                , EFont.center
                ]
                <| E.paragraph
                    [ E.spacing 0
                    ]
                    [ E.text title
                    ]
            ]

desktop model =
    let
        item1 = makeLauncher 
            Palette.iconMyComputer
            "My Computer"
            (Msg.OpenWindow Window.FileExplorerMainWindow)
        item2 = makeLauncher 
            Palette.iconWebamp
            "Webamp"
            (Msg.OpenWindow Window.MediaPlayerMainWindow)

        viewHelper windowType viewFunc =
            -- TODO: write a windows.isMinimized function and use it here
            case (Windows.isOpen windowType model.windows, Windows.isMinimized windowType model.windows) of
                (True, False) ->
                    viewFunc
                (_, _) ->
                    E.none

        mediaPlayerInWindow =
            let
                mediaPlayerProgram =
                    Windows.get Window.MediaPlayerMainWindow model.windows 
                viewWin =
                    View.Windoze.makeWindow mediaPlayerProgram (View.MediaPlayer.viewPhone model)
            in
                viewHelper Window.MediaPlayerMainWindow viewWin
        fileExplorerInWindow =
            let
                fileExplorerProgram =
                    Windows.get Window.FileExplorerMainWindow model.windows 
                viewWin =
                    View.Windoze.makeWindow fileExplorerProgram (View.FileExplorer.fileExplorer model)
            in
                viewHelper Window.FileExplorerMainWindow viewWin
        contactMeInWindow =
            let
                poorMansOutlookProgram =
                    Windows.get Window.PoorMansOutlookMainWindow model.windows 
                viewWin =
                    View.Windoze.makeWindow poorMansOutlookProgram (View.PoorMansOutlook.poorMansOutlook model)
            in
                viewHelper Window.PoorMansOutlookMainWindow viewWin

    in
        E.column
            [ E.alignLeft
            , E.inFront mediaPlayerInWindow
            , E.inFront fileExplorerInWindow
            , E.inFront contactMeInWindow
            ]
            [ item1
            , item2
            ]

heightBlock height =
    E.el
        [ E.height <| E.px height
        ]
        <| E.text ""

