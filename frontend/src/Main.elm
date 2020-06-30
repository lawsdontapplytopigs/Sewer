module Main exposing (..)

import Browser
import Html
import Init.FileExplorer

import View.Desktop
import Msg

import Programs
import Programs.FileExplorer
import Programs.WinampRipoff

import Set

import Window
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
    { fileExplorer : Programs.FileExplorer.FileExplorer
    , winampRipoff : Programs.WinampRipoff.WinampRipoff
    -- , brokeAssOutlook : BrokeAssOutlook
    }

type alias Model =
    { time : Float
    , absoluteX : Int
    , absoluteY : Int

    , absoluteRecordX : Int
    , absoluteRecordY : Int

    , programs : Apps
    , currentTitleBarHeldWindow : Maybe Programs.ApplicationWindow

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
            , absoluteRecordX = 0
            , absoluteRecordY = 0

            , programs = 
                { fileExplorer = Programs.FileExplorer.init
                , winampRipoff = Programs.WinampRipoff.init
                }
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
            case window of
                Programs.FileExplorerMainWindow ->
                    let
                        newFileExplorer = 
                            case model.programs.fileExplorer of
                                Programs.FileExplorer.FileExplorer windows specifics ->
                                    Programs.FileExplorer.FileExplorer { mainWindow = (Window.close windows.mainWindow) } specifics
                        programs = 
                            { fileExplorer = newFileExplorer
                            , winampRipoff = model.programs.winampRipoff
                            }
                        model_ =
                            { model
                                | programs = programs
                            }

                        cmd_ = Cmd.none
                    in
                    ( model_, cmd_
                    )
                Programs.WinampMainWindow ->
                    ( model, Cmd.none )

                Programs.WinampPlaylistWindow ->
                    ( model, Cmd.none )

        Msg.MouseDownOnTitleBar window ->
            (
                { model
                    -- | fileExplorerStartX = model.fileExplorerX
                    -- , fileExplorerStartY = model.fileExplorerY
                    | absoluteRecordX = model.absoluteX
                    , absoluteRecordY= model.absoluteY
                    , currentTitleBarHeldWindow = Debug.log "titleBar window" (Just window)
                    -- | fileExplorerMouseDownOnTitleBar = True
                }
            , Cmd.none
            )
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
                                moveByX = model.absoluteX - model.absoluteRecordX
                                moveByY = model.absoluteY - model.absoluteRecordY

                            in
                                { model
                                    | absoluteX = coords.x
                                    , absoluteY = coords.y
                                    
                                    -- , fileExplorerX = model.fileExplorerStartX + moveByX
                                    -- , fileExplorerY = model.fileExplorerStartY + moveByY
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

-- HELPERS
-- decodeMouse : (Int -> Int -> Msg.Msg) -> JD.Decoder Msg.Msg
-- decodeMouse mapper =
--     JD.map2 mapper
--         (JD.field "clientX" int)
--         (JD.field "clientY" int)

