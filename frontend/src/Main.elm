module Main exposing (..)

import Browser
import Dict
import Html
import Init.FileExplorer

import Msg
import Programs.FileExplorer
import Programs.WinampRipoff

import View.Desktop

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

type alias Apps =
    { fileExplorer : Programs.FileExplorer.FileExplorerData
    , winampRipoff : Programs.WinampRipoff.WinampRipoffData
    -- , brokeAssOutlook : BrokeAssOutlook
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

    , programs : Apps
    , windows : Windows.Windows
    , currentTitleBarHeldWindow : Maybe Windows.Window

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
                        | windows = Windows.openWindow window model.windows
                    }
            in
                ( model_, Cmd.none )
        Msg.MouseDownOnTitleBar window ->
            let
                model_ = record window model
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
                        Just window ->
                            let
                                -- _ = Debug.log "start abs X" model.absoluteX
                                -- _ = Debug.log "current abs X " model.record.absoluteX
                                -- _ = Debug.log "MOVE BY" (model.absoluteX - model.record.absoluteX)
                                moveByX = (model.absoluteX - model.record.absoluteX)
                                moveByY = (model.absoluteY - model.record.absoluteY)
                            in
                                { model
                                    | windows = Windows.moveWindow
                                        { x = model.record.windowX + moveByX
                                        , y = model.record.windowY + moveByY
                                        }
                                        window
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

subscriptions : Model -> Sub Msg.Msg
subscriptions model =
    Sub.none

record : Windows.Window -> Model -> Model
record window model =
    let
        windowKey = case window of
            Windows.FileExplorerMainWindow ->
                "FileExplorerMainWindow"
            Windows.WinampMainWindow ->
                "WinampMainWindow"
            Windows.WinampPlaylistWindow ->
                "WinampPlaylistWindow"

        maybeWindow = Dict.get windowKey model.windows

        newRec =
            let
                rec = model.record
            in
            case maybeWindow of
                Just win ->
                    { rec
                        | windowX = win.x
                        , windowY = win.y
                        , absoluteX = model.absoluteX
                        , absoluteY = model.absoluteY
                    }
                Nothing ->
                    model.record
    in
        { model
            | record = newRec
            , currentTitleBarHeldWindow = Just window
        }

-- HELPERS
-- decodeMouse : (Int -> Int -> Msg.Msg) -> JD.Decoder Msg.Msg
-- decodeMouse mapper =
--     JD.map2 mapper
--         (JD.field "clientX" int)
--         (JD.field "clientY" int)

