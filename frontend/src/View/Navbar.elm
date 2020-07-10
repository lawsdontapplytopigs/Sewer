module View.Navbar exposing 
    ( makeNavbar )

import Element as E
import Element.Background as EBackground
import Element.Border as EBorder
import Element.Font as EFont
import Element.Input as EInput

import Msg
import Palette

import View.Windoze as Windoze

makeNavbar model =
    let
        makeProgramItem { programTitle, iconData } window =
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
                        { onPress = Just (Msg.ToggleMinimize window)
                        , label = 
                            Windoze.type2Level2RaisedBorder
                                <| Windoze.type2Level1RaisedBorder
                                    <| E.row
                                        [ E.width <| E.fill
                                        , E.height <| E.fill
                                        , EBackground.color <| E.rgb255 80 80 80
                                        ]
                                        [ E.image
                                            [ E.height <| E.px 20
                                            , E.width <| E.px 20
                                            ]
                                            iconData
                                        , E.el
                                            [ EFont.family
                                                [ EFont.typeface Palette.font1
                                                ]
                                            , EFont.size Palette.fontSize0
                                            , EFont.bold
                                            ]
                                            <| E.text programTitle
                                        ]
                        }

        clock =
            Windoze.type1Level1DepressedBorder
                <| E.el
                    [ E.height E.fill
                    , E.width <| E.px 60
                    ]
                    <| E.text "12:41 PM"

        actualNavbar =
            let
                windozeButton = 
                    E.el
                        [ E.height E.fill
                        , E.width <| E.px 60
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
                                    Windoze.type2Level2RaisedBorder
                                        <| Windoze.type2Level1RaisedBorder
                                            <| E.row
                                                [ E.width <| E.fill
                                                , E.height <| E.fill
                                                , EBackground.color <| E.rgb255 80 80 80
                                                ]
                                                [ E.image
                                                    [ E.height <| E.px 20
                                                    , E.width <| E.px 20
                                                    ]
                                                    { src = "./icons/1.ico"
                                                    , description = "weendoze"
                                                    }
                                                , E.el
                                                    [ EFont.family
                                                        [ EFont.typeface Palette.font1
                                                        ]
                                                    , EFont.size Palette.fontSize0
                                                    , EFont.bold
                                                    ]
                                                    <| E.text "Stop"
                                                ]
                                }
            in
            E.row
                [ E.padding 1
                , E.width E.fill
                ]
                [ windozeButton
                , E.row
                    -- , EBackground.color <| E.rgb255 10 10 10
                    -- , E.paddingEach { top = 5, right = 0, bottom = 0, left = 0 }
                    [ E.width E.fill
                    ]
                    -- [ Windoze.makeToolBar
                        -- [ makeProgramItem 
                            -- { programTitle, iconData } window =
                        -- ]
                    [
                    ]
                ]

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
    in
        
        E.el
            [ E.alignBottom
            , E.width E.fill
            , EBackground.color Palette.color0
            ]
            <| raise
                actualNavbar





