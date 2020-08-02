module View.MediaPlayer exposing
    ( viewPhone
    )

import Array
import Element as E
import Element.Background as EBackground
import Element.Border as EBorder
import Element.Events as EEvents
import Element.Font as EFont
import Element.Input as EInput

import Html
import Html.Attributes
import Icons

import Json.Decode as JDecode
import Msg
import Palette
import Programs.MediaPlayer as MediaPlayer
import Window
import Windows
import View.Windoze as Windoze

-- tablet model =
--     E.column
--         [
--         ]


-- we pass in the width and height because of a few reasons:

-- 1. sometimes this will be renedered in a "windows 95"-like window, and sometimes
-- it will be rendered on to the entire window (for phones). passing in this 
-- information here will just make it easier for us to not worry about that here,
-- but in the calling context
-- 2. it's kind of a pain to contain the cover image in here... if we don't have
-- the width and height, a lot of times it misbehaves. on the desktop version it 
-- either makes the window bigger than it actually is specified in "model.windows",
-- or it just spills over the entire window. padding doesn't work well here.
-- writing this knowing the width and height of the viewport will do the job well

viewPhonePlayPanel viewportGeometry mpd =
    let

        currentAlbum =
            MediaPlayer.getSelectedAlbum mpd.selected mpd
        currentSong =
            MediaPlayer.getSelectedSong mpd.selected mpd

        
        elapsed = case mpd.elapsed of
            Nothing ->
                "-:--"
            Just f ->
                format f
        songLength = case mpd.currentSongDuration of
            Just duration ->
                format <| round duration
            Nothing ->
                "-:--"

        albumTitle =
            case Maybe.map .title currentAlbum of
                Just tit ->
                    tit 
                Nothing ->
                    "____________" -- TODO: Do something cool here

        topUserControls =
            E.row
                [ E.width <| E.px (viewportGeometry.width)
                , E.height <| E.px 40
                , E.centerX
                -- , EBackground.color <| E.rgb255 80 80 80
                ]
                [ E.el
                    [ E.width <| E.px Palette.padding2
                    , E.height <| E.px Palette.padding2
                    -- , EBackground.color Palette.gray1
                    ]
                    <| downIcon
                , E.column
                    [ E.width E.fill
                    , E.height E.fill
                    , EFont.family
                        [ EFont.typeface Palette.font0
                        ]
                    ]
                    [ E.el 
                        [ E.centerX
                        , E.centerY
                        , EFont.size 12
                        ]
                        <| E.text "Album"
                    , E.el
                        [ E.centerX
                        , E.centerY
                        , EFont.size Palette.fontSize0
                        ]
                        <| E.text albumTitle
                    ]
                , E.el
                    [ E.width <| E.px Palette.padding2
                    , E.height <| E.px Palette.padding2
                    -- , EBackground.color Palette.gray1
                    ]
                    <| hamburgerIcon
                ]

        trackName =
            E.el
                [ EFont.bold
                , EFont.size Palette.fontSize1
                , E.centerX
                ]
                <| case currentSong of
                    Nothing ->
                        E.el
                            [ E.height <| E.px 20
                            , E.width E.fill
                            ]
                            <| E.html <| Icons.scribble3 -- TODO: do something cool here
                    Just song ->
                        E.text song.title
        artistName =
            E.el
                [ E.centerX
                , EFont.size Palette.fontSize0
                ]
                <| E.text 
                    <| case currentSong of
                        Nothing ->
                            "a r  t  i  s   t " --TODO: here too
                        Just song ->
                            song.artist

        albumCover =
            E.el
                [ E.height E.fill
                , E.width E.fill
                ]
                <| E.el
                    [ E.height E.shrink
                    , E.width E.shrink
                    , E.centerX
                    , E.centerY
                    ]
                    <| E.el
                        [ E.centerX
                        , E.centerY
                        , E.width E.fill
                        , E.height E.fill
                        , EBackground.color <| E.rgb255 80 80 80
                        ]
                        <| Windoze.type1Level1DepressedBorder
                            <| E.image
                                [ E.width <| E.maximum (viewportGeometry.width - Palette.padding2) E.fill
                                , E.height <| E.maximum (viewportGeometry.width - Palette.padding2) E.fill
                                -- [ E.height E.fill
                                -- , E.width E.fill
                                , E.centerX
                                , E.centerY
                                ]
                                { src = 
                                    case Maybe.map .albumCoverSrc currentAlbum of
                                        Nothing ->
                                            "./no_signal_bars.jpg" --TODO: maybe do something cooler here
                                        Just src ->
                                            src
                                , description = "" -- TODO
                                }
        trackTitleAndArtist =
            E.el
                [ EFont.family
                    [ EFont.typeface Palette.font0
                    ]
                , E.centerX
                , E.centerY
                , E.height <| E.px Palette.padding3
                , E.width E.fill
                -- , E.paddingEach { top = 0, right = 0, bottom = Palette.padding0, left = 0 }
                ]
                <| E.column
                    [ E.centerX
                    , E.centerY
                    , E.spacing 5
                    ]
                    [ trackName
                    , artistName
                    ]

        sliderAndTimeEl =
            let
                makeCuteTimeEl time =
                    E.el
                        [ E.centerX
                        , E.centerY
                        ]
                        <| E.text time

                windowsLoadingBarSlider =
                    let
                        sliderHeight =
                            24

                        -- TODO: I may refactor this. also, maybe we can make it faster
                        maybePerc =
                            case mpd.elapsed of
                                Just elap ->
                                    case mpd.currentSongDuration of
                                        Just dur ->
                                            Just ((toFloat (elap * 100)) / dur)
                                        Nothing ->
                                            Nothing
                                Nothing ->
                                    Nothing
                                        
                    in
                        E.el
                            [ E.width <| E.fill
                            , E.height <| E.px sliderHeight
                            , E.paddingXY Palette.padding0 0 -- TODO: maybe change this
                            ]
                            <| Windoze.type1Level1DepressedBorder
                                <| EInput.slider
                                    [ E.width E.fill
                                    , E.height E.fill
                                    , EBackground.color Palette.color0
                                    , E.behindContent
                                        <| case maybePerc of
                                            Nothing ->
                                                E.none
                                            Just p ->
                                                E.row
                                                    [ E.height E.fill
                                                    , E.width E.fill
                                                    ]
                                                    [ E.el
                                                        [ E.width <| E.fillPortion (round (p * 100))
                                                        , E.height E.fill
                                                        , EBackground.color <| E.rgb255 0 0 176
                                                        ]
                                                        <| E.none
                                                    , E.el
                                                        [ E.width <| E.fillPortion (round ((100 - p) * 100))
                                                        , E.height E.fill
                                                        ]
                                                        <| E.none
                                                    ]
                                    ]
                                    { min = 0
                                    , max = case mpd.currentSongDuration of
                                        Just d ->
                                            d
                                            --FIXME: when there's no track loaded and we seek, 
                                            -- it sends a value between 0 and 100, which, of course, 
                                            -- won't end well because we should be sending seconds, not percentages
                                            -- To reproduce this issue: just load the page up and immediately try
                                            -- seeking in the media player
                                        Nothing ->
                                            100
                                    , onChange = (\val -> Msg.MediaPlayerTrackSliderMoved val)
                                    , value = case mpd.elapsed of
                                        Just d ->
                                            toFloat d
                                        Nothing ->
                                            0
                                    , thumb = EInput.thumb
                                        [ E.width <| E.px 0
                                        , E.height <| E.px 0
                                        ]
                                    , step = Nothing
                                    , label = EInput.labelHidden "seek in current song"
                                    }
                in
                E.row
                    [ EFont.family
                        [ EFont.typeface Palette.font0
                        ]
                    , EFont.size Palette.fontSize0
                    , E.width <| E.px (viewportGeometry.width - Palette.padding1)
                    , E.height <| E.px Palette.padding3
                    , E.centerY
                    , E.centerX
                    ]
                    [ makeCuteTimeEl elapsed
                    , windowsLoadingBarSlider
                    , makeCuteTimeEl songLength
                    ]

        bottomButtons =
            let
                regularButton32 isPushedIn icon msg =
                    E.el
                        [ E.width <| E.px 32
                        , E.height <| E.px 32
                        ]
                        <| regularButton isPushedIn icon msg
            in
            E.el
                [ E.height <| E.px Palette.padding3
                , E.width E.fill
                ]
                <| E.row
                    [ E.centerX
                    , E.centerY
                    , E.spacing 10
                    ]
                    [ regularButton mpd.shouldShuffle shuffleIcon Msg.PressedToggleShuffle
                    , regularButton False prevIcon Msg.PressedPrevSong
                    , playButton playIcon Msg.PressedPlayOrPause
                    , regularButton False nextIcon Msg.PressedNextSong
                    , regularButton mpd.shouldRepeat repeatIcon Msg.PressedToggleRepeat
                    ]
    in
        E.column
            [ E.width E.fill
            , E.height E.fill
            , EBackground.color Palette.color0
            , E.inFront
                <| viewPhoneSonglistPanel 
                    viewportGeometry
                    mpd
            ]
            [ topUserControls
            , albumCover
            , trackTitleAndArtist
            , Windoze.hSeparator
            , sliderAndTimeEl
            , bottomButtons
            ]

viewPhoneLandingPanel viewportGeometry mpd =
    let
        albumsList =
            Array.map (viewAlbum mpd.selected) mpd.discography

        actualAlbums =
            E.column
                [ E.width E.fill
                , E.height E.fill
                , EBackground.color Palette.color0
                ]
                <| Array.toList albumsList
                -- <| case albumsList of
                --     Nothing ->
                --         [ E.text "something really went badly" ]
                --     Just albums_ ->
                --         [ albums_ ]
    in
        Windoze.type1Level2RaisedBorder
            <| Windoze.type1Level1RaisedBorder
                <| Windoze.makeMainBorder
                    <| Windoze.type1Level1DepressedBorder
                        <| Windoze.type1Level2DepressedBorder
                            <| E.el
                                [ E.width E.fill
                                , E.height E.fill
                                , E.inFront actualAlbums
                                    -- <| viewPhoneSonglistPanel 
                                    --     viewportGeometry
                                    --     mpd
                                ]
                                <| E.none

viewPhone viewportGeometry model =
    let

        mainPhonePanel =
            case model.mediaPlayer.selected of
                MediaPlayer.Selected _ _ ->
                    viewPhonePlayPanel
                        viewportGeometry
                        model.mediaPlayer
                        
                        
                MediaPlayer.Default _ _ ->
                    viewPhoneLandingPanel viewportGeometry model.mediaPlayer

    in
        mainPhonePanel
        -- E.el
        --     [ E.width E.fill
        --     , E.height E.fill
        --     ]


-- viewPhoneAlbumlistPanel model =
    -- let
        
    -- in

topAlbumInfoHeight = Palette.padding5
viewPhoneSonglistPanel viewportGeometry mpd =
    let
        currentAlbum =
            MediaPlayer.getSelectedAlbum mpd.selected mpd

        viewCurrentAlbum =
            case Maybe.map (viewAlbum mpd.selected) currentAlbum of
                Just v ->
                    v
                Nothing ->
                    E.text "we're all going to make it brah"
        songs : Maybe (Array.Array MediaPlayer.SongData)
        songs =
            Maybe.map (\v -> v.songs) currentAlbum

        viewSongsList =
            let
                maybeArraySongs = Maybe.map2 Array.indexedMap (Just (viewSong (MediaPlayer.getAlbumIndex mpd.selected))) songs
            in
                case maybeArraySongs of
                    Just arr ->
                        Array.toList arr
                    Nothing ->
                        [ E.none ]

        panel =
            let
                songsList =
                    Windoze.type1Level1DepressedBorder
                        <| Windoze.type1Level2DepressedBorder
                            <| E.el
                                [ E.height E.fill
                                , E.width E.fill
                                , E.scrollbarY
                                -- , E.htmlAttribute <| Html.Attributes.style "overflow" "hidden"
                                , E.inFront 
                                    <| E.column
                                        [ E.width E.fill
                                        ]
                                        <| viewSongsList
                                ]
                                <| E.none
                topAlbumInfo =
                    E.el
                        [ E.height <| E.px topAlbumInfoHeight
                        , E.width E.fill
                        , EBackground.color Palette.color0
                        ]
                        <| viewCurrentAlbum
            in
            E.el
                [ E.height E.fill
                , E.width <| E.fillPortion 8 -- TODEPLOY : on very narrow screens, have this take up the entire screen
                , EBackground.color Palette.color1
                ]
                <| Windoze.type1Level2RaisedBorder
                    <| Windoze.type1Level1RaisedBorder
                        <| Windoze.makeMainBorder
                            <| E.column
                                [ E.width E.fill
                                , E.height E.fill
                                , E.inFront
                                    <| E.el 
                                        [ E.height <| E.px 28 
                                        , E.width <| E.px 32 
                                        , E.alignRight
                                        ]
                                        <| regularButton False (E.el [ E.htmlAttribute <| Html.Attributes.style "transform" "scale(1.7)" ] Windoze.xIcon) Msg.NoOp
                                ]
                                [ topAlbumInfo
                                , songsList
                                ]
    in
        E.row
            [ E.width E.fill
            , E.height E.fill
            ]
            [ E.el
                [ E.width <| E.fillPortion 2
                , E.height <| E.fill
                , EBackground.color <| E.rgba255 140 110 170 0.6
                ]
                <| E.none
            , panel
            ]

viewAlbum selected album =
    let

        albumCov =
            E.el
                [ E.width <| E.px (topAlbumInfoHeight - Palette.padding3)
                , E.height <| E.px (topAlbumInfoHeight - Palette.padding3)
                ]
                <| Windoze.type1Level1DepressedBorder 
                    <| E.image
                        [ E.height E.fill
                        , E.width E.fill
                        , E.centerX
                        , E.centerY
                        ]
                        { src = album.albumCoverSrc
                            -- case album.albumCoverSrc of
                            --     Nothing ->
                            --         "./no_signal_bars.jpg" --TODO: maybe do something cooler here
                            --     Just src ->
                            --         src
                        , description = "" -- TODO
                        }
        numberOfTracks = MediaPlayer.getTotalNumberOfAlbumTracks album
        albumNumberOfMinutes = toMinutes (MediaPlayer.getTotalNumberOfAlbumSeconds album)
    in
        E.row
            [ E.width E.fill
            , E.height <| E.px (topAlbumInfoHeight - Palette.padding3)
            , E.centerY
            , E.paddingXY Palette.padding1 0
            , EBackground.color <| E.rgb255 80 80 80
            ]
            [ albumCov
            , E.column
                [ E.spacing 5
                , E.paddingEach { top = 0, right = 0 , bottom = 0, left = 10 }
                , EFont.family
                    [ EFont.typeface Palette.font0
                    ]
                ]
                [ E.el
                    [ EFont.size 13
                    , EFont.color <| E.rgb255 40 40 40
                    ]
                    <| E.text "album"
                , E.el
                    [ EFont.size 19
                    ]
                    <| E.text album.title
                        -- <| case album.title of
                            -- Just str ->
                            --     str
                            -- Nothing ->
                            --     "__-__--_-_____" -- TODO
                -- , E.el
                --     [ EFont.size 15
                --     , EFont.color <| E.rgb255 20 20 20
                --     ]
                --     <| E.text "Sewerslvt"
                , E.el
                    [ EFont.size 14
                    , EFont.color <| E.rgb255 30 30 30
                    ]
                    <| E.text <| (String.fromInt numberOfTracks) ++ " tracks, " ++ (String.fromInt albumNumberOfMinutes) ++ " minutes"
                ]
            ]

viewSong albumInd songInd songData =
    E.row
        [ E.width E.fill
        , E.height <| E.px Palette.padding3
        , EFont.family
            [ EFont.typeface Palette.font0
            ]
        , EEvents.onDoubleClick <| Msg.SelectedSong albumInd songInd
        , EBackground.color <| E.rgb255 (255 - songInd * 10) (songInd * 10) (255 - songInd * 10)
        ]
        [ E.el
            [ E.paddingXY Palette.fontSize0 0
            , EFont.size (Palette.fontSize0 - 1)
            ]
            -- should we show things 0 indexed, or 1 indexed?
            <| E.text (String.fromInt (songInd + 1)) 
        , E.column
            [ E.spacing 3
            ]
            [ E.el
                [ EFont.size Palette.fontSize1
                , EFont.bold
                ]
                <| E.text songData.title
            , E.el
                [ EFont.size (Palette.fontSize0 - 1)
                ]
                <| E.text songData.artist
            ]
        , E.el
            [ EFont.size (Palette.fontSize0 - 1)
            , E.alignRight
            , E.paddingEach { top = 0, right = Palette.fontSize0, bottom = 0, left = 0 }
            ]
            <| E.text (format songData.duration)
        ]

regularButton pushedIn ic msg =
    let
        outerBorder =
            case pushedIn of
                True ->
                    Windoze.type2Level2DepressedBorder
                False ->
                    Windoze.type2Level2RaisedBorder
        innerBorder =
            case pushedIn of
                True ->
                    Windoze.type2Level1DepressedBorder
                False ->
                    Windoze.type2Level1RaisedBorder
                
    in
        EInput.button
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
                outerBorder
                    <| innerBorder
                        <| E.el
                            [ E.width <| E.fill
                            , E.height <| E.fill
                            ]
                            <| E.el 
                                [ E.centerY
                                , E.centerX
                                ]
                                <| ic
            }

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
        [ E.height <| E.px 42
        , E.width <| E.px 42
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

downIcon =
    let
        -- we may change the """""""pixel size""""""" later
        p0 = 1
        p2 = 2

        c0 = E.rgba255 0 0 0 0
        c1 = E.rgba255 0 0 0 1

        px col = E.el
            [ E.width <| E.px p2
            , E.height <| E.px p2
            , EBackground.color col
            ]
            <| E.none

        row0 = E.row
            [ E.width E.fill
            ]
            [ px c0
            , px c1
            , widthFill p2
            , px c1
            , px c0
            ]
        row1 = E.row
            [ E.width E.fill
            ]
            [ widthFill p2
            , px c1
            , px c0
            , px c1
            , widthFill p2
            ]
        row2 = E.row
            [ E.width E.fill
            ]
            [ widthFill p2
            , px c1
            , widthFill p2
            ]
        drawingWidth = 14
    in
        E.column
            [ E.width <| E.px drawingWidth
            , E.centerX
            , E.centerY
            ]
            [ row0
            , row1
            , row2
            ]

playIcon =
    let
        -- we may change the """""""pixel size""""""" later
        p0 = 1
        p1 = 2
        c1 = E.rgb255 0 0 0

        rw w =
            E.row
                [ E.width E.fill
                ]
                [ widthFillColor p1 c1 (p1 * w)
                , widthFill p1
                ]

        drawingWidth = 12
    in
        E.column
            [ E.width <| E.px drawingWidth
            ]
            [ rw 1
            , rw 2
            , rw 3
            , rw 2
            , rw 1
            , rw 0
            ]

hamburgerIcon = 
    let
        -- we may change the """""""pixel size""""""" later
        p0 = 1
        -- pixel size col =
        --     E.el
        --         [ EBackground.color col
        --         , E.width <| E.px size
        --         , E.height <| E.px size
        --         ]
        --         <| E.none
        -- p = pixel p_
        p1 = 2

        c1 = E.rgba255 0 0 0 1
        c2 = E.rgba255 0 0 0 0

        line col =
            E.el
                [ E.width E.fill
                , E.height <| E.px p1
                , EBackground.color col
                ]
                <| E.none
        drawingWidth = 12

    in
        E.column
            [ E.width <| E.px drawingWidth
            , E.centerX
            , E.centerY
            ]
            [ line c1
            , line c2
            , line c1
            , line c2
            , line c1
            , line c2
            ]

prevIcon =
    E.el
        [ E.htmlAttribute <| Html.Attributes.style "transform" "scale(-1)"
        ]
        <| nextIcon

nextIcon = 
    let
        -- we may change the """""""pixel size""""""" later
        p1 = 1
        p2 = 2
        c1 = E.rgb255 0 0 0
        -- pixel size col =
        --     E.el
        --         [ EBackground.color col
        --         , E.width <| E.px size
        --         , E.height <| E.px size
        --         ]
        --         <| E.none
        -- p = pixel p2

        rw maxW w =
            E.row
                [ E.width <| E.px maxW
                ]
                [ widthFillColor p2 c1 (p2 * w)
                , widthFill p2
                , widthFillColor p2 c1 p2
                ]

        rw4 = rw (p2 * 4)

        drawingWidth = 12
    in
        E.column
            [ E.width <| E.px drawingWidth
            ]
            [ rw4 1
            , rw4 2
            , rw4 3
            , rw4 2
            , rw4 1
            -- , p c1
            ]

shuffleIcon = 
    E.image
        [ E.height <| E.px 16
        , E.width <| E.px 16
        -- , E.htmlAttribute <| Html.Attributes.style "image-rendering" "-moz-crisp-edges"
        -- , E.htmlAttribute <| Html.Attributes.style "image-rendering" "crisp-edges"
        , E.htmlAttribute <| Html.Attributes.style "image-rendering" "pixelated"
        ]
        { description = "toggle shuffle songs"
        , src = "./shuffle.png"
        }

repeatIcon = 
    E.image
        [ E.height <| E.px 16
        , E.width <| E.px 16
        -- , E.htmlAttribute <| Html.Attributes.style "image-rendering" "crisp-edges"
        -- , E.htmlAttribute <| Html.Attributes.style "image-rendering" "crisp-edges"
        , E.htmlAttribute <| Html.Attributes.style "image-rendering" "pixelated"
        ]
        { description = "repeat current song"
        , src = "./repeat.png"
        }

toMinutes secs =
    secs // 60

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


                -- titleBar =
                --     E.el
                --         [ E.width E.fill
                --         , EBackground.color Palette.color2
                --         , E.height <| E.px 32
                --         ]
                --         <| E.row
                --             [ EFont.family
                --                 [ EFont.typeface Palette.font0
                --                 ]
                --             , EFont.size Palette.fontSize1
                --             , EFont.bold
                --             , EBackground.color <| Palette.color2
                --             , E.centerY
                --             , E.width E.fill
                --             , E.height E.fill
                --             , E.paddingEach { top = 0, right = 2, bottom = 0, left = 0 }
                --             ]
                --             [ E.text "Current album"
                --             , E.row
                --                 [ E.height E.fill
                --                 , E.alignRight
                --                 ]
                --                 [ E.el 
                --                     [ E.height <| E.px 28 
                --                     , E.width <| E.px 32 
                --                     ] 
                --                     <| regularButton False (E.el [ E.htmlAttribute <| Html.Attributes.style "transform" "scale(1.7)" ] Windoze.xIcon) Msg.NoOp
                --                 ]
                --             ]

