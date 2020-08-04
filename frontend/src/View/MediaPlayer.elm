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

topAlbumInfoHeight = Palette.padding5

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

viewPhone viewportGeometry model =
    let
        yPos = 0

        -- playPanelYOffset = model.mediaPlayer.playPanelYOffset
        -- songsPanelXOffset = model.mediaPlayer.songsPanelXOffset

        panelWid =
            if viewportGeometry.width < 300 then
                viewportGeometry.width
            else
                viewportGeometry.width - (viewportGeometry.width // 5) -- 80%
    in
    E.el
        [ E.width <| E.px viewportGeometry.width
        , E.height <| E.px viewportGeometry.height

        , E.behindContent <|
            E.el
                [ E.height <| E.px viewportGeometry.height
                , E.width <| E.px viewportGeometry.width
                ]
                <| viewPhoneLandingPanel viewportGeometry model.mediaPlayer
        , E.inFront <|
            if model.mediaPlayer.playPanelYOffset == 0 then
                E.none
            else
                E.el
                    [ E.htmlAttribute <| Html.Attributes.style "transform" <| "translate(0px, " ++ (String.fromInt (viewportGeometry.height - model.mediaPlayer.playPanelYOffset)) ++ "px)"
                    , E.height <| E.px viewportGeometry.height
                    , E.width <| E.px viewportGeometry.width
                    ]
                    <| viewPhonePlayPanel viewportGeometry model.mediaPlayer
        , E.inFront <|
            if model.mediaPlayer.songsPanelXOffset == 0 then
                E.none
            else
                E.el
                    [ E.width <| E.px viewportGeometry.width
                    , E.height <| E.px viewportGeometry.height
                    , EBackground.color <| E.rgba255 170 120 255 0.5
                    ]
                    <| E.el
                        [ E.htmlAttribute <| Html.Attributes.style "transform" <| "translateX(+" ++ (String.fromInt (viewportGeometry.width - model.mediaPlayer.songsPanelXOffset))++ "px)"
                        , E.width <| E.px viewportGeometry.width
                        , E.height <| E.px viewportGeometry.height
                        , E.alignRight
                        ]
                        <| viewPhoneSonglistPanel viewportGeometry model.mediaPlayer
        ]
        <| E.none
        -- , E.row
        --     [ 
        --     ]
        --     [ E.el
        --         -- [ E.htmlAttribute <| Html.Attributes.style "transform" ("translateY(-" ++ (String.fromInt playPanelYOffset) ++ "px)")
        --         [ E.htmlAttribute <| Html.Attributes.style "top" ("-" ++ (String.fromInt playPanelYOffset) ++ "px")
        --         , E.height <| E.px viewportGeometry.height
        --         , E.width <| E.px viewportGeometry.width
        --         ]
        --         <| viewPhonePlayPanel viewportGeometry model.mediaPlayer

        --     , E.el
        --         -- [ E.htmlAttribute <| Html.Attributes.style "transform" ("translateX("++ (String.fromInt songsPanelXOffset) ++ "px)")
        --         [ E.htmlAttribute <| Html.Attributes.style "left" ("-" ++ (String.fromInt songsPanelXOffset) ++ "px")
        --         , E.htmlAttribute <| Html.Attributes.style "top" ("-" ++ (String.fromInt playPanelYOffset) ++ "px")
        --         , E.height <| E.px viewportGeometry.height
        --         , E.width <| E.px viewportGeometry.width
        --         ]
        --         <| viewPhoneSonglistPanel viewportGeometry model.mediaPlayer
        --     ]

viewPhoneLandingPanel viewportGeometry mpd =
    let

        -- we also pass in "selected" to know which background to color differently
        customViewAlbum selected ind album =
            E.el
                [ E.height <| E.px (Palette.padding4 + Palette.padding2)
                , E.width E.fill
                , EBackground.color <|
                    case selected of
                        MediaPlayer.Selected alb _ ->
                            if ind == alb then
                                Palette.color2
                            else
                                Palette.color1
                        MediaPlayer.Default _ _ ->
                            Palette.color1
                , E.htmlAttribute <| Html.Attributes.style "cursor" "pointer"
                , EEvents.onClick <| Msg.SelectedAlbum ind
                ]
                <| viewAlbum ind album

        albumsList =
            Array.indexedMap (customViewAlbum mpd.selected) mpd.discography

        actualAlbums =
            E.column
                [ E.width E.fill
                , EBackground.color Palette.color0
                , E.scrollbarY
                ]
                <| Array.toList albumsList
    in
        Windoze.type1Level1DepressedBorder
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

viewAlbum ind album =
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


viewPhonePlayPanel viewportGeometry mpd =
    let

        currentAlbum =
            MediaPlayer.getSelectedAlbum mpd.selected mpd
        currentSong =
            MediaPlayer.getSelectedSong mpd.selected mpd
        elapsed = case mpd.elapsed of
            Nothing ->
                "0:00"
            Just f ->
                format f
        songLength = case mpd.currentSongDuration of
            Just duration ->
                format <| round duration
            Nothing ->
                case Maybe.map .duration currentSong of
                    Just d ->
                        format d
                    Nothing ->
                        "-:--"
        albumTitle =
            case Maybe.map .title currentAlbum of
                Just tit ->
                    tit 
                Nothing ->
                    "____________" -- TODO: Do something cool here

        playOrPauseIcon =
            case mpd.isPlaying of
                True ->
                    pauseIcon
                False ->
                    playIcon

        height0 = 40
        topUserControls =
            let
                littleSeekBarHeight = 5
                restHeight = height0 - littleSeekBarHeight
                maybePerc = 
                    Maybe.map2 
                        (\elaps dur -> ((toFloat (elaps * 100)) / dur)) 
                        mpd.elapsed 
                        mpd.currentSongDuration
            in
            if mpd.playPanelYOffset == height0 then
                E.column
                    [ E.height <| E.px height0
                    , E.width <| E.px viewportGeometry.width
                    -- , E.htmlAttribute <| Html.Attributes.style "cursor" "pointer"
                    ]
                    [ E.el
                        [ E.height <| E.px 5
                        , E.width <| E.px viewportGeometry.width
                        ]
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
                    , E.row
                        [ E.height E.fill
                        , E.width <| E.px viewportGeometry.width

                        , EBackground.color Palette.color0
                        ]
                        [ E.el
                            [ E.width <| E.px Palette.padding2
                            , E.height E.fill
                            , EEvents.onClick Msg.PressedToggleUpPlayMenu
                            , E.htmlAttribute <| Html.Attributes.style "cursor" "pointer"
                            , E.mouseOver
                                [ EBackground.color <| E.rgba255 255 255 255 0.1
                                ]
                            ]
                            <| upIcon
                        , E.column
                            [ E.width <| E.px (viewportGeometry.width - (Palette.padding2 + Palette.padding2 + Palette.padding2 + 10))
                            , E.centerX
                            , EEvents.onClick Msg.PressedToggleUpPlayMenu
                            , E.height E.fill
                            , EFont.family
                                [ EFont.typeface Palette.font0
                                ]
                            ]
                            [ E.el 
                                [ E.centerY
                                , EFont.size 12
                                ]
                                <| E.text "Album"
                            , E.el
                                [ E.centerY
                                , EFont.size Palette.fontSize0
                                ]
                                <| E.text albumTitle
                            ]

                        , E.el
                            [ E.width <| E.px Palette.padding2
                            , E.height E.fill
                            -- , EBackground.color Palette.gray1
                            , EEvents.onClick Msg.PressedPlayOrPause
                            , E.htmlAttribute <| Html.Attributes.style "cursor" "pointer"
                            , E.mouseOver
                                [ EBackground.color <| E.rgba255 255 255 255 0.1
                                ]
                            ]
                            <| playOrPauseIcon

                        , E.el
                            [ E.width <| E.px Palette.padding2
                            , E.height E.fill
                            -- , EBackground.color Palette.gray1
                            , EEvents.onClick Msg.PressedNextSong
                            , E.htmlAttribute <| Html.Attributes.style "cursor" "pointer"
                            , E.mouseOver
                                [ EBackground.color <| E.rgba255 255 255 255 0.1
                                ]
                            ]
                            <| nextIcon
                        ]
                    ]
            else
                E.row
                    [ E.width <| E.px viewportGeometry.width
                    , E.height <| E.px height0
                    , E.centerX
                    -- , EBackground.color <| E.rgb255 80 80 80
                    ]
                    [ E.el

                        [ E.width <| E.px Palette.padding2
                        , E.height <| E.px Palette.padding2
                        -- , EBackground.color Palette.gray1
                        , EEvents.onClick Msg.PressedToggleDownPlayMenu
                        , E.htmlAttribute <| Html.Attributes.style "cursor" "pointer"
                        , E.mouseOver
                            [ EBackground.color <| E.rgba255 255 255 255 0.1
                            ]
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
                        , EEvents.onClick Msg.PressedSongsMenuButton
                        , E.htmlAttribute <| Html.Attributes.style "cursor" "pointer"
                        , E.mouseOver
                            [ EBackground.color <| E.rgba255 255 255 255 0.1
                            ]
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
                            "s  e w e r   s  l v t"--TODO: here too
                        Just song ->
                            song.artist

        albumCoverAvailableHeight = viewportGeometry.height - (height0 + height1 + height2 + height3)
        albumCoverAvailableWidth = viewportGeometry.width
        albumCover =
            E.el
                [ E.height <| E.px albumCoverAvailableHeight
                , E.width <| E.px albumCoverAvailableWidth
                ]
                <| E.el
                    [ E.centerX
                    , E.centerY
                    , E.width <| E.px (albumCoverAvailableWidth - Palette.padding2)
                    , E.height <| E.px albumCoverAvailableHeight
                    ]
                    <| E.el
                        [ E.width <| E.px (min albumCoverAvailableHeight (albumCoverAvailableWidth - Palette.padding2))
                        , E.height <| E.px (min albumCoverAvailableHeight (albumCoverAvailableWidth - Palette.padding2))
                        , E.centerX
                        , E.centerY
                        ]
                        <| Windoze.type1Level1DepressedBorder
                            <| E.image
                                -- [ E.width <| E.maximum (viewportGeometry.width - Palette.padding2) E.fill
                                -- , E.height <| E.maximum (viewportGeometry.width - Palette.padding2) E.fill

                                [ E.width <| E.px ((min albumCoverAvailableHeight (albumCoverAvailableWidth - Palette.padding2)) - 2)
                                , E.height <| E.px ((min albumCoverAvailableHeight (albumCoverAvailableWidth - Palette.padding2)) - 2)
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
        height1 = Palette.padding3
        trackTitleAndArtist =
            E.el
                [ EFont.family
                    [ EFont.typeface Palette.font0
                    ]
                , E.centerX
                , E.centerY
                , E.height <| E.px height1
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

        height2 = Palette.padding3
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
                        sliderHeight = 24
                        -- TODO: I may refactor this. also, maybe we can make it faster
                        maybePerc =
                            Maybe.map2 (\elaps dur -> ((toFloat (elaps * 100)) / dur)) mpd.elapsed mpd.currentSongDuration
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
                                    , max = 100
                                    , onChange = (\val -> Msg.MediaPlayerTrackSliderMoved val)
                                    , value = case maybePerc of
                                        Just d ->
                                            d
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

        height3 = Palette.padding3
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
                    [ regularButton32 mpd.shouldShuffle shuffleIcon Msg.PressedToggleShuffle
                    , regularButton32 False prevIcon Msg.PressedPrevSong
                    , playButton playOrPauseIcon Msg.PressedPlayOrPause
                    , regularButton32 False nextIcon Msg.PressedNextSong
                    , regularButton32 mpd.shouldRepeat repeatIcon Msg.PressedToggleRepeat
                    ]
    in
        E.column
            [ E.width <| E.px viewportGeometry.width
            , E.height <| E.px viewportGeometry.height
            , EBackground.color Palette.color0
            -- , E.htmlAttribute <| Html.Attributes.style "overflow" "hidden"
            -- , E.inFront <| 
            --     E.el
            --         [ E.width <| E.px viewportGeometry.width
            --         , E.height <| E.px viewportGeometry.height
            --         , E.htmlAttribute <| Html.Attributes.style "transform" ("translateX(" ++ (String.fromInt (viewportGeometry.width - mpd.songsPanelXOffset )) ++ "px)")
            --         ]
            --         <| viewPhoneSonglistPanel
            --             viewportGeometry
            --             mpd
            ]
            [ topUserControls
            , albumCover
            , trackTitleAndArtist
            , Windoze.hSeparator
            , sliderAndTimeEl
            , bottomButtons
            ]

viewPhoneSonglistPanel viewportGeometry mpd =
    let
        currentAlbum =
            MediaPlayer.getSelectedAlbum mpd.selected mpd

        viewCurrentAlbum album =
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
                    -- , EBackground.color <| E.rgb255 80 80 80
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
                        <| case Maybe.map viewCurrentAlbum currentAlbum of
                            Just v ->
                                v
                            Nothing ->
                                E.none
            in
            E.el
                [ E.height E.fill
                , E.width E.fill
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
                                        <| regularButton False (E.el [ E.htmlAttribute <| Html.Attributes.style "transform" "scale(1.7)" ] Windoze.xIcon) Msg.PressedCloseSongsMenuButton
                                ]
                                [ topAlbumInfo
                                , songsList
                                ]
    in
        panel
        -- E.row
        --     [ E.width E.fill
        --     , E.height E.fill
        --     ]
        --     [ E.el
        --         [ E.width <| E.fillPortion 2
        --         , E.height <| E.fill
        --         , EBackground.color <| E.rgba255 140 110 170 0.6
        --         ]
        --         <| E.none
        --     , panel
        --     ]

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

upIcon =
    E.el
        [ E.htmlAttribute <| Html.Attributes.style "transform" "scale(-1)"
        , E.centerX
        , E.centerY
        ]
        <| downIcon

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
            , E.centerY
            , E.centerX
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

pauseIcon = 
    let
        -- we may change the """""""pixel size""""""" later
        p0 = 1
        p1 = 2

        c1 = E.rgba255 0 0 0 1
        c2 = E.rgba255 0 0 0 0

        line col =
            E.el
                [ E.width <| E.px p1
                , E.height E.fill
                , EBackground.color col
                ]
                <| E.none
        drawingWidth = 12
        drawingHeight = 10
    in
        E.row
            [ E.width <| E.px drawingWidth
            , E.height <| E.px drawingHeight
            , E.centerX
            , E.centerY
            ]
            [ line c1
            , line c2
            , line c1
            , line c2
            ]


prevIcon =
    E.el
        [ E.htmlAttribute <| Html.Attributes.style "transform" "scale(-1)"

        , E.centerY
        , E.centerX
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
            , E.centerY
            , E.centerX
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

