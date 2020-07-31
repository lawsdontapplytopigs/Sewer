port module Main exposing (..)

import Browser
import Dict
import Html
import Json.Encode
import Json.Decode
import Init.FileExplorer

import Msg
import Programs.FileExplorer
import Programs.MediaPlayer
import Programs.PoorMansOutlook

import Song
import Task
import Time

import View

import Window
import Windows
-- import Browser.Events exposing (onAnimationFrameDelta, onMouseDown, onMouseMove, onMouseUp, onResize)
-- import Json.Decode as JD exposing (int)
-- import Time exposing (Posix(..), posixToMillis)

port audioPortToJS : Json.Encode.Value -> Cmd msg
port audioPortFromJS : (Json.Decode.Value -> msg) -> Sub msg

main : Program ViewportData Model Msg.Msg
main = Browser.document
    { init = init
    , view = View.view "Sewerslvt"
    , update = update
    , subscriptions = subscriptions
    }

type alias Programs =
    { fileExplorer : Programs.FileExplorer.FileExplorerData
    , poorMansOutlook : Programs.PoorMansOutlook.PoorMansOutlookData
    }

type alias Model =
    { time : Time.Posix
    , zone : Time.Zone
    , viewportWidth : Int
    , viewportHeight : Int

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

init : ViewportData -> ( Model, Cmd Msg.Msg )
init flags = 
    let
        model =
            { time = Time.millisToPosix 0
            , zone = Time.utc
            , viewportWidth = Debug.log "width" flags.viewportWidth
            , viewportHeight = Debug.log "height" flags.viewportHeight
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
                , poorMansOutlook = Programs.PoorMansOutlook.init
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
        Msg.GotViewportData data ->
            let
                model_ =
                    { model
                        | viewportWidth = data.viewportWidth
                        , viewportHeight = data.viewportHeight
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
        Msg.EmailInput str ->
            let
                newOutlookData = 
                    Programs.PoorMansOutlook.updateEmail str model.programs.poorMansOutlook

                oldPrograms = model.programs
                newPrograms =
                    { oldPrograms
                        | poorMansOutlook = newOutlookData
                    }

                model_ =
                    { model
                        | programs = newPrograms
                    }
                cmd_ = Cmd.none
            in
                ( model_, cmd_)

        Msg.SubjectInput str ->
            let
                newOutlookData = 
                    Programs.PoorMansOutlook.updateSubject str model.programs.poorMansOutlook

                oldPrograms = model.programs
                newPrograms =
                    { oldPrograms
                        | poorMansOutlook = newOutlookData
                    }

                model_ =
                    { model
                        | programs = newPrograms
                    }
                cmd_ = Cmd.none
            in
                ( model_, cmd_)

        Msg.EmailContentInput str ->
            let
                newOutlookData = 
                    Programs.PoorMansOutlook.updateContent str model.programs.poorMansOutlook

                oldPrograms = model.programs
                newPrograms =
                    { oldPrograms
                        | poorMansOutlook = newOutlookData
                    }

                model_ =
                    { model
                        | programs = newPrograms
                    }
                cmd_ = Cmd.none
            in
                ( model_, cmd_)
        Msg.TryToSendEmail ->
            let
                model_ = model
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
        Msg.Tick time ->
            let
                model_ =
                    { model
                        | time = time
                    }
                cmd_ = Cmd.none
            in
                ( model_, cmd_)
        Msg.AdjustTimeZone zone ->
            let
                model_ =
                    { model
                        | zone = zone
                    }
                cmd_ = Cmd.none
            in
                ( model_, cmd_)

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

        Msg.PlaySongAt ind ->
            ( model, playSongAtCMD ind )

        Msg.GotAlbumData data ->
            let
                model_ = 
                    { model 
                        | mediaPlayer = Programs.MediaPlayer.updateAlbum data model.mediaPlayer
                    }
                cmd_ =
                    Cmd.none
            in
                ( model_, cmd_)
        Msg.GotSongData data ->
            let
                model_ =
                    { model
                        | mediaPlayer = Programs.MediaPlayer.updateCurrentSong data model.mediaPlayer
                    }
                cmd_ =
                    Cmd.none
            in
                ( model_, cmd_ )
        Msg.GotTimeData data ->
            let
                model_ =
                    { model
                        | mediaPlayer = Programs.MediaPlayer.updateTimeData data model.mediaPlayer
                    }
                cmd_ =
                    Cmd.none
            in
                ( model_, cmd_ )
        Msg.MediaPlayerTrackSliderMoved float ->
            let
                model_ = model
                cmd_ = 
                    audioPortToJS (Json.Encode.object [ ("seek", Json.Encode.float float) ])
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
        [ Time.every 1000 Msg.Tick
        , audioPortFromJS fromJSPortSub
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
                    Json.Decode.map (\data -> Msg.GotAlbumData data) albumDataDecoder
                2 ->
                    Json.Decode.map (\data -> Msg.GotTimeData data) timeDataDecoder
                3 ->
                    Json.Decode.map (\data -> Msg.GotSongData data) songDataDecoder
                4 ->
                    Json.Decode.map (\data -> Msg.GotViewportData data) viewportDataDecoder
                _ ->
                    Msg.JsonParseError ("bizarro type number: " ++ String.fromInt t) |> Json.Decode.succeed
    in
    Json.Decode.field "type" Json.Decode.int
        |> Json.Decode.andThen 
            branchType


type alias ViewportData =
    { viewportWidth : Int
    , viewportHeight : Int
    }
viewportDataDecoder : Json.Decode.Decoder ViewportData
viewportDataDecoder =
    Json.Decode.map2 ViewportData
        (Json.Decode.field "viewportWidth" Json.Decode.int)
        (Json.Decode.field "viewportHeight" Json.Decode.int)
    

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
    Json.Decode.map3 Programs.MediaPlayer.TimeData
        (Json.Decode.field "elapsed" (Json.Decode.nullable Json.Decode.int))
        (Json.Decode.field "duration" Json.Decode.float)
        (Json.Decode.field "isPlaying" Json.Decode.bool)
songDataDecoder : Json.Decode.Decoder  Programs.MediaPlayer.SongData
songDataDecoder =
    Json.Decode.map3 Programs.MediaPlayer.SongData
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.field "artist" Json.Decode.string)
        (Json.Decode.field "duration" Json.Decode.int)

albumDataDecoder : Json.Decode.Decoder Programs.MediaPlayer.AlbumData
albumDataDecoder =
    Json.Decode.map3 Programs.MediaPlayer.AlbumData
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.field "albumCoverSrc" Json.Decode.string)
        (Json.Decode.field "songs" (Json.Decode.list songDataDecoder))

eventDecoder =
    Json.Decode.field "event" Json.Decode.string

playCMD = audioPortToJS (Json.Encode.string "PLAY")
pauseCMD = audioPortToJS (Json.Encode.string "PAUSE")
nextCMD = audioPortToJS (Json.Encode.string "NEXT")
prevCMD = audioPortToJS (Json.Encode.string "PREV")
togglePlayCMD = audioPortToJS (Json.Encode.string "TOGGLE_PLAY")
toggleShuffleCMD = audioPortToJS (Json.Encode.string "TOGGLE_SHUFFLE")
toggleRepeatCMD = audioPortToJS (Json.Encode.string "TOGGLE_REPEAT")
playSongAtCMD index = audioPortToJS (Json.Encode.object [ ("playSongAt", Json.Encode.int index) ])
