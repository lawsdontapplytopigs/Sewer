module View.PoorMansOutlook exposing 
    ( poorMansOutlook
    )

import Dict

import Element as E
import Element.Background as EBackground
import Element.Border as EBorder
import Element.Events as EEvents
import Element.Font as EFont
import Element.Input as EInput

import Html
import Html.Attributes
import Icons

import Msg
import Palette

import Window
import Windows
import View.Windoze as Windoze

poorMansOutlook model =
    let
        -- windowGeometry = 
        --     case (Windows.get Window.PoorMansOutlookMainWindow model.windows) of
        --         (Window.Window type_ geometry) ->
        --             geometry

        actualContent =
            let
                button =
                    E.el
                        [ E.height <| E.px 30
                        , E.width <| E.px 80
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
                                    { onPress = (Just Msg.TryToSendEmail)
                                    , label = 
                                        Windoze.type2Level2RaisedBorder 1
                                            <| Windoze.type2Level1RaisedBorder 1
                                                <| E.el
                                                    [ E.width E.fill
                                                    , E.height E.fill
                                                    ]
                                                    <| E.el 
                                                        [ EFont.size Palette.fontSize0
                                                        , EFont.family
                                                            [ EFont.typeface Palette.font0
                                                            ]
                                                        , E.centerY
                                                        , E.centerX
                                                        ]
                                                        <| E.text "Send <3"
                                    }
            in
            E.column
                [ EBackground.color Palette.color0
                , E.width E.fill
                , E.height E.fill
                ]
                [ Windoze.hSeparator 1
                , E.column
                    [ E.height E.fill
                    , E.width E.fill
                    -- , EBackground.color <| E.rgb255 80 80 80
                    , E.paddingXY 10 10
                    , E.spacing 10
                    ]
                    [ inputBar
                        "Your Email, please :)"
                        <| email
                            { onChange = (\s -> Msg.EmailInput s)
                            , text = model.programs.poorMansOutlook.from
                            , placeholder = Nothing --TODO: Maybe add some epic text here
                            , label = EInput.labelHidden "Email" -- TODO: add a better label?
                            }
                    , inputBar
                        "Subject"
                        <| subject
                            { onChange = (\s -> Msg.SubjectInput s)
                            , text = model.programs.poorMansOutlook.subject
                            , placeholder = Nothing --TODO: Maybe add some epic text here
                            , label = EInput.labelHidden "Subject" -- TODO: add a better label?
                            }
                    , E.column
                        [ E.width E.fill
                        , E.spacing 5
                        , E.height E.fill
                        ]
                        [ E.el
                            [ EFont.size Palette.fontSize0
                            , EFont.family
                                [ EFont.typeface Palette.font0
                                ]
                            ]
                            <| E.text "Your message"
                        , E.el
                            [ E.width E.fill
                            , E.height E.fill
                            -- , E.height <| E.maximum 400 E.fill
                            , EBackground.color <| Palette.color1
                            ]
                            <| Windoze.type1Level1DepressedBorder 1
                                <| Windoze.type1Level2DepressedBorder 1
                                    <| EInput.multiline
                                        [ EFont.size Palette.fontSize0
                                        , EFont.family
                                            [ EFont.typeface Palette.font0
                                            ]
                                        , E.paddingXY 5 5
                                        -- , E.height E.fill
                                        -- , E.width E.fill
                                        , EBackground.color <| Palette.color1
                                        , EBorder.width 0
                                        , EBorder.rounded 0
                                        , E.focused
                                            [ EBorder.color <| E.rgba255 0 0 0 0
                                            ]
                                        , E.height <| E.maximum 400 E.fill
                                        ]
                                        { onChange = (\s -> Msg.EmailContentInput s)
                                        , text = model.programs.poorMansOutlook.content
                                        , placeholder = Nothing --TODO: Maybe add some epic text here
                                        , label = EInput.labelHidden "Email Content" -- TODO: add a better label?
                                        , spellcheck = True
                                        }
                        ]
                    , E.row
                        [ E.width E.fill
                        ]
                        [ E.el 
                            [ E.alignRight
                            ]
                            <| button
                        ]
                    ]
                ]
    in
        actualContent

inputBar title bar =
    E.column
        [ E.width E.fill
        , E.spacing 5
        ]
        [ E.el
            [ EFont.size Palette.fontSize0
            , EFont.family
                [ EFont.typeface Palette.font0
                ]
            ]
            <| E.text title
        , E.el
            [ E.width E.fill
            , E.height <| E.px 30
            , EBackground.color <| Palette.color1
            ]
            <| Windoze.type1Level1DepressedBorder 1
                <| Windoze.type1Level2DepressedBorder 1
                    bar
        ]

email : 
    { onChange : String -> msg
    , text : String
    , placeholder : Maybe (EInput.Placeholder msg)
    , label : EInput.Label msg
    -- , stylingIfWrong : List (E.Element msg) -- TODO
    -- , isValid : String -> Bool
    }
    -> E.Element msg
email data =
    EInput.text
        [ EFont.size Palette.fontSize0
        , EFont.family
            [ EFont.typeface Palette.font0
            ]
        , E.paddingXY 5 0
        , E.centerY
        -- , E.height E.fill
        -- , E.width E.fill
        , EBackground.color <| Palette.color1
        , EBorder.width 0
        , EBorder.rounded 0
        , E.focused
            [ EBorder.color <| E.rgba255 0 0 0 0
            ]
        , E.htmlAttribute <| Html.Attributes.id "emailBox"
        ]
        data

subject :
    { onChange : String -> msg
    , text : String
    , placeholder : Maybe (EInput.Placeholder msg)
    , label : EInput.Label msg
    }
    -> E.Element msg
subject data =
    EInput.text
        [ EFont.size Palette.fontSize0
        , EFont.family
            [ EFont.typeface Palette.font0
            ]
        , E.paddingXY 5 0
        , E.centerY
        -- , E.height E.fill
        -- , E.width E.fill
        , EBackground.color <| Palette.color1
        , EBorder.width 0
        , EBorder.rounded 0
        , E.focused
            [ EBorder.color <| E.rgba255 0 0 0 0
            ]
        ]
        data

