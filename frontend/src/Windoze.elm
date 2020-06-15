module Windoze exposing
    (..)

import Element as E
import Element.Background as EBackground
import Element.Border as EBorder
import Element.Events as EEvents
import Element.Font as EFont

import Html.Events 

import Json.Decoder as JDecode

import Icons
import Palette

makeTitleBar 
    { mouseDownMsg
    , mouseUpMsg 
    }
    buttons title =
    let
        mainPink = E.rgb255 255 180 210
        lightPink = E.rgb255 255 255 255
        darkPink = E.rgb255 200 100 140
    in
    E.row
        [ E.height <| E.px 32
        , E.width E.fill
        , EBackground.color darkPink
        , EEvents.onMouseDown mouseDownMsg
        , EEvents.onMouseUp mouseUpMsg
        , E.htmlAttribute <| Html.Events.on
        ]
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
screenCoords 

makeToolItem text =
    let
        firstLetter = String.left 1 text
        rest = String.dropLeft 1 text
    in
    E.paragraph
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
        -- , EBackground.color Palette.color0
        ]
        <| E.row
            [
            ]
            toolsList

level1RaisedElementBorder content_ =
    E.el
        [ EBorder.widthEach { top = 0, right = 1, bottom = 1, left = 0 }
        , EBorder.color Palette.gray1
        , E.width E.fill
        ]
        <| E.el
            [ E.width E.fill
            , E.height E.fill
            , EBorder.widthEach { top = 1, right = 0, bottom = 0, left = 1 }
            , EBorder.color Palette.white
            ]
            <| content_

level2RaisedElementBorder content_ =
        E.el
            [ EBorder.widthEach { top = 0, right = 1, bottom = 1, left = 0 }
            , EBorder.color Palette.gray0
            , E.width E.fill
            ]
            <| E.el
                [ E.width E.fill
                , E.height E.fill
                , EBorder.widthEach { top = 1, right = 0, bottom = 0, left = 1 }
                , EBorder.color Palette.gray4
                ]
                <| content_

level1DepressedElementBorder content_ =
    E.el
        [ EBorder.widthEach { top = 0, right = 1, bottom = 1, left = 0 }
        , EBorder.color Palette.gray4
        ]
        <| E.el
            [ E.width E.fill
            , E.height E.fill
            , EBorder.widthEach { top = 1, right = 0, bottom = 0, left = 1 }
            , EBorder.color Palette.gray0
            ]
            <| content_

level2DepressedElementBorder content_ =
        E.el
            [ EBorder.widthEach { top = 0, right = 1, bottom = 1, left = 0 }
            , EBorder.color Palette.white
            ]
            <| E.el
                [ E.width E.fill
                , E.height E.fill
                , EBorder.widthEach { top = 1, right = 0, bottom = 0, left = 1 }
                , EBorder.color <| Palette.gray1
                ]
                <| content_


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


    -- E.el
    --     [ E.padding 1
    --     , EBackground.color <| E.rgb255 200 200 200
    --     ]
    --     <| E.el
    --         [ E.padding 2
    --         , EBackground.color <| E.rgb255 180 180 180
    --         ]
            -- <| E.el
            --     [ E.padding 1
            --     , EBackground.color <| E.rgb255 200 200 200
            --     ]
    
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
        
        level2RaisedElementBorder
            <| level1RaisedElementBorder
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

-- makeWindow 
--     { title, buttons, toolsList } 
--     content =
--     let
--         toolBar = makeToolBar toolsList
--         titleBar = makeTitleBar buttons title
--     in
--         level2RaisedElementBorder
--             <| level1RaisedElementBorder
--                 <| makeMainBorder 
--                     <| E.column
--                         [
--                         ]
--                         [ titleBar
--                         , E.el 
--                             [ E.width E.fill
--                             , E.height E.fill 
--                             , EBackground.color Palette.color0
--                             ]
--                                 <| toolBar
--                         , level2DepressedElementBorder 
--                             <| level1DepressedElementBorder 
--                                 <| content
--                         ]


