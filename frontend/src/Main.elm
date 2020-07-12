module Main exposing (..)

import Browser
import Dict
import Html
import Init.FileExplorer

import Msg
import Programs.FileExplorer
import Programs.WinampRipoff
import Programs.PoorMansOutlook

import View.Desktop

import Window
import Windows
-- import Browser.Events exposing (onAnimationFrameDelta, onMouseDown, onMouseMove, onMouseUp, onResize)
-- import Json.Decode as JD exposing (int)
-- import Time exposing (Posix(..), posixToMillis)


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
    { time : Float
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
            { time = 0
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
            , debug = 0
            }

        cmds =
            Cmd.none
    in
        ( model, cmds )


update : Msg.Msg -> Model -> ( Model, Cmd Msg.Msg )
update msg model =
    case msg of
        Msg.Tick dt ->
            ( { model | time = model.time + dt / 1000 }, Cmd.none )
        Msg.OpenWindow window ->
            let
                model_ =
                    { model
                        | windows = Windows.openWindow model.windows window 
                    }
            in
                ( model_, Cmd.none )
        Msg.MouseDownOnTitleBar windowType ->
            let
                recorded = record windowType model
                model_ = 
                    { recorded
                        | windows = Windows.focus model.windows windowType
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
                                        model.windows
                                        { x = model.record.windowX + moveByX
                                        , y = model.record.windowY + moveByY
                                        }
                                        windowType
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
                model_ = Debug.log "sent?" model
            in
                ( model_, Cmd.none )
        Msg.StartButtonPressed ->
            let
                model_ = Debug.log "START" model
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
                    case isThisWindowTheSameAsTheOneCurrentlyFocused of
                        True ->
                            { model
                                | windows = Windows.minimize model.windows windowType
                            }
                        False ->
                            { model 
                                | windows = Windows.unMinimize model.windows windowType
                            }
            in
                (model_, Cmd.none)

subscriptions : Model -> Sub Msg.Msg
subscriptions model =
    Sub.none

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

-- HELPERS
-- decodeMouse : (Int -> Int -> Msg.Msg) -> JD.Decoder Msg.Msg
-- decodeMouse mapper =
--     JD.map2 mapper
--         (JD.field "clientX" int)
--         (JD.field "clientY" int)

