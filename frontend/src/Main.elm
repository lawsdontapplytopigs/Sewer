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

import View.Desktop

import Window
import Windows
-- import Browser.Events exposing (onAnimationFrameDelta, onMouseDown, onMouseMove, onMouseUp, onResize)
-- import Json.Decode as JD exposing (int)
-- import Time exposing (Posix(..), posixToMillis)

port audioPortToJS : Json.Encode.Value -> Cmd msg
port audioPortFromJS : (Json.Decode.Value -> msg) -> Sub msg

main : Program () Model Msg.Msg
main = Browser.document
    { init = init
    , view = View.Desktop.view "Sewerslvt"
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
    , absoluteX : Int
    , absoluteY : Int

    , record :
        { absoluteX : Int
        , absoluteY : Int
        , windowX : Int
        , windowY : Int
        }

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

init : () -> ( Model, Cmd Msg.Msg )
init flags = 
    let
        model =
            { time = Time.millisToPosix 0
            , zone = Time.utc
            , absoluteX = 0
            , absoluteY = 0

            -- we'll use this to track how much to move the window
            -- we set these when the mouse is pressed on the window's titlebar
            , record =
                { absoluteX = 0
                , absoluteY = 0
                , windowX = 0
                , windowY = 0
                }

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
                        | mediaPlayer = Programs.MediaPlayer.updateSongData data model.mediaPlayer
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
        Msg.SongPaused ->
            (model, Cmd.none)
        Msg.SongPlaying ->
            (model, Cmd.none)
        Msg.SongLoaded ->
            (model, Cmd.none)
        -- TODO: take this out
        Msg.SongEnded ->
            let
                model_ = model
            in
                (model_, Cmd.none)
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
    case Json.Decode.decodeValue decoder json of
        Ok val ->
            val
        Err err ->
            Msg.JsonParseError (Json.Decode.errorToString err)

decoder =
    Json.Decode.oneOf
        [ Json.Decode.map (\data -> Msg.GotSongData data) songDataDecoder
        , Json.Decode.map (\data -> Msg.GotAlbumData data) albumDecoder
        , Json.Decode.map 
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
        ]

songDataDecoder =
    Json.Decode.map4 Programs.MediaPlayer.SongData
        (Json.Decode.field "duration" Json.Decode.float)
        (Json.Decode.field "elapsed" Json.Decode.float)
        (Json.Decode.field "isPlaying" Json.Decode.bool)
        (Json.Decode.field "currentSong" songDecoder)
songDecoder =
    Json.Decode.map2 Programs.MediaPlayer.Song
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.field "artist" Json.Decode.string)

albumDecoder =
    Json.Decode.map3 Programs.MediaPlayer.AlbumData
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.field "albumCoverSrc" Json.Decode.string)
        (Json.Decode.field "songs" (Json.Decode.list songDecoder))

eventDecoder =
    Json.Decode.field "event" Json.Decode.string

playCMD = audioPortToJS (Json.Encode.string "PLAY")
pauseCMD = audioPortToJS (Json.Encode.string "PAUSE")
nextCMD = audioPortToJS (Json.Encode.string "NEXT")
prevCMD = audioPortToJS (Json.Encode.string "PREV")
togglePlayCMD = audioPortToJS (Json.Encode.string "TOGGLE_PLAY")
