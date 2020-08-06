module View.Navbar exposing 
    ( makeNavbar )

import Dict

import Element as E
import Element.Background as EBackground
import Element.Border as EBorder
import Element.Font as EFont
import Element.Input as EInput

import Html.Attributes

import Msg
import Palette

import Time

import View.Windoze as Windoze
import Window
import Windows

makeNavbar model =
    let
        makeProgramItem { windowType, icon, title, isFocused } =
            let
                borderOuter =
                    case isFocused of
                        True ->
                            Windoze.type2Level2DepressedBorder 1
                        False ->
                            Windoze.type2Level2RaisedBorder 1
                borderInner =
                    case isFocused of
                        True ->
                            Windoze.type2Level1DepressedBorder 1
                        False ->
                            Windoze.type2Level1RaisedBorder 1
            in
            E.el
                [ E.height E.fill
                , E.width <| E.maximum 140 E.fill
                ]
                    <| EInput.button
                        [ EBackground.color Palette.color0
                        , E.width E.fill
                        , E.height E.fill
                        , EBorder.width 1
                        , EBorder.color <| E.rgba255 0 0 0 0
                        , E.focused
                            [ EBorder.color <| E.rgba255 0 0 0 1
                            ]
                        ]
                        { onPress = Just (Msg.NavbarItemClicked windowType)
                        , label = 
                            borderOuter
                                <| borderInner
                                    <| E.row
                                        [ E.width <| E.fill
                                        , E.height <| E.fill
                                        -- , EBackground.color <| E.rgb255 80 80 80
                                        , E.centerY
                                        ]
                                        [ E.el
                                            [ E.height E.fill
                                            , E.width <| E.px 22
                                            -- , EBackground.color <| E.rgb255 120 120 120
                                            ]
                                            <| E.image
                                                [ E.centerY
                                                , E.centerX
                                                -- , EBackground.color <| E.rgb255 20 20 20
                                                , E.height <| E.px 16
                                                , E.width <| E.px 16
                                                ]
                                                { src = icon
                                                , description = "todo"
                                                }
                                        , E.el
                                            [ EFont.family
                                                [ EFont.typeface Palette.font0
                                                ]
                                            , EFont.size Palette.fontSize0
                                            , EFont.light
                                            , E.width E.shrink
                                            -- , EBackground.color <| E.rgb255 80 80 80
                                            ]
                                            <| E.text title
                                        ]
                        }

        raise content_ =
            E.el
                [ E.width E.fill
                , E.height E.fill
                , EBorder.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
                , EBorder.color Palette.gray4
                ]
                <| E.el
                    [ E.width E.fill
                    , E.height E.fill
                    , EBorder.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
                    , EBorder.color <| E.rgb255 255 255 255 --TODO: make pink
                    ]
                        <| content_

        windozeButton = 
            E.el
                [ E.height E.fill
                , E.width <| E.px 64
                ]
                    <| EInput.button
                        [ EBackground.color Palette.color0
                        , E.width E.fill
                        , E.height E.fill
                        , EBorder.width 1
                        , EBorder.color <| E.rgba255 0 0 0 0
                        , E.focused
                            [ EBorder.color <| E.rgba255 0 0 0 1
                            ]
                        ]
                        { onPress = Just Msg.StartButtonPressed
                        , label = 
                            Windoze.type2Level2RaisedBorder 1
                                <| Windoze.type2Level1RaisedBorder 1
                                    <| E.row
                                        [ E.width <| E.fill
                                        , E.height <| E.fill
                                        -- , EBackground.color <| E.rgb255 80 80 80
                                        , E.spacing 4
                                        ]
                                        [ E.image
                                            [ E.height <| E.px 20
                                            , E.width <| E.px 20
                                            , E.paddingEach { top = 0, right = 0, bottom = 0, left = 2 }
                                            ]
                                            { src = "./icons/1.ico"
                                            , description = "weendoze"
                                            }
                                        , E.el
                                            [ EFont.family
                                                [ EFont.typeface Palette.font0
                                                ]
                                            , EFont.size Palette.fontSize0
                                            , EFont.bold
                                            , E.centerY
                                            -- , EBackground.color <| E.rgb255 20 20 20
                                            ]
                                            <| E.text "Stop"
                                        ]
                        }
        actualNavbar =
            let
                isGood k (Window.Window t_ geometry) =
                    case geometry.shouldBeDisplayedInNavbar of 
                        True ->
                            True
                        False ->
                            False
                    
                displayableItems =
                    Dict.filter
                        isGood
                        model.windows
            in
            E.row
                [ E.padding 1
                , E.width E.fill
                , E.height <| E.px 32
                ]
                [ windozeButton
                , E.row
                    -- , EBackground.color <| E.rgb255 10 10 10
                    -- , E.paddingEach { top = 5, right = 0, bottom = 0, left = 0 }
                    [ E.width E.fill
                    , E.height E.fill
                    , E.spacing 1
                    , E.paddingXY 4 0
                    ]
                    <| List.map 
                        makeProgramItem 
                        (getNavbarDisplayableWindowData displayableItems)
                        -- [ makeProgramItem 
                            -- { programTitle, iconData } window =
                        -- ]
                , clock model
                ]
    in
        
        E.el
            [ E.alignBottom
            , E.width E.fill
            , EBackground.color Palette.color0
            ]
            <| raise
                actualNavbar

getNavbarDisplayableWindowData windows =
    Dict.foldl addDisplayable [] windows

type alias NavbarItem =
    { title : String
    , icon : String
    , windowType : Window.WindowType
    , isFocused : Bool
    }

addDisplayable : String -> Window.Window -> List NavbarItem -> List NavbarItem
addDisplayable _ (Window.Window t_ geometry) navbarItems =
    { title = geometry.title
    , icon = geometry.iconSmall
    , windowType = t_
    , isFocused = geometry.isFocused
    } :: navbarItems

clock model =
    let
        amORpm =
            if (Time.toHour model.zone model.time) < 12 then
                "AM"
            else
                "PM"

        hour = 
            let
                looped = remainderBy 12 (Time.toHour model.zone model.time)
            in
                if looped == 0 then
                    12
                else
                    looped
            -- case Time.toHour model.zone model.time of
            --     0 ->
            --         12
            --     1 -> 
            --         1
            --     2 ->
            --         2
            --     3 ->
            --         3
            --     4 ->
            --         4
            --     5 ->
            --         5
            --     6 ->
            --         6
            --     7 ->
            --         7
            --     8 ->
            --         8
            --     9 ->
            --         9
            --     10 ->
            --         10
            --     11 ->
            --         11
            --     12 ->
            --         12
            --     13 ->
            --         1
            --     14 ->
            --         2
            --     15 ->
            --         3
            --     16 ->
            --         4
            --     17 ->
            --         5
            --     18 ->
            --         6
            --     19 ->
            --         7
            --     20 ->
            --         8
            --     21 ->
            --         9
            --     22 ->
            --         10
            --     _ ->
            --         11

        minutes = Time.toHour model.zone model.time
    in
    E.el
        [ E.height E.fill
        ]
        <| E.el
            [ E.height E.fill
            , EFont.family
                [ EFont.typeface Palette.font0
                ]
            , EFont.size Palette.fontSize0
            , E.paddingXY 0 1
            ]
            <| Windoze.type1Level1DepressedBorder 1
                <| E.row
                    [ E.width <| E.px 96
                    , E.height E.fill
                    ]
                    [ E.el
                        [ E.height E.fill
                        , E.width <| E.px 20
                        ]
                        <| E.image
                            [ E.centerY
                            , E.centerX
                            -- , EBackground.color <| E.rgb255 20 20 20
                            , E.height <| E.px 16
                            , E.width <| E.px 16
                            ]
                            { src = Palette.iconSpeakerSmall
                            , description = "should be volume, but i dont have that yet"
                            }
                    , E.el
                        [ E.centerY
                        , E.alignRight
                        , E.paddingEach { top = 0, right = 8, bottom = 0, left = 0 }
                        ]
                        <| E.text 
                            <| String.fromInt hour
                            ++ ":"
                            ++ String.fromInt minutes
                            ++ " "
                            ++ amORpm
                    ]

