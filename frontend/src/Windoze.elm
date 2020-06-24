module Windoze exposing
    (..)

import Element as E
import Element.Background as EBackground
import Element.Border as EBorder
import Element.Events as EEvents
import Element.Font as EFont

import Html.Events 
import Html.Attributes

import Icons
import Json.Decode as JDecode

import Msg

import Palette

noHighlight =
    [ E.htmlAttribute <| Html.Attributes.style "-webkit-touch-callout" "none" -- iOS Safari
    , E.htmlAttribute <| Html.Attributes.style "-webkit-user-select" "none" -- Safari
    , E.htmlAttribute <| Html.Attributes.style "-khtml-user-select" "none" -- Konqueror HTML
    , E.htmlAttribute <| Html.Attributes.style "-moz-user-select" "none" -- Old versions of Firefox
    , E.htmlAttribute <| Html.Attributes.style "-ms-user-select" "none" -- Internet Explorer/Edge
    , E.htmlAttribute <| Html.Attributes.style "user-select" "none" -- Non-prefixed version, currently
                                                                        -- supported by Chrome, Edge, Opera and Firefox */
    ]

makeTitleBar { mouseDownMsg , mouseUpMsg } buttons title =
    let
        mainPink = E.rgb255 255 180 210
        lightPink = E.rgb255 255 255 255
        darkPink = E.rgb255 200 100 140
    in
    E.row
        (
        [ E.height <| E.px 32
        , E.width E.fill
        , EBackground.color darkPink
        , EEvents.onMouseDown mouseDownMsg
        , EEvents.onMouseUp mouseUpMsg
        , E.htmlAttribute <| Html.Events.on "mousemove" (JDecode.map Msg.TitleBarMouseMoved screenCoords)
        ]
        -- let's make sure you can't highlight text in the titlebar
        ++ noHighlight

        )
        [ E.el 
            [ E.alignLeft
            , EFont.size Palette.fontSize1
            , EFont.color <| E.rgb255 20 20 20
            , EFont.heavy
            , EFont.family
                [ EFont.typeface Palette.font0
                ]
            , E.paddingEach { top = 0, right = 0, bottom = 0, left = 5 }
            ]
            <| E.text title
        , E.row
            [ E.alignRight
            , E.height E.fill
            , E.paddingEach { top = 0, right = 0, bottom = 0, left = 200 }
            , EBackground.color darkPink
            -- , EBackground.gradient 
            --     { angle = 3.14 / 2
            --     , steps = 
            --         [ mainPink
            --         , lightPink
            --         ]
            --     }
            ]
            buttons
        ]

screenCoords : JDecode.Decoder Coords
screenCoords =
    JDecode.map2 Coords
        (JDecode.field "screenX" JDecode.int)
        (JDecode.field "screenY" JDecode.int)

type alias Coords =
    { x : Int
    , y : Int
    }

makeToolItem text =
    let
        firstLetter = String.left 1 text
        rest = String.dropLeft 1 text
    in
    E.el
        ( 
        [ E.mouseOver <| 
            [ EBackground.color (E.rgb255 255 195 230 )
            ]
        , E.htmlAttribute <| Html.Attributes.style "cursor" "pointer"
        ]
        ++ noHighlight
        )
        <| E.paragraph
            [ EFont.family
                [ EFont.typeface Palette.font0
                ]
            , EFont.size Palette.fontSize0
            , E.padding 5
            ]
            [ E.el
                [ EFont.underline
                ]
                <| E.text firstLetter
            , E.text rest
            ]

makeToolBar toolsList =
    E.el
        [ E.width E.fill
        ]
        <| E.row
            [
            ]
            toolsList

lighterRaisedBorder content_ =
    E.el
        [ E.width E.fill
        , E.height E.fill
        , EBorder.widthEach { top = 1, right = 0, bottom = 0, left = 1 }
        , EBorder.color Palette.gray4
        ]
        <| content_
lighterDepressedBorder content_ =
    E.el
        [ E.width E.fill
        , E.height E.fill
        , EBorder.widthEach { top = 0, right = 1, bottom = 1, left = 0 }
        , EBorder.color Palette.gray4
        ]
        <| content_

darkerRaisedBorder content_ =
    E.el
        [ E.width E.fill
        , E.height E.fill
        , EBorder.widthEach { top = 0, right = 1, bottom = 1, left = 0 }
        , EBorder.color Palette.gray1
        ]
        <| content_
darkerDepressedBorder content_ =
    E.el
        [ E.width E.fill
        , E.height E.fill
        , EBorder.widthEach { top = 1, right = 0, bottom = 0, left = 1 }
        , EBorder.color Palette.gray1
        ]
        <| content_

lightestRaisedBorder content_ =
    E.el
        [ E.width E.fill
        , E.height E.fill
        , EBorder.widthEach { top = 1, right = 0, bottom = 0, left = 1 }
        , EBorder.color Palette.white
        ]
        <| content_
lightestDepressedBorder content_ =
    E.el
        [ E.width E.fill
        , E.height E.fill
        , EBorder.widthEach { top = 0, right = 1, bottom = 1, left = 0 }
        , EBorder.color Palette.white
        ]
        <| content_

darkestRaisedBorder content_ =
    E.el
        [ E.width E.fill
        , E.height E.fill
        , EBorder.widthEach { top = 0, right = 1, bottom = 1, left = 0 }
        , EBorder.color Palette.gray0
        ]
        <| content_
darkestDepressedBorder content_ =
    E.el
        [ E.width E.fill
        , E.height E.fill
        , EBorder.widthEach { top = 1, right = 0, bottom = 0, left = 1 }
        , EBorder.color Palette.gray0
        ]
        <| content_


type1Level1RaisedBorder content_ =
    lightestRaisedBorder
        <| darkerRaisedBorder content_
type1Level1DepressedBorder content_ =
    lightestDepressedBorder
        <| darkerDepressedBorder content_

type1Level2RaisedBorder content_ =
    lighterRaisedBorder
        <| darkestRaisedBorder content_
type1Level2DepressedBorder content_ =
    lighterDepressedBorder
        <| darkestDepressedBorder content_

type2Level1RaisedBorder content_ =
    lighterRaisedBorder
        <| darkerRaisedBorder content_
type2Level1DepressedBorder content_ =
    lighterDepressedBorder
        <| darkerDepressedBorder content_

type2Level2RaisedBorder content_ =
    lightestRaisedBorder
        <| darkestRaisedBorder content_

type2Level2DepressedBorder content_ =
    lightestDepressedBorder 
        <| darkestDepressedBorder content_

makeMainBorder content_ =
    E.el
        [ EBorder.width 2
        , E.width E.fill
        , E.height E.fill
        , EBorder.color Palette.color0
        ]
        <| content_

makeTaskListProgram h icon name =
    E.row
        [ E.width <| E.px 120
        , E.height E.fill
        ]
        [ E.el 
            [ E.height E.fill
            , E.width <| E.px h
            ]
            <| E.html 
                <| case icon of
                    Just ic ->
                        ic
                    Nothing ->
                        Icons.defaultProgramIcon
        , makeToolItem name
        ]

makeButton icon =
    
    -- let
    --     size = 32
    --     ic = 
    --         E.el
    --             [ E.height <| E.fill
    --             , E.width <| E.px 32
    --             , EBackground.color <| E.rgb255 170 170 170
    --             , EBorder.widthEach { top = 2, right = 0, bottom = 0, left = 2 }
    --             , EBorder.color <| E.rgb255 210 210 210
    --             ]
    --             <| E.el
    --                 [ E.height E.fill
    --                 , E.width E.fill
    --                 , EBackground.color <| E.rgb255 170 170 170
    --                 , EBorder.widthEach { top = 0, right = 2, bottom = 2, left = 0 }
    --                 , EBorder.color <| E.rgb255 40 40 40
    --                 ]
        
        E.el
            [
            ]
            <| type1Level2RaisedBorder
                <| type1Level1RaisedBorder
                    <| E.el
                        [ E.height <| E.px 22
                        , E.width <| E.px 26
                        , EBackground.color <| E.rgb255 255 190 210
                        , E.centerX
                        , E.centerY
                        ]
                        -- <| E.el 
                        --     [
                        --     ] 
                            <| E.html icon

