module Window exposing
    (..)

import Element as E
import Element.Background as EBackground
import Element.Border as EBorder
import Element.Font as EFont

import Icons
import Palette

makeTitleBar buttons title =
    let
        mainPink = E.rgb255 255 180 210
        lightPink = E.rgb255 255 255 255
    in
    E.row
        [ E.height <| E.px 32
        , E.width E.fill
        , EBackground.color mainPink
        ]
        [ E.el 
            [ E.alignLeft
            , EFont.size 17
            , EFont.color <| E.rgb255 20 20 20
            , EFont.bold
            , EFont.family
                [ EFont.typeface "Droid Sans"
                ]
            , E.paddingEach { top = 0, right = 0, bottom = 0, left = 5 }
            ]
            <| E.text title
        , E.row
            [ E.alignRight
            , E.height E.fill
            , E.paddingEach { top = 0, right = 0, bottom = 0, left = 200 }
            , EBackground.gradient 
                { angle = 3.14 / 2
                , steps = 
                    [ mainPink
                    , lightPink
                    ]
                }
            ]
            buttons
        ]

makeToolItem text =
    let
        firstLetter = String.left 1 text
        rest = String.dropLeft 1 text
    in
    E.paragraph
        [ EFont.family
            [ EFont.typeface Palette.font0
            ]
        , EFont.size 16
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
        , EBackground.color <| E.rgb255 255 210 230
        ]
        <| E.row
            [
            ]
            toolsList

makeHighElementBorder content_ =
    E.el
        [ EBorder.widthEach { top = 0, right = 2, bottom = 2, left = 0 }
        , EBorder.color <| E.rgb255 30 20 26
        ]
        <| E.el
            [ E.width E.fill
            , E.height E.fill
            , EBorder.widthEach { top = 2, right = 0, bottom = 0, left = 2 }
            , EBorder.color <| E.rgb255 255 255 255
            ]
            <| content_

makeLowElementBorder content_ =
    E.el
        [ EBorder.widthEach { top = 2, right = 0, bottom = 0, left = 2 }
        , EBorder.color <| E.rgb255 30 20 26
        ]
        <| E.el
            [ E.width E.fill
            , E.height E.fill
            , EBorder.widthEach { top = 0, right = 2, bottom = 2, left = 0 }
            , EBorder.color <| E.rgb255 255 220 240
            ]
            <| content_

makeMainBorder content_ =
    E.el
        [ EBorder.width 4
        , EBorder.color <| E.rgb255 255 170 210
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
            <| case icon of
                Maybe ic ->
                    icon
                Nothing ->
                    Icons.defaultProgramIcon
                E.html Icons.
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
        
        makeHighElementBorder
            <| E.el
                [ E.height <| E.px 26
                , E.centerX
                , E.centerY
                , EBackground.color <| E.rgb255 255 190 210
                ]
                <| E.html icon

makeWindow { title, buttons, toolsList } content =
    let
        toolBar = makeToolBar toolsList
        titleBar = makeTitleBar buttons title
    in
        makeHighElementBorder
            <| makeMainBorder 
                <| E.column
                    [
                    ]
                    [ titleBar
                    , toolBar
                    , makeLowElementBorder content
                    ]




