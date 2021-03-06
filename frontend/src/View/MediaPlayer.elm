module View.MediaPlayer exposing
    ( viewPhone
    , viewTablet
    )

import Array
import Classify
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

ensureMin minim val =
    if val > minim then
        val
    else
        minim
-- given a maximum height and a percentage, you get an int denoting the size
-- in pixels of the percentage you passed into the function
getPxSize maxSize perc =
    round <| (toFloat maxSize) * perc

logScale base val =
    round (logBase base (toFloat val))
    
viewTablet viewportGeometry model =
    let
        borderWidth = 2
        mpd = model.mediaPlayer
        height0 = getPxSize (min viewportGeometry.width viewportGeometry.height) 0.16


        fontSize0 = round (((toFloat (min viewportGeometry.height viewportGeometry.width)) / 100) * 1.8)
        fontSize1 = round (((toFloat (min viewportGeometry.height viewportGeometry.width)) / 100) * 2.0)
        fontSize2 = round (((toFloat (min viewportGeometry.height viewportGeometry.width)) / 100) * 2.6)
        fontSize3 = round (((toFloat (min viewportGeometry.height viewportGeometry.width)) / 100) * 3.0)
        -- fontSize0 = round (logBase 1.2 (((toFloat (min viewportGeometry.height viewportGeometry.width)) / 100) * 3.3))
        -- fontSize1 = round (logBase 1.22 (((toFloat (min viewportGeometry.height viewportGeometry.width)) / 100) * 3.9))
        -- fontSize2 = round (logBase 1.22 (((toFloat (min viewportGeometry.height viewportGeometry.width)) / 100) * 4.5))
        -- fontSize3 = round (logBase 1.15 (((toFloat (min viewportGeometry.height viewportGeometry.width)) / 100) * 5.5))

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
                Just titl ->
                    titl
                Nothing ->
                    "____________" -- TODO: Do something cool here

        buttonSize = ensureMin 38 (getPxSize height0 0.37)
        playButtonSize = ensureMin 48 (getPxSize height0 0.43)

        trackName =
            E.el
                [ EFont.bold
                , EFont.family
                    [ EFont.typeface Palette.font0
                    ]
                , EFont.size fontSize2
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
                [ EFont.size fontSize1
                , EFont.family
                    [ EFont.typeface Palette.font0
                    ]
                ]
                <| E.text
                    <| case currentSong of
                        Nothing ->
                            "s  e w e r   s  l v t"--TODO: here too
                        Just song ->
                            song.artist

        playOrPauseIcon =
            let
                playingOrPausedIcon =
                    case mpd.isPlaying of
                        True ->
                            pauseIcon
                        False ->
                            playIcon
            in
            case mpd.loadingState of
                MediaPlayer.Loaded ->
                    playingOrPausedIcon
                MediaPlayer.Loading ->
                    loadingIcon
                    -- case Maybe.map Zipper.current maybeZipper of
                    --     Just src_ ->
                    --         loadingIcon src_
                    --     Nothing ->
                    --         playingOrPausedIcon

        playButton32 msg =
            E.el
                [ E.width <| E.px playButtonSize
                , E.height <| E.px playButtonSize
                ]
                <| regularButton borderWidth False (scaleIc playButtonSize playOrPauseIcon) msg
        regularButton32 isPushedIn icon msg =
            E.el
                [ E.width <| E.px buttonSize
                , E.height <| E.px buttonSize
                ]
                <| regularButton borderWidth isPushedIn (scaleIc buttonSize icon) msg

        wideButton isPushedIn icon msg =
            E.el
                [ E.width <| E.px (buttonSize * 2)
                , E.height <| E.px buttonSize
                ]
                <| regularButton borderWidth isPushedIn (scaleIc buttonSize icon) msg

        artistNameAndSongTimeData = 
            E.row
                [ E.width E.fill
                , EFont.family
                    [ EFont.typeface Palette.font0
                    ]
                , EFont.size fontSize1
                ]
                [ artistName
                , E.el
                    [ E.alignRight
                    ]
                    <| E.text (elapsed ++ "/" ++ songLength)
                ]

        bottomControlBar =
            E.row
                [ E.height <| E.px height0
                , E.width E.fill
                , EBackground.color Palette.color0
                , E.paddingXY 20 0
                , E.spacing 40
                ]
                [ E.row
                    [ E.centerX
                    , E.centerY
                    , E.height E.fill
                    , E.spacing 10
                    ]
                    [ regularButton32 False prevIcon Msg.PressedPrevSong
                    , playButton32 Msg.PressedPlayOrPause
                    , regularButton32 False nextIcon Msg.PressedNextSong
                    ]
                , E.column
                    [ E.width E.fill
                    , E.spacing 4
                    ]
                    [ trackName
                    , windowsLoadingBarSlider
                    , artistNameAndSongTimeData
                    ]
                , E.row
                    [ E.centerX
                    , E.centerY
                    , E.height E.fill
                    , E.spacing 10
                    ]
                    [ wideButton mpd.shouldShuffle shuffleIcon Msg.PressedToggleShuffle
                    , wideButton mpd.shouldRepeat repeatIcon Msg.PressedToggleRepeat
                    ]
                ]
            
        windowsLoadingBarSlider =
            let
                sliderHeight = getPxSize height0 0.18
                -- TODO: I may refactor this. also, maybe we can make it faster
                maybePerc =
                    Maybe.map2 (\elaps dur -> ((toFloat (elaps * 100)) / dur)) mpd.elapsed mpd.currentSongDuration
            in
                E.el
                    [ E.width <| E.fill
                    , E.height <| E.minimum 24 (E.px sliderHeight)
                    ]
                    <| Windoze.type1Level1DepressedBorder borderWidth
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
                                                , EBackground.color Palette.color3
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

        width0 = (getPxSize viewportGeometry.width 0.65) - borderWidth
        leftSidePanel =
            let
                viewCurrentAlbum album =
                    let
                        buttonText txt =
                            E.el 
                                [ E.centerX
                                , E.centerY
                                , EFont.family
                                    [ EFont.typeface Palette.font0
                                    ]
                                , EFont.size fontSize1
                                ]
                                <| E.text txt
                        buyAlbumText =
                            E.newTabLink
                                [ E.centerX
                                , E.centerY
                                , EFont.family
                                    [ EFont.typeface Palette.font0
                                    ]
                                , EFont.size fontSize1
                                ]
                                { url = "https://sewerslvt.bandcamp.com"
                                , label = E.text "buy album"
                                }
                        roundedPlayButton = 
                            roundedTextButton 
                                borderWidth 
                                False 
                                Palette.color2 
                                (fontSize1 * 5)
                                (fontSize1 * 2)
                                (buttonText "Play")
                                (Msg.SelectedSong (MediaPlayer.getAlbumIndex mpd.selected) 0)
                        roundedBuyAlbumButton =
                            roundedTextButton 
                                borderWidth 
                                False 
                                Palette.color0
                                (fontSize1 * 5)
                                (fontSize1 * 2)
                                buyAlbumText
                                Msg.NoOp
                        albumCov =
                            E.el
                                [ E.width <| E.px height0
                                , E.height <| E.px height0
                                ]
                                <| Windoze.type1Level1DepressedBorder borderWidth
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
                            , E.height <| E.px (round ((toFloat height0 * 1.5)))
                            , E.centerY
                            , EBackground.color Palette.color0
                            , E.paddingXY 20 0
                            ]
                            [ albumCov
                            , E.column
                                [ E.spacing 5
                                , E.paddingEach { top = 0, right = 0 , bottom = 0, left = 30 }
                                , EFont.family
                                    [ EFont.typeface Palette.font0
                                    ]
                                -- , EBackground.color <| E.rgb255 80 80 80
                                , E.width E.fill
                                ]
                                [ E.el
                                    [ EFont.size fontSize0
                                    , EFont.color <| E.rgb255 40 40 40
                                    ]
                                    <| E.text "album"
                                , E.paragraph
                                    [ EFont.size fontSize3
                                    , E.width E.fill
                                    , EFont.bold
                                    ]
                                    [ E.text album.title
                                    ]
                                , E.el
                                    [ EFont.size fontSize1
                                    , EFont.color <| E.rgb255 30 30 30
                                    ]
                                    <| E.text <| (String.fromInt numberOfTracks) ++ " tracks, " ++ (String.fromInt albumNumberOfMinutes) ++ " minutes"
                                , E.row
                                    [ E.spacing 10
                                    ]
                                    [ roundedPlayButton
                                    , roundedBuyAlbumButton
                                    ]
                                ]
                            ]

                songs : Maybe (Array.Array MediaPlayer.SongData)
                songs =
                    Maybe.map (\v -> v.songs) currentAlbum

                viewSongsList =
                    let
                        maybeArraySongs = Maybe.map2 Array.indexedMap (Just (viewSong { height = viewportGeometry.height - height0, width = width0 - (round ((toFloat width0) * 0.5)) } (MediaPlayer.getSongIndex mpd.selected) (MediaPlayer.getAlbumIndex mpd.selected))) songs
                    in
                        case maybeArraySongs of
                            Just arr ->
                                Array.toList arr
                            Nothing ->
                                [ E.none ]
                songsList =
                    Windoze.type1Level1DepressedBorder borderWidth
                        <| Windoze.type1Level2DepressedBorder borderWidth
                            <| E.el
                                [ E.height E.fill
                                , E.width E.fill
                                , E.scrollbarY
                                , E.inFront
                                    <| E.column
                                        [ E.width E.fill
                                        ]
                                        <| viewSongsList
                                ]
                                <| E.none
            in
                E.column
                    [ E.height E.fill
                    , E.width E.fill
                    ]
                    [ case currentAlbum of
                        Just alb ->
                            viewCurrentAlbum alb
                        Nothing ->
                            E.none
                    , songsList
                    ]
        width1 = getPxSize viewportGeometry.width 0.35
        rightSidePanel =
            let
                customViewAlbum selected ind album =
                    E.el
                        -- [ E.height <| E.px (Palette.padding4 + Palette.padding2)
                        [ E.paddingXY 0 20
                        , E.width E.fill
                        , EBackground.color <|
                            if ind == MediaPlayer.getAlbumIndex mpd.selected then
                                Palette.color2
                            else
                                Palette.color1
                        , E.htmlAttribute <| Html.Attributes.style "cursor" "pointer"
                        , E.mouseOver <|
                            if ind == MediaPlayer.getAlbumIndex mpd.selected then
                                []
                            else
                                [ EBackground.color (E.rgba255 225 210 255 0.9) ]
                        , EEvents.onClick <| Msg.SelectedAlbum ind
                        ]
                        <| viewAlbum borderWidth { viewportGeometry | width = width1 } ind album

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
                E.el
                    [ E.height E.fill
                    , E.width <| E.px width1
                    ]
                    <| Windoze.type1Level1DepressedBorder borderWidth
                        <| Windoze.type1Level2DepressedBorder borderWidth
                            <| E.el
                                [ E.width E.fill
                                , E.height E.fill
                                , E.inFront actualAlbums
                                , EBackground.color Palette.color1
                                    -- <| viewPhoneSonglistPanel 
                                    --     viewportGeometry
                                    --     mpd
                                ]
                                <| E.none
                
                    
    in
    E.column
        [ E.height <| E.px viewportGeometry.height
        , E.width <| E.px viewportGeometry.width
        , EBackground.color Palette.color1
        ]
        [ E.row
            [ E.height E.fill
            , E.width E.fill
            ]
            [ leftSidePanel
            , E.el
                [ E.width <| E.px (borderWidth * 2)
                , E.height E.fill
                , EBackground.color Palette.color0
                ]
                <| E.none
            , rightSidePanel
            ]
        , bottomControlBar
        ]

scaleIc maxSize ic =
    let
        fortyPerc = (((toFloat maxSize) / 100) * 24)
        scalingFactor = fortyPerc / 12 -- we just assume the size of an icon is 12px
    in
    E.el
        [ E.htmlAttribute <| Html.Attributes.style "transform" <| "scale(" ++ (String.fromFloat scalingFactor) ++ ")"
        , E.centerX
        , E.centerY
        ]
        <| ic

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
        playPanelHeightWhenAtTheBottom = round <| (toFloat viewportGeometry.height) * model.mediaPlayer.playPanelYPercentageOffset

        playPanelXPos = 0
        playPanelYPos = viewportGeometry.height - (round <| (toFloat viewportGeometry.height) * model.mediaPlayer.playPanelYPercentageOffset)
        songsPanelXPos = viewportGeometry.width - (round <| (toFloat viewportGeometry.width) * model.mediaPlayer.songsPanelXPercentageOffset)
        songsPanelYPos = 0

        device = Classify.classifyDevice model.viewportGeometry
        borderWidth =
            case device.class of
                Classify.Phone ->
                    2
                Classify.Tablet ->
                    2
                Classify.Desktop ->
                    case device.orientation of
                        Classify.Portrait ->
                            2
                        Classify.Landscape ->
                            1
                Classify.BigDesktop ->
                    1
    in
    E.el
        [ E.width <| E.px viewportGeometry.width
        , E.height <| E.px viewportGeometry.height
        , E.behindContent <|
            E.el
                [ E.height <| E.px <|
                    if model.mediaPlayer.playPanelYPercentageOffset == 0.12 then
                        viewportGeometry.height - playPanelHeightWhenAtTheBottom
                    else
                        viewportGeometry.height
                , E.width <| E.px viewportGeometry.width
                ]
                <| viewPhoneLandingPanel borderWidth viewportGeometry model.mediaPlayer
        , E.inFront <|
            if model.mediaPlayer.playPanelYPercentageOffset == 0.0 then
                E.none
            else
                E.el
                    [ E.htmlAttribute <| Html.Attributes.style "transform" <| "translate(0px, " ++ (String.fromInt playPanelYPos) ++ "px)"
                    , E.height <| E.px viewportGeometry.height
                    , E.width <| E.px viewportGeometry.width
                    ]
                    <| viewPhonePlayPanel borderWidth viewportGeometry model.mediaPlayer

        , E.inFront <|
            if model.mediaPlayer.songsPanelXPercentageOffset == 0.0 then
                E.none
            else
                E.el
                    [ E.width <| E.px viewportGeometry.width
                    , E.height <| E.px viewportGeometry.height
                    , EBackground.color <| E.rgba255 170 120 255 0.5
                    , EEvents.onClick Msg.PressedCloseSongsMenuButton
                    , E.inFront <|
                        E.el
                            [ E.htmlAttribute <| Html.Attributes.style "transform" <| "translate(" ++ (String.fromInt songsPanelXPos) ++ "px, " ++ (String.fromInt songsPanelYPos) ++ "px)"
                            , E.width <| E.px viewportGeometry.width
                            , E.height <| E.px viewportGeometry.height
                            , E.alignRight
                            ]
                            <| viewPhoneSonglistPanel borderWidth viewportGeometry model.mediaPlayer
                    ]
                    <| E.none
        ]
        <| E.none

viewPhoneLandingPanel borderWidth viewportGeometry mpd =
    let

        height0 = round <| ((toFloat (min viewportGeometry.height viewportGeometry.width )) / 100) * 2
        -- we also pass in "selected" to know which background to color differently
        customViewAlbum selected ind album =
            E.el
                -- [ E.height <| E.px (Palette.padding4 + Palette.padding2)
                [ E.paddingXY 0 height0
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
                <| viewAlbum borderWidth viewportGeometry ind album

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
        Windoze.type1Level1DepressedBorder borderWidth
            <| Windoze.type1Level2DepressedBorder borderWidth
                <| E.el
                    [ E.width E.fill
                    , E.height E.fill
                    , E.inFront actualAlbums
                    , EBackground.color Palette.color1
                        -- <| viewPhoneSonglistPanel 
                        --     viewportGeometry
                        --     mpd
                    ]
                    <| E.none

viewAlbum borderWidth viewportGeometry ind album =
    let
        fontSize0 = round (logBase 1.2 (((toFloat (min viewportGeometry.height viewportGeometry.width)) / 100) * 3.3))
        fontSize1 = round (logBase 1.19 (((toFloat (min viewportGeometry.height viewportGeometry.width)) / 100) * 3.9))
        fontSize2 = round (logBase 1.19 (((toFloat (min viewportGeometry.height viewportGeometry.width)) / 100) * 4.5))

        height0 = round <| ((toFloat (min viewportGeometry.height viewportGeometry.width )) / 100) * 24
        albumCov =
            E.el
                [ E.height <| E.minimum 50 (E.px height0)
                , E.width <| E.minimum 50 (E.px height0)
                ]
                <| Windoze.type1Level2RaisedBorder borderWidth
                    <| Windoze.type1Level1RaisedBorder borderWidth
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
            , E.height E.fill
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
                , E.width E.fill
                ]
                [ E.el
                    [ EFont.size fontSize0
                    , EFont.color <| E.rgb255 40 40 40
                    ]
                    <| E.text "album"
                , E.paragraph
                    [ EFont.size fontSize2
                    , E.width E.fill
                    ]
                    [ E.text album.title
                    ]
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
                    [ EFont.size fontSize1
                    , EFont.color <| E.rgb255 30 30 30
                    ]
                    <| E.text <| (String.fromInt numberOfTracks) ++ " tracks, " ++ (String.fromInt albumNumberOfMinutes) ++ " minutes"
                ]
            ]


viewPhonePlayPanel borderWidth viewportGeometry mpd =
    let

        -- lord forgive me
        fontSize0 = round (logBase 1.2 (((toFloat (min viewportGeometry.height viewportGeometry.width)) / 100) * 3.3))
        fontSize1 = round (logBase 1.19 (((toFloat (min viewportGeometry.height viewportGeometry.width)) / 100) * 3.9))
        fontSize2 = round (logBase 1.19 (((toFloat (min viewportGeometry.height viewportGeometry.width)) / 100) * 4.5))

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
                Just titl ->
                    titl
                Nothing ->
                    "____________" -- TODO: Do something cool here
        songTitle =
            case Maybe.map .title currentSong of
                Just titl ->
                    titl
                Nothing ->
                    "WHATS THE TRACK NAME"
        songArtist =
            case Maybe.map .artist currentSong of
                Just artis ->
                    artis
                Nothing ->
                    "sewerslvt"

        playOrPauseIcon =
            let
                playingOrPausedIcon =
                    case mpd.isPlaying of
                        True ->
                            pauseIcon
                        False ->
                            playIcon
            in
            case mpd.loadingState of
                MediaPlayer.Loaded ->
                    playingOrPausedIcon
                MediaPlayer.Loading ->
                    loadingIcon

        -- note: save yourself headache and just work directly with floating 
        -- point numbers when you want to do this kind of thing
        height0 = round (((toFloat viewportGeometry.height) / 100) * 12)
        topUserControls =
            let
                littleSeekBarHeight = round (((toFloat height0) / 100) * 7)
                restHeight = height0 - littleSeekBarHeight
                maybePerc =
                    Maybe.map2 
                        (\elaps dur -> ((toFloat (elaps * 100)) / dur)) 
                        mpd.elapsed 
                        mpd.currentSongDuration
            in
            if mpd.playPanelYPercentageOffset == 0.12 then
                E.column
                    [ E.height <| E.px height0
                    , E.width <| E.px viewportGeometry.width
                    -- , E.htmlAttribute <| Html.Attributes.style "cursor" "pointer"
                    ]
                    [ E.el
                        [ E.height <| E.px littleSeekBarHeight
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
                                        , EBackground.color Palette.color3
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
                            [ E.width <| E.px restHeight
                            , E.height E.fill
                            , EEvents.onClick Msg.PressedToggleUpPlayMenu
                            , E.htmlAttribute <| Html.Attributes.style "cursor" "pointer"
                            , E.mouseOver
                                [ EBackground.color <| E.rgba255 255 255 255 0.1
                                ]
                            ]
                            <| scaleIc restHeight upIcon
                        , E.column
                            [ E.width <| E.px (viewportGeometry.width - (restHeight + restHeight + restHeight + 10))
                            , E.centerX
                            , EEvents.onClick Msg.PressedToggleUpPlayMenu
                            , E.height E.fill
                            , E.spacing 4
                            , EFont.family
                                [ EFont.typeface Palette.font0
                                ]
                            ]
                            [ E.el
                                [ E.centerY
                                , EFont.size fontSize2
                                , EFont.bold
                                ]
                                <| E.text songTitle
                            , E.el
                                [ E.centerY
                                , EFont.size fontSize1
                                ]
                                <| E.text ("by " ++ songArtist)
                            ]

                        , E.el
                            [ E.width <| E.px restHeight
                            , E.height E.fill
                            -- , EBackground.color Palette.gray1
                            , EEvents.onClick Msg.PressedPlayOrPause
                            , E.htmlAttribute <| Html.Attributes.style "cursor" "pointer"
                            , E.mouseOver
                                [ EBackground.color <| E.rgba255 255 255 255 0.1
                                ]
                            ]
                            <| scaleIc restHeight playOrPauseIcon

                        , E.el
                            [ E.width <| E.px restHeight
                            , E.height E.fill
                            -- , EBackground.color Palette.gray1
                            , EEvents.onClick Msg.PressedNextSong
                            , E.htmlAttribute <| Html.Attributes.style "cursor" "pointer"
                            , E.mouseOver
                                [ EBackground.color <| E.rgba255 255 255 255 0.1
                                ]
                            ]
                            <| scaleIc restHeight nextIcon
                        ]
                    ]
            else
                E.row
                    [ E.width <| E.px viewportGeometry.width
                    , E.height <| E.px height0
                    -- , EBackground.color <| E.rgb255 80 80 80
                    ]
                    [ E.el

                        [ E.width <| E.px height0
                        , E.height <| E.px height0
                        -- , EBackground.color Palette.gray1
                        , EEvents.onClick Msg.PressedToggleDownPlayMenu
                        , E.htmlAttribute <| Html.Attributes.style "cursor" "pointer"
                        , E.mouseOver
                            [ EBackground.color <| E.rgba255 255 255 255 0.1
                            ]
                        ]
                        <| scaleIc height0 downIcon
                    , E.column
                        [ E.width E.fill
                        , E.height E.fill
                        , EFont.family
                            [ EFont.typeface Palette.font0
                            ]
                        , E.spacing 4
                        ]
                        [ E.el 
                            [ E.centerX
                            , E.centerY
                            , EFont.size fontSize0
                            , EFont.color <| E.rgb255 30 30 30
                            ]
                            <| E.text "album"
                        , E.el
                            [ E.centerX
                            , E.centerY
                            , EFont.size fontSize1
                            ]
                            <| E.paragraph 
                                [ E.htmlAttribute <| Html.Attributes.style "text-align" "center"
                                ]
                                [ E.text albumTitle
                                ]
                        ]
                    , E.el
                        [ E.width <| E.px height0
                        , E.height <| E.px height0
                        , EEvents.onClick Msg.PressedSongsMenuButton
                        , E.htmlAttribute <| Html.Attributes.style "cursor" "pointer"
                        , E.mouseOver
                            [ EBackground.color <| E.rgba255 255 255 255 0.1
                            ]
                        ]
                        <| scaleIc height0 hamburgerIcon
                    ]
        albumCoverAvailableHeight = viewportGeometry.height - (height0 + height1 + height2 + height3)
        albumCoverAvailableWidth = viewportGeometry.width
        albumCover =
            E.el
                [ E.height <| E.px albumCoverAvailableHeight
                , E.width <| E.px albumCoverAvailableWidth
                -- , EBackground.color <| E.rgb255 20 20 120
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
                        <| Windoze.type1Level1DepressedBorder borderWidth
                            <| E.image
                                [ E.width <| E.px ((min albumCoverAvailableHeight (albumCoverAvailableWidth - Palette.padding2)) - 2)
                                , E.height <| E.px ((min albumCoverAvailableHeight (albumCoverAvailableWidth - Palette.padding2)) - 2)
                                , E.centerX
                                , E.centerY
                                ]
                                { src = 
                                    case Maybe.map .albumCoverSrc currentAlbum of
                                        Nothing ->
                                            "./no_signal_bars.png" --TODO: maybe do something cooler here
                                        Just src ->
                                            src
                                , description = "" -- TODO
                                }
        trackName =
            E.el
                [ EFont.bold
                , EFont.size fontSize2
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
                , EFont.size fontSize1
                ]
                <| E.text 
                    <| case currentSong of
                        Nothing ->
                            "s  e w e r   s  l v t"--TODO: here too
                        Just song ->
                            song.artist

        height1 = round (((toFloat viewportGeometry.height) / 100) * 8)
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

        height2 = round (((toFloat viewportGeometry.height) / 100) * 13)
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
                        sliderHeight = (viewportGeometry.height // 100) * 4
                        -- TODO: I may refactor this. also, maybe we can make it faster
                        maybePerc =
                            Maybe.map2 (\elaps dur -> ((toFloat (elaps * 100)) / dur)) mpd.elapsed mpd.currentSongDuration
                    in
                        E.el
                            [ E.width <| E.fill
                            , E.height <| E.minimum 24 (E.px sliderHeight)
                            , E.paddingXY Palette.padding0 0 -- TODO: maybe change this
                            ]
                            <| Windoze.type1Level1DepressedBorder borderWidth
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
                                                        , EBackground.color Palette.color3
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
                    , EFont.size fontSize1
                    , E.width <| E.px (viewportGeometry.width - Palette.padding1)
                    , E.height <| E.px Palette.padding3
                    , E.centerY
                    , E.centerX
                    ]
                    [ makeCuteTimeEl elapsed
                    , windowsLoadingBarSlider
                    , makeCuteTimeEl songLength
                    ]

        height3 = round (((toFloat viewportGeometry.height) / 100) * 24)
        buttonSize = ensureMin 38 (round <| ((toFloat (min viewportGeometry.height viewportGeometry.width )) / 100) * 14)
        playButtonSize = ensureMin 48 (round <| ((toFloat (min viewportGeometry.height viewportGeometry.width )) / 100) * 17)
        bottomButtons =
            let
                playButton32 msg =
                    E.el
                        [ E.width <| E.px playButtonSize
                        , E.height <| E.px playButtonSize
                        ]
                        <| regularButton borderWidth False (scaleIc playButtonSize playOrPauseIcon) msg
                regularButton32 isPushedIn icon msg =
                    E.el
                        [ E.width <| E.px buttonSize
                        , E.height <| E.px buttonSize
                        ]
                        <| regularButton borderWidth isPushedIn (scaleIc buttonSize icon) msg
            in
            E.el
                [ E.height <| E.px height3
                , E.width E.fill
                , E.centerY
                -- , EBackground.color <| E.rgb255 80 80 80
                ]
                <| E.row
                    [ E.centerX
                    , E.centerY
                    , E.spacing 10
                    ]
                    [ regularButton32 mpd.shouldShuffle shuffleIcon Msg.PressedToggleShuffle
                    , regularButton32 False prevIcon Msg.PressedPrevSong
                    , playButton32 Msg.PressedPlayOrPause
                    , regularButton32 False nextIcon Msg.PressedNextSong
                    , regularButton32 mpd.shouldRepeat repeatIcon Msg.PressedToggleRepeat
                    ]
    in
        E.column
            [ E.width <| E.px viewportGeometry.width
            , E.height <| E.px viewportGeometry.height
            , EBackground.color Palette.color0
            ]
            [ topUserControls
            , albumCover
            , trackTitleAndArtist
            , Windoze.hSeparator borderWidth
            , sliderAndTimeEl
            , bottomButtons
            ]

viewPhoneSonglistPanel borderWidth viewportGeometry mpd =
    let

        fontSize0 = round (logBase 1.2 (((toFloat (min viewportGeometry.height viewportGeometry.width)) / 100) * 3.3))
        fontSize1 = round (logBase 1.19 (((toFloat (min viewportGeometry.height viewportGeometry.width)) / 100) * 3.9))
        fontSize2 = round (logBase 1.19 (((toFloat (min viewportGeometry.height viewportGeometry.width)) / 100) * 4.5))
        height0 = round <| ((toFloat (min viewportGeometry.height viewportGeometry.width )) / 100) * 18

        currentAlbum =
            MediaPlayer.getSelectedAlbum mpd.selected mpd

        viewCurrentAlbum album =
            let
                albumCov =
                    E.el
                        [ E.width <| E.px height0
                        , E.height <| E.px height0
                        ]
                        <| Windoze.type1Level1DepressedBorder borderWidth
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
                    , E.height <| E.px (height0 * 2)
                    , E.centerY
                    , E.paddingXY 30 0
                    ]
                    [ albumCov
                    , E.column
                        [ E.spacing 5
                        , E.paddingEach { top = 0, right = 0 , bottom = 0, left = 30 }
                        , EFont.family
                            [ EFont.typeface Palette.font0
                            ]
                        -- , EBackground.color <| E.rgb255 80 80 80
                        , E.width E.fill
                        ]
                        [ E.el
                            [ EFont.size fontSize0
                            , EFont.color <| E.rgb255 40 40 40
                            ]
                            <| E.text "album"
                        , E.paragraph
                            [ EFont.size fontSize2
                            , E.width E.fill
                            , EFont.bold
                            ]
                            [ E.text album.title
                            ]
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
                            [ EFont.size fontSize1
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
                maybeArraySongs = Maybe.map2 Array.indexedMap (Just (viewSong viewportGeometry (MediaPlayer.getSongIndex mpd.selected) (MediaPlayer.getAlbumIndex mpd.selected))) songs
            in
                case maybeArraySongs of
                    Just arr ->
                        Array.toList arr
                    Nothing ->
                        [ E.none ]

        panel =
            let
                songsList =
                    Windoze.type1Level1DepressedBorder borderWidth
                        <| Windoze.type1Level2DepressedBorder borderWidth
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
                        [ E.height <| E.px (height0 * 2)
                        , E.width E.fill
                        , EBackground.color Palette.color0
                        ]
                        <| case Maybe.map viewCurrentAlbum currentAlbum of
                            Just v ->
                                v
                            Nothing ->
                                E.none

                buttonSize = round <| ((toFloat (min viewportGeometry.height viewportGeometry.width )) / 100) * 8
                xIc =
                    E.el 
                        [ E.htmlAttribute <| Html.Attributes.style "transform" "scale(1.7)"
                        ]
                        <| scaleIc buttonSize Windoze.xIcon
            in
            E.el
                [ E.height E.fill
                , E.width E.fill
                , EBackground.color Palette.color1
                ]
                <| Windoze.type1Level2RaisedBorder borderWidth
                    <| Windoze.type1Level1RaisedBorder borderWidth
                        <| Windoze.makeMainBorder (borderWidth * 2)
                            <| E.column
                                [ E.width E.fill
                                , E.height E.fill
                                , E.inFront
                                    <| E.el 
                                        [ E.height <| E.px buttonSize
                                        , E.width <| E.px buttonSize
                                        , E.alignRight
                                        ]
                                        <| regularButton borderWidth False xIc Msg.PressedCloseSongsMenuButton
                                ]
                                [ topAlbumInfo
                                , songsList
                                ]
    in
        panel

viewSong viewportGeometry selectedSongInd albumInd songInd songData =
    let
        fontSize1 = round (logBase 1.19 (((toFloat (min viewportGeometry.height viewportGeometry.width)) / 100) * 3.9))
        fontSize2 = round (logBase 1.19 (((toFloat (min viewportGeometry.height viewportGeometry.width)) / 100) * 4.5))

        width0 = viewportGeometry.width
        padding0 = round <| ((toFloat (min viewportGeometry.height viewportGeometry.width )) / 100) * 5
    in
    E.row
        [ E.width E.fill
        , E.paddingXY 0 padding0
        , EFont.family
            [ EFont.typeface Palette.font0
            ]
        , E.htmlAttribute <| Html.Attributes.style "cursor" "pointer"
        , EEvents.onClick <| Msg.SelectedSong albumInd songInd
        , EBackground.color <|
            if selectedSongInd == songInd then
                Palette.color2
            else
                Palette.color1
        , E.mouseOver <|
            if selectedSongInd == songInd then
                []
            else
                [ EBackground.color (E.rgba255 225 205 255 0.7) ]
        ]
        [ E.el
            [ E.paddingXY Palette.fontSize0 0
            , EFont.size fontSize1
            ]
            -- should we show things 0 indexed, or 1 indexed?
            <| E.text (String.fromInt (songInd + 1)) 
        , E.column
            [ E.spacing 3
            , E.width E.fill
            ]
            [ E.paragraph
                [ EFont.size fontSize2
                , EFont.bold
                , E.width E.fill
                ]
                [ E.text songData.title
                ]
            , E.el
                [ EFont.size fontSize1
                ]
                <| E.text songData.artist
            ]
        , E.el
            [ EFont.size fontSize1
            , E.alignRight
            , E.paddingEach { top = 0, right = Palette.fontSize0, bottom = 0, left = 0 }
            ]
            <| E.text (format songData.duration)
        ]


roundedTextButton borderWidth pushedIn buttonColor width height arbitraryElInFront msg =
    let
        darkest = Palette.gray0
        darker = Palette.gray1
        lightest = Palette.white
        lighter = Palette.gray4

        outerLeftUpColor = if pushedIn == True then darkest else lightest
        outerRightDownColor = if pushedIn == True then lightest else darkest
        innerLeftUpColor = if pushedIn == True then darker else lighter
        innerRightDownColor = if pushedIn == True then lighter else darker

        fillWidth col =
            E.el
                [ E.width E.fill
                , E.height <| E.px borderWidth
                , EBackground.color col
                ]
                <| E.none

        fillButtonHeight =
            E.row
                [ E.height E.fill
                , E.width E.fill
                ]
                [ E.el 
                    [ E.height E.fill
                    , E.width <| E.px borderWidth
                    , EBackground.color outerLeftUpColor
                    ]
                    <| E.none
                , E.el
                    [ E.height E.fill
                    , E.width E.fill
                    , EBackground.color buttonColor
                    ]
                    <| E.none
                , E.el 
                    [ E.height E.fill
                    , E.width <| E.px borderWidth
                    , EBackground.color outerRightDownColor
                    ]
                    <| E.none
                ]
        px col =
            E.el
                [ E.height <| E.px borderWidth
                , E.width <| E.px borderWidth
                , EBackground.color col
                ]
                <| E.none

        row1 =
            E.row
                [ E.width E.fill
                ]
                [ px <| E.rgba 0 0 0 0
                , px <| E.rgba 0 0 0 0
                , fillWidth <| outerLeftUpColor
                , px <| E.rgba 0 0 0 0
                , px <| E.rgba 0 0 0 0
                ]
        row2 =
            E.row
                [ E.width E.fill
                ]
                [ px <| E.rgba 0 0 0 0
                , px outerLeftUpColor
                , px innerLeftUpColor
                , fillWidth innerLeftUpColor
                , px innerRightDownColor
                , px outerRightDownColor
                , px <| E.rgba 0 0 0 0
                ]
        row3 =
            E.row
                [ E.width E.fill
                ]
                [ px outerLeftUpColor
                , px innerLeftUpColor
                , fillWidth <| buttonColor
                , px innerRightDownColor
                , px outerRightDownColor
                ]
        
        row4 =
            E.row
                [ E.width E.fill
                ]
                [ px <| E.rgba 0 0 0 0
                , px outerLeftUpColor
                , px innerLeftUpColor
                , fillWidth innerRightDownColor
                , px innerRightDownColor
                , px outerRightDownColor
                , px <| E.rgba 0 0 0 0
                ]

        row5 =
            E.row
                [ E.width E.fill
                ]
                [ px <| E.rgba 0 0 0 0
                , px <| E.rgba 0 0 0 0
                , fillWidth <| outerRightDownColor
                , px <| E.rgba 0 0 0 0
                , px <| E.rgba 0 0 0 0
                ]
    in
    E.el
        [ E.htmlAttribute <| Html.Attributes.style "tabindex" "0"
        , E.htmlAttribute <| Html.Attributes.style "role" "button"
        , EEvents.onClick msg
        , E.htmlAttribute <| Html.Attributes.style "cursor" "pointer"
        ]
        <| E.column
            [ E.width <| E.px width
            , E.inFront arbitraryElInFront
            , E.height <| E.minimum (borderWidth * 6) (E.px height)
            ]
            [ row1
            , row2
            , row3
            , fillButtonHeight
            , row3
            , row4
            , row5
            ]

regularButton borderWidth pushedIn ic msg =
    let
        outerBorder =
            case pushedIn of
                True ->
                    Windoze.type2Level2DepressedBorder borderWidth
                False ->
                    Windoze.type2Level2RaisedBorder borderWidth
        innerBorder =
            case pushedIn of
                True ->
                    Windoze.type2Level1DepressedBorder borderWidth
                False ->
                    Windoze.type2Level1RaisedBorder borderWidth
                
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

playButton borderWidth ic msg =
    let
        -- TODO: store button information so we know to show these differently 
        -- when they're pressed
        borderOuter =
            Windoze.type2Level2RaisedBorder borderWidth
        borderInner =
            Windoze.type2Level1RaisedBorder borderWidth
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

loadingIcon = 
    E.image
        [ E.height <| E.px 16
        , E.width <| E.px 16
        -- , E.htmlAttribute <| Html.Attributes.style "image-rendering" "-moz-crisp-edges"
        -- , E.htmlAttribute <| Html.Attributes.style "image-rendering" "crisp-edges"
        , E.htmlAttribute <| Html.Attributes.style "image-rendering" "pixelated"
        ]
        { description = "loading..."
        , src = "./loading.gif"
        }

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


