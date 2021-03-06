port module Main exposing (..)

import Array
import Browser
import Dict
import Html
import Json.Encode
import Json.Decode
import Init.FileExplorer

import Msg
import Palette
import Programs.FileExplorer
import Programs.MediaPlayer

import Task
import Time

import View

import Window
import Windows

port audioPortToJS : Json.Encode.Value -> Cmd msg
port audioPortFromJS : (Json.Decode.Value -> msg) -> Sub msg

main : Program ViewportGeometry Model Msg.Msg
main = Browser.document
    { init = init
    , view = View.view "Sewerslvt"
    , update = update
    , subscriptions = subscriptions
    }

type alias Programs =
    { fileExplorer : Programs.FileExplorer.FileExplorerData
    -- , poorMansOutlook : Programs.PoorMansOutlook.PoorMansOutlookData
    }

type alias Model =
    { time : Time.Posix
    , zone : Time.Zone
    , viewportGeometry : { width : Int, height : Int }

    , record :
        { absoluteX : Int
        , absoluteY : Int
        , windowX : Int
        , windowY : Int
        }
    , absoluteX : Int
    , absoluteY : Int

    , mediaPlayer : Programs.MediaPlayer.MediaPlayerData
    , programs : Programs
    , windows : Windows.Windows
    , currentTitleBarHeldWindow : Maybe Window.WindowType

    -- TODO: If I want to make this thing wrap properly based on width,
    -- It'll have to be just 1 list, not a few separate ones
    , albums0 : List AlbumData
    , albums1 : List AlbumData
    , currentZIndex : Int
    , debug : Int
    }

type alias AlbumData =
    { coverImage : String
    , title : String
    , maybeAuthor : Maybe String
    }

init : ViewportGeometry -> ( Model, Cmd Msg.Msg )
init flags = 
    let
        model =
            { time = Time.millisToPosix 0
            , zone = Time.utc
            , viewportGeometry = { width = flags.width, height = flags.height }
            -- we'll use this to track how much to move the window
            -- we set these when the mouse is pressed on the window's titlebar
            , record =
                { absoluteX = 0
                , absoluteY = 0
                , windowX = 0
                , windowY = 0
                }
            , absoluteX = 0
            , absoluteY = 0

            , mediaPlayer = Programs.MediaPlayer.init
            , programs = 
                { fileExplorer = Programs.FileExplorer.init
                -- , poorMansOutlook = Programs.PoorMansOutlook.init
                }
            , windows = Windows.initWindows
            , currentTitleBarHeldWindow = Nothing

            , albums0 = Init.FileExplorer.albums0
            , albums1 = Init.FileExplorer.albums1
            , currentZIndex = 1
            , debug = 0
            }

        cmds =
            Task.perform Msg.AdjustTimeZone Time.here
    in
        ( model, cmds )


update : Msg.Msg -> Model -> ( Model, Cmd Msg.Msg )
update msg model =
    case msg of
        Msg.GotViewportGeometry data ->
            let
                model_ =
                    { model
                        | viewportGeometry = Debug.log "" data
                    }
            in
                (model_, Cmd.none)
        Msg.OpenWindow windowType ->
            let
                newZ =
                    model.currentZIndex + 1
                model_ =
                    { model
                        | windows =
                            model.windows
                                |> Windows.openWindow windowType
                                |> Windows.focus windowType
                                |> Windows.changeZIndex windowType newZ
                        , currentZIndex = newZ
                    }
            in
                ( model_, Cmd.none)

        Msg.CloseWindow windowType ->
            let
                model_ =
                    { model
                        | windows = Windows.closeWindow windowType model.windows
                    }
            in
                ( model_, Cmd.none)

        Msg.MinimizeWindow windowType ->
            let
                model_ =
                    { model
                        | windows = Windows.minimize windowType model.windows
                    }
            in
                ( model_, Cmd.none)

        Msg.MouseDownOnTitleBar windowType ->
            let
                recorded = record windowType model
                model_ = 
                    { recorded
                        | windows = Windows.focus windowType model.windows 
                    }
            in
                ( model_, Cmd.none)
        Msg.MouseUpOnTitleBar ->
            let
                model_ =
                    { model
                        | currentTitleBarHeldWindow = Nothing
                    }
                
                cmd_ =
                    Cmd.none

            in
                ( model_, Cmd.none)
        Msg.MouseMoved coords ->
            let
                model_ = 
                    case model.currentTitleBarHeldWindow of
                        Just windowType ->
                            let
                                moveByX = (model.absoluteX - model.record.absoluteX)
                                moveByY = (model.absoluteY - model.record.absoluteY)
                            in
                                { model
                                    | windows = Windows.moveWindow
                                        windowType
                                        { x = model.record.windowX + moveByX
                                        , y = model.record.windowY + moveByY
                                        }
                                        model.windows
                                    , absoluteX = coords.x
                                    , absoluteY = coords.y
                                }
                        Nothing ->
                            { model
                                | absoluteX = coords.x
                                , absoluteY = coords.y
                            }
                cmd_ = Cmd.none
            in
                ( model_, cmd_)
        Msg.StartButtonPressed ->
            let
                model_ = model
                cmd_ = Cmd.none
            in
                ( model_, cmd_)
        Msg.NavbarItemClicked windowType ->
            let
                maybeWin = Dict.get (Window.toString windowType) model.windows
                window = case maybeWin of 
                    Just win ->
                        win
                    Nothing ->
                        Windows.toDefault windowType

                isThisWindowTheSameAsTheOneCurrentlyFocused =
                    case window of
                        (Window.Window t_ geometry) ->
                            case geometry.isFocused of
                                True ->
                                    True
                                False ->
                                    False
                model_ =
                    let
                        newZ = model.currentZIndex + 1
                    in
                    case isThisWindowTheSameAsTheOneCurrentlyFocused of
                        True ->
                            { model
                                -- TODO: un-focus everything
                                | windows = Windows.minimize windowType model.windows
                            }
                        False ->
                            let
                                newWins =
                                    model.windows
                                        |> Windows.unMinimize windowType
                                        |> Windows.changeZIndex windowType newZ
                            in
                            { model 
                                | windows = newWins
                                , currentZIndex = newZ
                            }

                cmd_ = Cmd.none
            in
                ( model_, cmd_)

        Msg.WindowClicked windowType ->
            let
                newZ = model.currentZIndex + 1
                
                newWins = 
                    model.windows
                        |> Windows.changeZIndex windowType newZ
                        |> Windows.focus windowType

                model_ = 
                    { model 
                        | windows = newWins
                        , currentZIndex = newZ
                    }
                cmd_ = Cmd.none
            in
                ( model_, cmd_)
        -- Msg.TickLoadingAnimation time ->
        --     let
        --         model_ =
        --             { model
        --                 | time = time
        --                 , mediaPlayer = Programs.MediaPlayer.stepAnimation model.mediaPlayer
        --             }
        --         cmd_ = Cmd.none
        --     in
        --         ( model_, cmd_)
        Msg.AdjustTimeZone zone ->
            let
                model_ =
                    { model
                        | zone = zone
                    }
                cmd_ = Cmd.none
            in
                ( model_, cmd_)

        Msg.GotDiscography data ->
            let
                model_ = 
                    { model 
                        | mediaPlayer = Programs.MediaPlayer.updateDiscography data model.mediaPlayer
                    }
                cmd_ =
                    Cmd.none
            in
                ( model_, cmd_)
        Msg.GotSelectedAlbumAndSong sel ->
            let
                model_ =
                    { model
                        | mediaPlayer = Programs.MediaPlayer.updateSelected sel model.mediaPlayer
                    }
                cmd_ =
                    Cmd.none
            in
                (model_, cmd_)
        Msg.GotTimeData data ->
            let
                model_ =
                    { model
                        -- | mediaPlayer = Debug.log "should UPDATE" (Programs.MediaPlayer.updateTimeData data model.mediaPlayer)
                        | mediaPlayer = Programs.MediaPlayer.updateTimeData data model.mediaPlayer
                    }
                cmd_ =
                    Cmd.none
            in
                ( model_, cmd_ )
        Msg.PressedPlayOrPause ->
            ( model, togglePlayCMD )
        Msg.PressedNextSong ->
            ( model, nextCMD )
        Msg.PressedPrevSong ->
            ( model, prevCMD )
        Msg.PressedToggleShuffle ->
            -- contrary to the way we do other things, we update our state here
            -- anyway, since this cannot fail
            let
                model_ = 
                    { model
                        | mediaPlayer = Programs.MediaPlayer.toggleShuffle model.mediaPlayer
                    }
                    
            in
            ( model_, toggleShuffleCMD )
        Msg.PressedToggleRepeat ->
            -- contrary to the way we do other things, we update our state here
            -- anyway, since this cannot fail
            let
                model_ = 
                    { model
                        | mediaPlayer = Programs.MediaPlayer.toggleRepeat model.mediaPlayer
                    }
                    
            in
            ( model_, toggleRepeatCMD )

        Msg.MediaPlayerTrackSliderMoved float ->
            let
                model_ = model
                cmd_ = seekCMD float
            in
                (model_, cmd_)

        Msg.PressedSongsMenuButton ->
            let
                model_ =
                    { model
                        | mediaPlayer = Programs.MediaPlayer.updateSongsPanelXOffset 1.0 model.mediaPlayer
                    }
                cmd_ = Cmd.none
            in
                (model_, cmd_)

        Msg.PressedCloseSongsMenuButton ->
            let
                model_ =
                    { model
                        | mediaPlayer = Programs.MediaPlayer.updateSongsPanelXOffset 0.0 model.mediaPlayer
                    }
                cmd_ = Cmd.none
            in
                (model_, cmd_)

    
        Msg.PressedToggleDownPlayMenu ->
            let
                model_ = 
                    { model
                        | mediaPlayer = Programs.MediaPlayer.updatePlayPanelYOffset 0.12 model.mediaPlayer
                    }
                cmd_ = Cmd.none
            in
                (model_, cmd_)

        Msg.PressedToggleUpPlayMenu ->
            let
                model_ = 
                    { model
                        | mediaPlayer = Programs.MediaPlayer.updatePlayPanelYOffset 1.0 model.mediaPlayer
                    }
                cmd_ = Cmd.none
            in
                (model_, cmd_)
        Msg.SelectedAlbum albumIndex ->
            let
                model_ = 
                    { model
                        | mediaPlayer = Programs.MediaPlayer.updatePlayPanelYOffset 1.0 model.mediaPlayer
                    }
                cmd_ = selectAlbumCMD albumIndex
            in
                (model_, cmd_)
        Msg.SelectedAlbumFromFileExplorer albumIndex ->
            let
                newZ =
                    model.currentZIndex + 1
                windowType = Window.MediaPlayerMainWindow
                model_ =
                    { model
                        | windows =
                            model.windows
                                |> Windows.openWindow windowType
                                |> Windows.focus windowType
                                |> Windows.changeZIndex windowType newZ
                        , currentZIndex = newZ
                        , mediaPlayer = Programs.MediaPlayer.updatePlayPanelYOffset 1.0 model.mediaPlayer
                    }
                cmd_ = selectAlbumCMD albumIndex
            in
                ( model_, cmd_ )
        Msg.SelectedSong albumIndex songIndex ->
            let
                model_ = model
                cmd_ = selectSongCMD albumIndex songIndex
            in
                (model_, cmd_)
        Msg.SongLoaded ->
            ( model, Cmd.none )
        Msg.SongPlaying ->
            ( model, Cmd.none )
        Msg.SongPaused ->
            ( model, Cmd.none )
        Msg.SongEnded ->
            ( model, Cmd.none )
        Msg.JsonParseError str ->
            let
                _ = Debug.log "uh ohhh" str
            in
            (model, Cmd.none)
        Msg.NoOp ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg.Msg
subscriptions model =
    Sub.batch
        [ audioPortFromJS fromJSPortSub
        ]

record : Window.WindowType -> Model -> Model
record windowType model =
    let
        windowKey = 
            Window.toString windowType

        maybeWindow = Dict.get windowKey model.windows

        oldRec = model.record
        newRec =
            case maybeWindow of
                Just (Window.Window _ geometry) ->
                    { oldRec
                        | windowX = geometry.x
                        , windowY = geometry.y
                        , absoluteX = model.absoluteX
                        , absoluteY = model.absoluteY
                    }
                Nothing ->
                    model.record
    in
        { model
            | record = newRec
            , currentTitleBarHeldWindow = 
                Just windowType
        }

fromJSPortSub json =
    case Json.Decode.decodeValue audioPortFromJSDecoder json of
        Ok val ->
            val
        Err err ->
            Msg.JsonParseError (Json.Decode.errorToString err)

audioPortFromJSDecoder =
    let
        branchType t =
            case t of
                0 ->
                    Json.Decode.map 
                        (\str ->
                            case str of
                                "SONG_PLAYING" ->
                                    Msg.SongPlaying
                                "SONG_PAUSED" ->
                                    Msg.SongPaused
                                "SONG_LOADED" ->
                                    Msg.SongLoaded
                                "SONG_ENDED" ->
                                    Msg.SongEnded
                                _ ->
                                    Msg.JsonParseError str
                        )
                        eventDecoder
                1 ->
                    Json.Decode.map (\data -> Msg.GotDiscography data) discographyDecoder
                2 ->
                    Json.Decode.map (\data -> Msg.GotTimeData data) timeDataDecoder
                3 ->
                    Json.Decode.map (\data -> Msg.GotSelectedAlbumAndSong data) selectedDecoder
                4 ->
                    Json.Decode.map (\data -> Msg.GotViewportGeometry data) viewportDataDecoder
                _ ->
                    Msg.JsonParseError ("bizarro type number: " ++ String.fromInt t) |> Json.Decode.succeed
    in
    Json.Decode.field "type" Json.Decode.int
        |> Json.Decode.andThen 
            branchType


type alias ViewportGeometry =
    { width : Int
    , height : Int
    }

viewportDataDecoder : Json.Decode.Decoder ViewportGeometry
viewportDataDecoder =
    let
        vpDecoder =
            Json.Decode.map2 ViewportGeometry
                (Json.Decode.field "width" Json.Decode.int)
                (Json.Decode.field "height" Json.Decode.int)
    in
        Json.Decode.field "viewportGeometry" vpDecoder
    

-- there may be a bug in either the compiler, or some core library.
-- tried to decode the "elapsed" field as a float, decoded it, stored it in my 
-- model, and then when i tried to use it somewhere where a float was needed, 
-- it told me that the value i was passing in was an Int i tried `toFloat`, and 
-- then it complained that the value was already a float
-- obviously, this is clownworld;
-- elm: "you need a float here!"
-- me: "ok, `toFloat value`"
-- elm: "its already a float!"
-- me: "what"
-- TODO: Try to encode the floats as a JSON string on the JS side and then try 
-- to parse them here
timeDataDecoder : Json.Decode.Decoder Programs.MediaPlayer.TimeData
timeDataDecoder =
    Json.Decode.map4 Programs.MediaPlayer.TimeData
        (Json.Decode.field "elapsed" (Json.Decode.nullable Json.Decode.int))
        (Json.Decode.field "duration" Json.Decode.float)
        (Json.Decode.field "isPlaying" Json.Decode.bool)
        (Json.Decode.field "isLoaded" Json.Decode.bool)
songDataDecoder : Json.Decode.Decoder  Programs.MediaPlayer.SongData
songDataDecoder =
    Json.Decode.map3 Programs.MediaPlayer.SongData
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.field "artist" Json.Decode.string)
        (Json.Decode.field "duration" Json.Decode.int)

-- albumDataDecoder : Json.Decode.Decoder Programs.MediaPlayer.AlbumData
-- albumDataDecoder =
--     Json.Decode.map3 Programs.MediaPlayer.AlbumData
--         (Json.Decode.field "title" Json.Decode.string)
--         (Json.Decode.field "albumCoverSrc" Json.Decode.string)
--         (Json.Decode.field "songs" (Json.Decode.list songDataDecoder))

albumDecoder : Json.Decode.Decoder Programs.MediaPlayer.Album
albumDecoder =
    Json.Decode.map3 Programs.MediaPlayer.Album
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.field "albumCoverSrc" Json.Decode.string)
        (Json.Decode.field "songs" (Json.Decode.array songDataDecoder))

discographyDecoder : Json.Decode.Decoder (Array.Array Programs.MediaPlayer.Album)
discographyDecoder =
    Json.Decode.field "discography" (Json.Decode.array albumDecoder)

selectedDecoder : Json.Decode.Decoder Programs.MediaPlayer.SelectedAlbumAndSong
selectedDecoder =
    Json.Decode.map2 Programs.MediaPlayer.Selected
        (Json.Decode.field "selectedAlbum" Json.Decode.int)
        (Json.Decode.field "selectedSong" Json.Decode.int)

eventDecoder =
    Json.Decode.field "event" Json.Decode.string

-- playCMD = audioPortToJS (Json.Encode.string "PLAY")
-- pauseCMD = audioPortToJS (Json.Encode.string "PAUSE")
nextCMD = audioPortToJS (Json.Encode.string "NEXT")
prevCMD = audioPortToJS (Json.Encode.string "PREV")
togglePlayCMD = audioPortToJS (Json.Encode.string "TOGGLE_PLAY")
toggleShuffleCMD = audioPortToJS (Json.Encode.string "TOGGLE_SHUFFLE")
toggleRepeatCMD = audioPortToJS (Json.Encode.string "TOGGLE_REPEAT")
selectSongCMD albumIndex songIndex = audioPortToJS 
    <| Json.Encode.object 
        [ ("albumIndex", Json.Encode.int albumIndex)
        , ("songIndex", Json.Encode.int songIndex)
        ]
selectAlbumCMD albumIndex = audioPortToJS
    <| Json.Encode.object
        [ ("onlyAlbumIndex", Json.Encode.int albumIndex) ]

seekCMD perc = audioPortToJS 
    <| Json.Encode.object 
        [("seek", Json.Encode.float perc)]

