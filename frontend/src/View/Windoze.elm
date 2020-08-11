module View.Windoze exposing
    (..) -- TODO: only expose what's necessary

import Element as E
import Element.Background as EBackground
import Element.Border as EBorder
import Element.Events as EEvents
import Element.Font as EFont
import Element.Input as EInput

import Html.Events 
import Html.Attributes

import Icons
import Json.Decode as JDecode

import Msg

import Palette
import Window

noHighlight =
    [ E.htmlAttribute <| Html.Attributes.style "-webkit-touch-callout" "none" -- iOS Safari
    , E.htmlAttribute <| Html.Attributes.style "-webkit-user-select" "none" -- Safari
    , E.htmlAttribute <| Html.Attributes.style "-khtml-user-select" "none" -- Konqueror HTML
    , E.htmlAttribute <| Html.Attributes.style "-moz-user-select" "none" -- Old versions of Firefox
    , E.htmlAttribute <| Html.Attributes.style "-ms-user-select" "none" -- Internet Explorer/Edge
    , E.htmlAttribute <| Html.Attributes.style "user-select" "none" -- Non-prefixed version, currently
                                                                        -- supported by Chrome, Edge, Opera and Firefox */
    ]

makeTitleBar : 
    (List (E.Element Msg.Msg)) 
    -> Window.WindowType 
    -> String 
    -> Bool
    -> String
    -> E.Element Msg.Msg
-- TODO: make this just take all the window data as argument
makeTitleBar buttons windowType title isSelected icon =
    let
        -- mainPink = E.rgb255 255 180 210
        mainPink = E.rgb255 235 190 250
        -- lightPink = E.rgb255 255 255 255
        selectedPink = E.rgb255 210 120 240
        titlebarColor =
            case isSelected of
                True ->
                    selectedPink
                False ->
                    mainPink
    in
    E.row
        (
        [ E.height <| E.px 24
        , E.width E.fill
        , EBackground.color titlebarColor
        -- TODO: make it so you can click buttons, and not be able to drag the window
        , EEvents.onMouseDown <| Msg.MouseDownOnTitleBar windowType 
        , EEvents.onMouseUp <| Msg.MouseUpOnTitleBar
        -- , E.htmlAttribute <| Html.Events.on "mousemove" (JDecode.map Msg.TitleBarMouseMoved prog screenCoords)
        ]
        -- let's make sure you can't highlight text in the titlebar
        ++ noHighlight
        )
        [ E.el
            [ E.height E.fill
            , E.width <| E.px 24
            -- , EBackground.color <| E.rgb255 80 80 80
            ]
            <| E.image
                [ E.width <| E.px 16
                , E.height <| E.px 16
                , E.centerX
                , E.centerY
                ]
                { src = icon
                , description = "TODO"
                }
        , E.el 
            [ E.alignLeft
            , EFont.size Palette.fontSize1
            , EFont.color <| E.rgb255 20 20 20
            , EFont.heavy
            , EFont.family
                [ EFont.typeface Palette.font0
                ]
            , E.htmlAttribute <| Html.Attributes.style "text-rendering" "geometricPrecision"
            , E.paddingEach { top = 0, right = 0, bottom = 0, left = 5 }
            ]
            <| E.text title
        , E.el
            [ E.alignRight
            , E.height E.fill
            , E.paddingEach { top = 0, right = 5, bottom = 0, left = 100 }
            , EBackground.color titlebarColor
            , E.centerY
            -- , EBackground.color <| E.rgb255 20 20 20
            -- , EBackground.gradient 
            --     { angle = 3.14 / 2
            --     , steps = 
            --         [ mainPink
            --         , lightPink
            --         ]
            --     }
            ]
            <| E.row
                [ E.centerY
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

lighterRaisedBorder w content_ =
    E.el
        [ E.width E.fill
        , E.height E.fill
        , EBorder.widthEach { top = w, right = 0, bottom = 0, left = w }
        , EBorder.color Palette.gray4
        ]
        <| content_

lighterDepressedBorder w content_ =
    E.el
        [ E.width E.fill
        , E.height E.fill
        , EBorder.widthEach { top = 0, right = w, bottom = w, left = 0 }
        , EBorder.color Palette.gray4
        ]
        <| content_

darkerRaisedBorder w content_ =
    E.el
        [ E.width E.fill
        , E.height E.fill
        , EBorder.widthEach { top = 0, right = w, bottom = w, left = 0 }
        , EBorder.color Palette.gray1
        ]
        <| content_
darkerDepressedBorder w content_ =
    E.el
        [ E.width E.fill
        , E.height E.fill
        , EBorder.widthEach { top = w, right = 0, bottom = 0, left = w }
        , EBorder.color Palette.gray1
        ]
        <| content_

lightestRaisedBorder w content_ =
    E.el
        [ E.width E.fill
        , E.height E.fill
        , EBorder.widthEach { top = w, right = 0, bottom = 0, left = w }
        , EBorder.color Palette.white
        ]
        <| content_
lightestDepressedBorder w content_ =
    E.el
        [ E.width E.fill
        , E.height E.fill
        , EBorder.widthEach { top = 0, right = w, bottom = w, left = 0 }
        , EBorder.color Palette.white
        ]
        <| content_

darkestRaisedBorder w content_ =
    E.el
        [ E.width E.fill
        , E.height E.fill
        , EBorder.widthEach { top = 0, right = w, bottom = w, left = 0 }
        , EBorder.color Palette.gray0
        ]
        <| content_

darkestDepressedBorder w content_ =
    E.el
        [ E.width E.fill
        , E.height E.fill
        , EBorder.widthEach { top = w , right = 0, bottom = 0, left = w }
        , EBorder.color Palette.gray0
        ]
        <| content_


-- lord forgive me
type1Level1RaisedBorder wid content_ =
    lightestRaisedBorder wid
        <| darkerRaisedBorder wid content_
type1Level1DepressedBorder wid content_ =
    lightestDepressedBorder wid
        <| darkerDepressedBorder wid content_

type1Level2RaisedBorder wid content_ =
    lighterRaisedBorder wid
        <| darkestRaisedBorder wid content_
type1Level2DepressedBorder wid content_ =
    lighterDepressedBorder wid
        <| darkestDepressedBorder wid content_

type2Level1RaisedBorder wid content_ =
    lighterRaisedBorder wid
        <| darkerRaisedBorder wid content_
type2Level1DepressedBorder wid content_ =
    lighterDepressedBorder wid
        <| darkerDepressedBorder wid content_

type2Level2RaisedBorder wid content_ =
    lightestRaisedBorder wid
        <| darkestRaisedBorder wid content_
type2Level2DepressedBorder wid content_ =
    lightestDepressedBorder wid
        <| darkestDepressedBorder wid content_

makeMainBorder wid content_ =
    E.el
        [ EBorder.width wid
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

makeButton icon msg =
    
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
            [ EEvents.onClick msg
            ]
            <| type1Level2RaisedBorder 1
                <| type1Level1RaisedBorder 1
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

vSeparator w =
    E.row
        [ E.height E.fill
        ]
        [ E.el
            [ E.height E.fill
            , E.width <| E.px w
            , EBackground.color Palette.gray1
            ]
            <| E.none
        , E.el
            [ E.height E.fill
            , E.width <| E.px w
            , EBackground.color Palette.white
            ]
            <| E.none
        ]

hSeparator w =
    E.column
        [ E.width E.fill
        ]
        [ E.el
            [ E.height <| E.px w
            , E.width E.fill
            , EBackground.color Palette.gray1
            ]
            <| E.none
        , E.el
            [ E.height <| E.px w
            , E.width E.fill
            , EBackground.color Palette.white
            ]
            <| E.none
        ]

xIcon =
    let
        color = E.rgb255 0 0 0
        p = 1

        buttonWidth = (12 * p)
        buttonHeight = (10 * p)

        px col =
            E.el
                [ E.width <| E.px p
                , E.height <| E.px p
                , EBackground.color col
                ]
                <| E.none

        fillWidth w = 
            E.el
                [ E.width <| E.px (p * w)
                , E.height <| E.px p
                ]
                <| E.none

        row1 =
            E.row
                [ 
                ]
                [ fillWidth buttonWidth
                ]
        row2 =
            E.row
                [
                ]
                [ fillWidth 2
                , px color
                , px color
                , fillWidth 4
                , px color
                , px color
                , fillWidth 2
                ]
        row3 =
            E.row
                [
                ]
                [ fillWidth 3
                , px color
                , px color
                , fillWidth 2
                , px color
                , px color
                , fillWidth 3
                ]
        row4 =
            E.row
                [
                ]
                [ fillWidth 4
                , px color
                , px color
                , px color
                , px color
                , fillWidth 4
                ]
        row5 =
            E.row
                [
                ]
                [ fillWidth 5
                , px color
                , px color
                , fillWidth 5
                ]
        row6 =
            E.row
                [
                ]
                [ fillWidth 4
                , px color
                , px color
                , px color
                , px color
                , fillWidth 4
                ]
        row7 =
            E.row
                [
                ]
                [ fillWidth 3
                , px color
                , px color
                , fillWidth 2
                , px color
                , px color
                , fillWidth 3
                ]
        row8 =
            E.row
                [
                ]
                [ fillWidth 2
                , px color
                , px color
                , fillWidth 4
                , px color
                , px color
                , fillWidth 2
                ]
        row9 =
            E.row
                [ 
                ]
                [ fillWidth buttonWidth
                ]
        row10 =
            E.row
                [ 
                ]
                [ fillWidth buttonWidth
                ]

    in
        E.column
            -- [ E.width <| E.px buttonWidth
            -- , E.height <| E.px buttonHeight
            -- ]
            [
            ]
            [ row1
            , row2
            , row3
            , row4
            , row5
            , row6
            , row7
            , row8
            , row9
            , row10
            ]

xButton color msg =
    let

        p = 1

        buttonWidth = (12 * p)
        buttonHeight = (10 * p)

        px col =
            E.el
                [ E.width <| E.px p
                , E.height <| E.px p
                , EBackground.color col
                ]
                <| E.none

        fillWidth w = 
            E.el
                [ E.width <| E.px (p * w)
                , E.height <| E.px p
                ]
                <| E.none

        row1 =
            E.row
                [ 
                ]
                [ fillWidth buttonWidth
                ]
        row2 =
            E.row
                [
                ]
                [ fillWidth 2
                , px color
                , px color
                , fillWidth 4
                , px color
                , px color
                , fillWidth 2
                ]
        row3 =
            E.row
                [
                ]
                [ fillWidth 3
                , px color
                , px color
                , fillWidth 2
                , px color
                , px color
                , fillWidth 3
                ]
        row4 =
            E.row
                [
                ]
                [ fillWidth 4
                , px color
                , px color
                , px color
                , px color
                , fillWidth 4
                ]
        row5 =
            E.row
                [
                ]
                [ fillWidth 5
                , px color
                , px color
                , fillWidth 5
                ]
        row6 =
            E.row
                [
                ]
                [ fillWidth 4
                , px color
                , px color
                , px color
                , px color
                , fillWidth 4
                ]
        row7 =
            E.row
                [
                ]
                [ fillWidth 3
                , px color
                , px color
                , fillWidth 2
                , px color
                , px color
                , fillWidth 3
                ]
        row8 =
            E.row
                [
                ]
                [ fillWidth 2
                , px color
                , px color
                , fillWidth 4
                , px color
                , px color
                , fillWidth 2
                ]
        row9 =
            E.row
                [ 
                ]
                [ fillWidth buttonWidth
                ]
        row10 =
            E.row
                [ 
                ]
                [ fillWidth buttonWidth
                ]

        drawing =
            E.column
                -- [ E.width <| E.px buttonWidth
                -- , E.height <| E.px buttonHeight
                -- ]
                [
                ]
                [ row1
                , row2
                , row3
                , row4
                , row5
                , row6
                , row7
                , row8
                , row9
                , row10
                ]
    in
        
        E.el
            [ E.height <| E.px (buttonHeight + 4)
            , E.width <| E.px (buttonWidth + 4)
            , E.htmlAttribute <| Html.Attributes.style "transform" "scale(1.4)"
            ]
            <| EInput.button
                [ EBackground.color Palette.color0
                , E.width E.fill
                , E.height E.fill
                , EBorder.width 0
                -- , EBorder.color <| E.rgb255 200 100 140
                , EBorder.color <| E.rgba255 0 0 0 0
                , E.focused
                    [ EBorder.color <| E.rgba255 0 0 0 1
                    ]
                ]
                { onPress = msg
                , label =
                    type2Level2RaisedBorder 1
                        <| type2Level1RaisedBorder 1
                            xIcon
                            -- E.image
                            --     [ E.height <| E.px 10
                            --     , E.width <| E.px 12
                            --     ]
                            --     { src = "./icons/xButton.png"
                            --     , description = "uhhhh"
                            --     }
                }
                    

maximizeButton color msg =
    let

        p = 1

        buttonWidth = (12 * p)
        buttonHeight = (10 * p)

        px col =
            E.el
                [ E.width <| E.px p
                , E.height <| E.px p
                , EBackground.color col
                ]
                <| E.none

        fillWidth w = 
            E.el
                [ E.width <| E.px (p * w)
                , E.height <| E.px p
                ]
                <| E.none

        row1 =
            E.row
                [ 
                ]
                [ fillWidth 1
                , px color
                , px color
                , px color
                , px color
                , px color
                , px color
                , px color
                , px color
                , px color
                , fillWidth 2
                ]
        row2 =
            row1
        row3 =
            E.row
                [
                ]
                [ fillWidth 1
                , px color
                , fillWidth 7
                , px color
                , fillWidth 2
                ]
        row4 =
            row3
        row5 =
            row3
        row6 =
            row3
        row7 =
            row3
        row8 =
            row3
        row9 =
            row1
        row10 =
            E.row
                [ 
                ]
                [ fillWidth buttonWidth
                ]

        drawing =
            E.column
                -- [ E.width <| E.px buttonWidth
                -- , E.height <| E.px buttonHeight
                -- ]
                [
                ]
                [ row1
                , row2
                , row3
                , row4
                , row5
                , row6
                , row7
                , row8
                , row9
                , row10
                ]
    in
        
        E.el
            [ E.height <| E.px (buttonHeight + 4)
            , E.width <| E.px (buttonWidth + 4)
            , E.htmlAttribute <| Html.Attributes.style "transform" "scale(1.4)"
            ]
            <| EInput.button
                [ EBackground.color Palette.color0
                , E.width E.fill
                , E.height E.fill
                , EBorder.width 0
                -- , EBorder.color <| E.rgb255 200 100 140
                , EBorder.color <| E.rgba255 0 0 0 0
                , E.focused
                    [ EBorder.color <| E.rgba255 0 0 0 1
                    ]
                ]
                { onPress = msg
                , label =
                    type2Level2RaisedBorder 1
                        <| type2Level1RaisedBorder 1
                            drawing
                            -- E.image
                            --     [ E.height <| E.px 10
                            --     , E.width <| E.px 12
                            --     ]
                            --     { src = "./icons/xButton.png"
                            --     , description = "uhhhh"
                            --     }
                }

minimizeButton color msg =
    let

        p = 1

        buttonWidth = (12 * p)
        buttonHeight = (10 * p)

        px col =
            E.el
                [ E.width <| E.px p
                , E.height <| E.px p
                , EBackground.color col
                ]
                <| E.none

        fillWidth w = 
            E.el
                [ E.width <| E.px (p * w)
                , E.height <| E.px p
                ]
                <| E.none

        row1 =
            E.row
                [ 
                ]
                [ fillWidth buttonWidth
                ]
        row2 =
            row1
        row3 =
            row1
        row4 =
            row1
        row5 =
            row1
        row6 =
            row1
        row7 =
            row1
        row8 =
            E.row
                [
                ]
                [ fillWidth 2
                , px color
                , px color
                , px color
                , px color
                , px color
                , px color
                , fillWidth 4
                ]
        row9 =
            row8
        row10 =
            row1

        drawing =
            E.column
                -- [ E.width <| E.px buttonWidth
                -- , E.height <| E.px buttonHeight
                -- ]
                [
                ]
                [ row1
                , row2
                , row3
                , row4
                , row5
                , row6
                , row7
                , row8
                , row9
                , row10
                ]
    in
        
        E.el
            [ E.height <| E.px (buttonHeight + 4)
            , E.width <| E.px (buttonWidth + 4)
            , E.htmlAttribute <| Html.Attributes.style "transform" "scale(1.4)"
            ]
            <| EInput.button
                [ EBackground.color Palette.color0
                , E.width E.fill
                , E.height E.fill
                , EBorder.width 0
                -- , EBorder.color <| E.rgb255 200 100 140
                , EBorder.color <| E.rgba255 0 0 0 0
                , E.focused
                    [ EBorder.color <| E.rgba255 0 0 0 1
                    ]
                ]
                { onPress = msg
                , label =
                    type2Level2RaisedBorder 1
                        <| type2Level1RaisedBorder 1
                            drawing
                            -- E.image
                            --     [ E.height <| E.px 10
                            --     , E.width <| E.px 12
                            --     ]
                            --     { src = "./icons/xButton.png"
                            --     , description = "uhhhh"
                            --     }
                }

-- I call "infobars" the bars that windows 95 sometimes had on some programs
-- for example the slightly depressed bar at the bottom where there was some
-- info like Kb of the file(s), or how many files are there, etc
makeInfoBar text1 text2 =
    E.row
        [ EFont.family
            [ EFont.typeface Palette.font0
            ]
        , EFont.size Palette.fontSize0
        , E.width E.fill
        , E.spacing 2
        ]
        [ E.el
            [ E.width (E.maximum 120 E.fill)
            ]
            <| type1Level1DepressedBorder 1
                <| E.el
                    (
                    [ E.padding 4
                    -- , EBackground.color <| E.rgb255 20 20 20
                    ]
                    ++ noHighlight
                    )
                    <| E.text text1
        , type1Level1DepressedBorder 1
            <| E.el
                (
                [ E.width E.fill
                , E.padding 4
                ]
                ++ noHighlight
                )
                <| E.text text2
        ]

makeWindow : Window.Window -> E.Element Msg.Msg -> E.Element Msg.Msg
makeWindow (Window.Window windowType windowData) content =
    let
        titleBar = makeTitleBar 
            [ E.row
                [ E.width <| E.px 48
                , E.spacing 7
                ]
                [ minimizeButton (E.rgb255 0 0 0) (Just (Msg.MinimizeWindow windowType))
                , maximizeButton (E.rgb255 0 0 0) (Just Msg.NoOp) -- TODO
                ]
            , xButton (E.rgb255 0 0 0) (Just (Msg.CloseWindow windowType))
            ]
            windowType
            windowData.title
            windowData.isFocused
            windowData.iconSmall

        toolBar = makeToolBar
            [ makeToolItem "File" 
            , makeToolItem "Edit"
            , makeToolItem "Help"
            ]

    in
        E.el
            [ E.width <| E.px windowData.width
            , E.height <| E.px windowData.height
            , E.htmlAttribute <| Html.Attributes.style "transform" 
                ("translate(" ++ String.fromInt windowData.x ++ "px" ++ ", " ++ String.fromInt windowData.y ++ "px )")
            , E.htmlAttribute <| Html.Attributes.style "z-index" (String.fromInt windowData.zIndex)
            , EEvents.onMouseDown <| Msg.WindowClicked windowType
            ]
            <| type1Level2RaisedBorder 1
                <| type1Level1RaisedBorder 1
                    <| makeMainBorder 2
                        <| E.column
                            [ E.width E.fill
                            , EBackground.color Palette.color0
                            , E.height E.fill
                            ]
                            [ titleBar
                            , E.el
                                [ E.width E.fill
                                , EBackground.color Palette.color0
                                ]
                                <| toolBar
                            , E.el
                                [ E.width E.fill
                                , E.height E.fill
                                , E.htmlAttribute <| Html.Attributes.style "overflow" "hidden"
                                ]
                                <| content
                            -- , content
                            ]

makeInfoCardWindow : Window.Window -> E.Element Msg.Msg -> E.Element Msg.Msg
makeInfoCardWindow (Window.Window windowType windowData) content =
    let
        titleBar = makeTitleBar 
            [ xButton (E.rgb255 0 0 0) (Just (Msg.CloseWindow windowType))
            ]
            windowType
            windowData.title
            windowData.isFocused
            windowData.iconSmall
    in
        E.el
            [ E.width <| E.px windowData.width
            , E.height <| E.px windowData.height
            , E.htmlAttribute <| Html.Attributes.style "transform" 
                ("translate(" ++ String.fromInt windowData.x ++ "px" ++ ", " ++ String.fromInt windowData.y ++ "px )")
            , E.htmlAttribute <| Html.Attributes.style "z-index" (String.fromInt windowData.zIndex)
            , EEvents.onMouseDown <| Msg.WindowClicked windowType
            ]
            <| type1Level2RaisedBorder 1
                <| type1Level1RaisedBorder 1
                    <| makeMainBorder 2
                        <| E.column
                            [ E.width E.fill
                            , EBackground.color Palette.color0
                            , E.height E.fill
                            ]
                            [ titleBar
                            , E.el
                                [ E.width E.fill
                                , E.height E.fill
                                , E.htmlAttribute <| Html.Attributes.style "overflow" "hidden"
                                ]
                                <| content
                            ]


