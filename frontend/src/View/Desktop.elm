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
import View.WinampRipoff

import Window
import Windows

view title model =
    { title = title
    , body = 
        [ E.layout
            [ E.inFront (View.Navbar.makeNavbar model)
            , E.htmlAttribute <| Html.Events.on "mousemove" (JDecode.map Msg.MouseMoved screenCoords)
            , E.htmlAttribute <| Html.Attributes.style "overflow" "hidden"
            -- , E.height E.fill
            , EEvents.onMouseUp Msg.MouseUpOnTitleBar
            ]
            <| mainDocumentColumn model
        ]
    }

screenCoords : JDecode.Decoder Coords
screenCoords =
    JDecode.map2 Coords
        (JDecode.field "screenX" JDecode.int)
        (JDecode.field "screenY" JDecode.int)

type alias Coords =
    { x : Int
    , y : Int
    }

mainDocumentColumn model =
    E.el
        [ E.width E.fill
        , E.height E.fill
        , EBackground.color <| E.rgb255 0 120 127 -- #00787f
        , E.behindContent <| desktop model
        ]
        <| E.none

-- TODO: implement this properly: make it so that people can click, drag, drop,
-- desktop items, and have them automatically reposition according to a grid
makeLauncher icon title =
    let
        desktopItemWidth = 96
        desktopItemHeight = 96
        iconSize = 32
    in
    E.el
        [ E.height <| E.px desktopItemHeight
        , E.width <| E.px desktopItemWidth
        -- , EBackground.color <| E.rgb255  80 80 80
        ]
        <| E.column
            [ E.spacing 5
            -- , EBackground.color <| E.rgb255 20 20 20
            , E.centerX
            , E.centerY
            ]
            [ E.el
                [ E.width <| E.px iconSize
                , E.height <| E.px iconSize
                , E.centerX
                , E.alignTop
                -- , EBackground.color <| E.rgb255 150 150 150
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
                -- , EFont.size Palette.fontSize0
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
        item1 = makeLauncher "./icons/0.ico" "My Computer"
        item2 = makeLauncher "./icons/0.ico" "Webamp"

        viewHelper windowType viewFunc =
            case Windows.isOpen windowType model.windows of
                True ->
                    -- let
                    --     _ = Debug.log "STILL OPEN" windowType
                    -- in
                    case (Windows.get windowType model.windows) of
                        (Window.Window t_ geometry) ->
                            case geometry.isMinimized of
                                True ->
                                    E.html <| Html.div [] []
                                False ->
                                    viewFunc model
                False ->
                    -- let
                    --     _ = (Debug.log "closed: " windowType) 
                    -- in
                        E.html
                            <| Html.div [] []
    in
        E.column
            [ E.alignLeft
            , E.inFront
                <| viewHelper
                    Window.FileExplorerMainWindow
                    View.FileExplorer.fileExplorer
            , E.inFront
                <| viewHelper
                    Window.PoorMansOutlookMainWindow
                    View.PoorMansOutlook.poorMansOutlook
            , E.inFront
                <| viewHelper
                    Window.WinampMainWindow
                    View.WinampRipoff.winampRipoff
            ]
            [ item1
            , item2
            -- , viewFileExplorer model
            -- , viewPoorMansOutlook model
            -- , viewWinampRipoff model
            ]

-- viewFileExplorer model =
--     case Windows.is
--     case (Windows.get Window.FileExplorerMainWindow model.windows) of
--         (Window.Window t_ geometry) ->
--             case geometry.isMinimized of 
--                 True ->
--                     E.none
--                 False ->
--                     View.FileExplorer.fileExplorer model 

-- viewPoorMansOutlook model =
--     case (Windows.get Window.PoorMansOutlookMainWindow model.windows) of
--         (Window.Window t_ geometry) ->
--             case geometry.isMinimized of 
--                 True ->
--                     E.none
--                 False ->
--                     View.PoorMansOutlook.poorMansOutlook model 

-- viewWinampRipoff model =
--     case (Windows.get Window.WinampMainWindow model.windows) of
--         (Window.Window t_ geometry) ->
--             case geometry.isMinimized of
--                 True ->
--                     E.none
--                 False ->
--                     -- we do this, since the winamp ripoff is actually webamp
--                     -- https://github.com/captbaritone/webamp
--                     E.html <| View.WinampRipoff.winampRipoff model


heightBlock height =
    E.el
        [ E.height <| E.px height
        ]
        <| E.text ""

