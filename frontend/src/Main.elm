port module Main exposing (..)

import Browser
import Dict
import Html
import Json.Decode as JDecode
import Init.FileExplorer

import Msg
import Programs.FileExplorer
import Programs.WinampRipoff
import Programs.PoorMansOutlook

import Task
import Time

import View.WinampRipoff

import View.Desktop

import Window
import Windows
-- import Browser.Events exposing (onAnimationFrameDelta, onMouseDown, onMouseMove, onMouseUp, onResize)
-- import Json.Decode as JD exposing (int)
-- import Time exposing (Posix(..), posixToMillis)

port winampIn : (String -> msg) -> Sub msg
port winampOut : String -> Cmd msg

main : Program () Model Msg.Msg
main = Browser.document
    { init = init
    , view = View.Desktop.view "Sewerslvt"
    , update = update
    , subscriptions = subscriptions
    }

type alias Programs =
    { fileExplorer : Programs.FileExplorer.FileExplorerData
    , winampRipoff : Programs.WinampRipoff.WinampRipoffData
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

    , programs : Programs
    , windows : Windows.Windows
    , currentTitleBarHeldWindow : Maybe Window.WindowType

    -- TODO: If I want to make this thing wrap properly based on width,
    -- It'll have to be just 1 list, not a few separate ones
    , albums0 : List AlbumData
    , albums1 : List AlbumData
    , currentZIndex : Int
    , debug : String
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

            , programs = 
                { fileExplorer = Programs.FileExplorer.init
                , winampRipoff = Programs.WinampRipoff.init
                , poorMansOutlook = Programs.PoorMansOutlook.init
                }
            , windows = Windows.initWindows
            , currentTitleBarHeldWindow = Nothing

            , albums0 = Init.FileExplorer.albums0
            , albums1 = Init.FileExplorer.albums1
            , currentZIndex = 1
            , debug = ""
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
                cmd_ =
                    case windowType of
                        Window.WinampMainWindow ->
                            winampOut "open"
                        _ ->
                            Cmd.none
            in
                ( model_, cmd_ )

        Msg.CloseWindow windowType ->
            let
                model_ =
                    { model
                        | windows = Windows.closeWindow windowType model.windows
                    }
            in
                (model_, Cmd.none)

        Msg.MinimizeWindow windowType ->
            let
                model_ =
                    { model
                        | windows = Windows.minimize windowType model.windows
                    }
            in
                ( model_, Cmd.none )

        Msg.MouseDownOnTitleBar windowType ->
            let
                recorded = record windowType model
                model_ = 
                    { recorded
                        | windows = Windows.focus windowType model.windows 
                    }
            in
                ( model_ , Cmd.none )
        Msg.MouseUpOnTitleBar ->
            (
                { model
                    | currentTitleBarHeldWindow = Nothing
                }
            , Cmd.none
            )
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
                ( model_, cmd_ )
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
                ( model_, cmd_ )

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
                ( model_, cmd_ )

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
                ( model_, cmd_ )
        Msg.TryToSendEmail ->
            let
                model_ = model
            in
                ( model_, Cmd.none )
        Msg.StartButtonPressed ->
            let
                model_ = model
            in
                (model_, Cmd.none)
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

                cmd_ = case windowType of
                    Window.WinampMainWindow ->
                        case isThisWindowTheSameAsTheOneCurrentlyFocused of
                            True ->
                                winampOut "minimize"
                            False ->
                                winampOut "unMinimize"
                    _ ->
                        Cmd.none
            in
                (model_, cmd_)

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
            in
                (model_, Cmd.none)
        Msg.WinampIn str ->
            let
                windowType = Window.WinampMainWindow

                weenamp = Windows.get windowType model.windows
                newZ = model.currentZIndex + 1
                newWins = 
                    case (View.WinampRipoff.jsonToWinampMsg str) of
                        View.WinampRipoff.WindowClicked ->
                            (model.windows
                                |> Windows.changeZIndex windowType newZ
                                |> Windows.focus windowType
                            )
                        View.WinampRipoff.Close ->
                            Windows.closeWindow windowType model.windows
                        View.WinampRipoff.Minimize ->
                            Windows.minimize windowType model.windows
                        View.WinampRipoff.UnMinimize ->
                            Windows.unMinimize windowType model.windows
                        View.WinampRipoff.SomethingWentTerriblyWrong ->
                            model.windows
                model_ = 
                    { model
                        | windows = newWins
                        , currentZIndex = newZ
                    }
            in
                (model_, Cmd.none)

        Msg.Tick time ->
            let
                model_ =
                    { model
                        | time = time
                    }
            in
                (model_, Cmd.none)
        Msg.AdjustTimeZone zone ->
            let
                model_ =
                    { model
                        | zone = zone
                    }
            in
                (model_, Cmd.none)
        Msg.NoOp ->
            ( model, Cmd.none )

subscriptions : Model -> Sub Msg.Msg
subscriptions model =
    Sub.batch
        [ winampIn Msg.WinampIn
        , Time.every 1000 Msg.Tick
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

