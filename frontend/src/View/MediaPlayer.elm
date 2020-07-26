module View.MediaPlayer exposing
    ( mediaPlayer
    )

import Element as E
import Element.Background as EBackground
import Element.Border as EBorder
import Element.Events as EEvents
import Element.Font as EFont
import Element.Input as EInput

import Html
import Html.Attributes

import Json.Decode as JDecode
import Msg
import Palette
import Window
import Windows
import View.Windoze as Windoze

mediaPlayer model =
    let
        windowData =
            case (Windows.get Window.MediaPlayerMainWindow model.windows) of
                (Window.Window t_ geom) ->
                    geom

        titleBar = Windoze.makeTitleBar 
            -- { mouseDownMsg = Msg.FileExplorerMouseDownOnTitleBar
            -- , mouseUpMsg = Msg.FileExplorerMouseUpOnTitleBar
            -- }
            [ E.row
                [ E.width <| E.px 48
                -- , EBackground.color <| E.rgb255 80 80 80
                , E.spacing 7
                ]
                [ Windoze.minimizeButton (E.rgb255 0 0 0) (Just (Msg.MinimizeWindow Window.MediaPlayerMainWindow))
                , Windoze.maximizeButton (E.rgb255 0 0 0) (Just Msg.NoOp)
                ]
            , Windoze.xButton (E.rgb255 0 0 0) (Just (Msg.CloseWindow Window.MediaPlayerMainWindow))
            ]
            Window.MediaPlayerMainWindow
            windowData.title
            windowData.isFocused
            windowData.iconSmall


        toolBar = Windoze.makeToolBar
            [ Windoze.makeToolItem "File" 
            , Windoze.makeToolItem "Edit"
            , Windoze.makeToolItem "Help"
            ]

        songLength =
            case model.mediaPlayer.currentSongDuration of
                Just duration ->
                    format <| round duration
                Nothing ->
                    "-:--"

        albumCover =
            let
                albumSize = windowData.width - 80
                albumCoverEl =
                    E.image
                        [ E.width <| E.px albumSize
                        , E.height <| E.px albumSize
                        , E.centerX
                        ]
                        { src = 
                            case model.mediaPlayer.albumCoverSrc of
                                Nothing ->
                                    "./no_signal_bars.jpg"
                                Just src ->
                                    src
                        , description = "" -- TODO
                        }

            in
            E.el
                [ E.width E.fill
                , E.height E.fill
                -- , EBackground.color Palette.color0
                ]
                <| E.column
                    [ EFont.family
                        [ EFont.typeface Palette.font0
                        ]
                    -- , EBackground.color <| E.rgb255 20 20 20
                    , E.centerX
                    , E.spacing 8
                    , E.centerY
                    ]
                    [ albumCoverEl
                    , E.el
                        [ EFont.bold
                        , EFont.size Palette.fontSize1
                        , E.centerX
                        ]
                        <| E.text 
                            <| case model.mediaPlayer.currentSong of
                                Nothing ->
                                    "lhhasljflhjlje"
                                Just song ->
                                    song.title
                    , E.el
                        [ E.centerX
                        , EFont.size Palette.fontSize0
                        ]
                        <| E.text 
                            <| case model.mediaPlayer.currentSong of
                                Nothing ->
                                    "WHO MADE THIS"
                                Just song ->
                                    song.artist
                    ]
        userControls =
            let
                elapsed = 
                    case model.mediaPlayer.elapsed of
                        Nothing ->
                            "-:--"
                        Just f ->
                            format f
                slider =
                    E.row
                        [ EFont.family
                            [ EFont.typeface Palette.font0
                            ]
                        , E.width E.fill
                        ]
                        [ E.text elapsed
                        , EInput.slider
                            [ E.width E.fill
                            , E.height <| E.px 30
                            , EBackground.color <| E.rgb255 170 30 180
                            ]
                            { min = 0
                            , max = 100
                            , onChange = (\val -> Msg.MediaPlayerTrackSliderMoved val)
                            , value = 0
                                -- case model.mediaPlayer.elapsed of
                                --     Just d ->
                                --         round d
                                --     Nothing ->
                                --         0
                            , thumb = EInput.defaultThumb
                            , step = Nothing
                            , label = EInput.labelHidden "Sup"
                            }
                        , E.text songLength
                        ]
            in
            E.column
                [ E.height <| E.px 100
                , EBackground.color <| E.rgb255 200 20 20
                , E.width E.fill
                ]
                [ slider
                , playButton playIcon Msg.PressedPlayOrPause
                ]
    in
        E.el
            [ E.width <| E.px windowData.width
            , E.height <| E.px windowData.height
            , E.htmlAttribute <| Html.Attributes.style "transform" ("translate(" ++ String.fromInt windowData.x ++ "px" ++ ", " ++ String.fromInt windowData.y ++ "px )")
            , E.htmlAttribute <| Html.Attributes.style "z-index" (String.fromInt windowData.zIndex)
            , EEvents.onMouseDown <| Msg.WindowClicked Window.MediaPlayerMainWindow
            ]
            <| Windoze.type1Level2RaisedBorder
                <| Windoze.type1Level1RaisedBorder
                    <| Windoze.makeMainBorder
                        <| E.column
                            [ E.width E.fill
                            , EBackground.color <| E.rgb255 200 200 200
                            , E.height E.fill
                            ]
                            [ titleBar
                            , E.el
                                [ E.width E.fill
                                , EBackground.color Palette.color0
                                ]
                                <| toolBar
                            , albumCover
                            , E.el
                                [ E.width E.fill
                                , EBackground.color Palette.color0
                                , E.alignBottom
                                ]
                                <| userControls
                            ]

playButton ic msg =
    let
        -- TODO: store button information so we know to show these differently 
        -- when they're pressed
        borderOuter =
            Windoze.type2Level2RaisedBorder
        borderInner =
            Windoze.type2Level1RaisedBorder
    in
    E.el
        [ E.height <| E.px 30
        , E.width <| E.px 30
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
            { onPress = Just msg
            , label = 
                borderOuter
                    <| borderInner
                        <| E.el
                            [ E.width <| E.fill
                            , E.height <| E.fill
                            ]
                            <| E.el 
                                [ E.centerY
                                , E.centerX
                                , E.paddingEach { top = 0, right = 0, bottom = 0, left = 5 }
                                ]
                                <| ic
            }

playIcon = 
    let
        -- we may change the """""""pixel size""""""" later
        p v =
            v * 1
        -- pixel size col =
        --     E.el
        --         [ EBackground.color col
        --         , E.width <| E.px size
        --         , E.height <| E.px size
        --         ]
        --         <| E.none
        -- p = pixel p_
        p_ = p 1

        c1 = E.rgb255 0 0 0

        rw w =
            E.row
                [ E.width E.fill
                ]
                [ widthFillColor p_ c1 (p w)
                , widthFill p_
                ]

        drawingWidth = 12
    in
        E.column
            [ E.width <| E.px drawingWidth
            ]
            [ rw 1
            , rw 2
            , rw 3
            , rw 4
            , rw 5
            , rw 6
            , rw 5
            , rw 4
            , rw 3
            , rw 2
            , rw 1
            , rw 0
            ]

format t =
    let
        min = t // 60
        sex = modBy 60 t -- haha he said secks B)B)B)B)
    in
        if sex < 10 then
            (String.fromInt min) ++ ":" ++ "0" ++ String.fromInt sex
        else
            (String.fromInt min) ++ ":" ++ String.fromInt sex

widthFill p_ = E.el
    [ E.width E.fill
    , E.height <| E.px p_
    ]
    <| E.none

widthFillColor p_ col wid = E.el
    [ EBackground.color col
    , E.width <| E.px wid
    , E.height <| E.px p_
    ]
    <| E.none


