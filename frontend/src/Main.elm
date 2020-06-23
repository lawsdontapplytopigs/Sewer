module Main exposing (..)

import Browser
import View.Desktop
import Msg

import Init.FileExplorer

import Types


import Browser
-- import Browser.Events exposing (onAnimationFrameDelta, onMouseDown, onMouseMove, onMouseUp, onResize)
import Html
-- import Json.Decode as JD exposing (int)
-- import Time exposing (Posix(..), posixToMillis)


main : Program () Model Msg.Msg
main = Browser.document
    { init = init
    , view = View.Desktop.view "Sewerslvt"
    , update = update
    , subscriptions = subscriptions
    }

type alias Model =
    { time : Float
    , absoluteX : Int
    , absoluteY : Int


    , absoluteStartX : Int
    , absoluteStartY : Int

    -- file explorer data
    , fileExplorerTitle : String
    , fileExplorerMouseDownOnTitleBar : Bool
    , fileExplorerStartX : Int
    , fileExplorerStartY : Int
    , fileExplorerX : Int
    , fileExplorerY : Int
    , fileExplorerWidth : Int
    , fileExplorerHeight : Int

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
        fileExplorerStartX = 200
        fileExplorerStartY = 70

        model =
            { time = 0
            , absoluteX = 0
            , absoluteY = 0

            -- we'll use this to track how much to move the window
            -- we set these when the mouse is pressed on the window's titlebar
            , absoluteStartX = 0
            , absoluteStartY = 0


            -- , installedPrograms = 
            -- , openPrograms = 
            -- file explorer data
            , fileExplorerTitle = "File Explorer - C://MyDocuments/Albums"
            , fileExplorerMouseDownOnTitleBar = False

            , fileExplorerX = 200
            , fileExplorerY = 70
            , fileExplorerStartX = 0
            , fileExplorerStartY = 0
            , fileExplorerWidth = 500
            , fileExplorerHeight = 300
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
        Msg.OpenApplication app ->
            case app of
                Types.FileExplorer ->
                    ( model, Cmd.none )
                Types.ShittyEmailProgram ->
                    ( model, Cmd.none )
                Types.CuteInfoCard ->
                    ( model, Cmd.none )
        Msg.FileExplorerMouseDownOnTitleBar ->
            ( 
                { model 
                    | fileExplorerMouseDownOnTitleBar = Debug.log "titlebar" True
                    , fileExplorerStartX = model.fileExplorerX
                    , fileExplorerStartY = model.fileExplorerY
                    , absoluteStartX = model.absoluteX
                    , absoluteStartY = model.absoluteY
                    -- | fileExplorerMouseDownOnTitleBar = True
                }
            , Cmd.none 
            )
        Msg.FileExplorerMouseUpOnTitleBar ->
            ( 
                { model 
                    | fileExplorerMouseDownOnTitleBar = Debug.log "titleBar" False
                    -- | fileExplorerMouseDownOnTitleBar = False
                }
            , Cmd.none 
            )
        Msg.MouseMoved coords ->
            let
                moveByX = model.absoluteX - model.absoluteStartX
                moveByY = model.absoluteY - model.absoluteStartY

                model_ = 
                    case model.fileExplorerMouseDownOnTitleBar of
                        True ->
                            { model
                                | absoluteX = coords.x
                                , absoluteY = coords.y
                                , fileExplorerX = model.fileExplorerStartX + moveByX
                                , fileExplorerY = model.fileExplorerStartY + moveByY
                            }
                        False ->
                            { model
                                | absoluteX = coords.x
                                , absoluteY = coords.y
                            }
                cmd_ = Cmd.none
            in
                ( model_, cmd_ )
        Msg.TitleBarMouseMoved coords ->
            let
                model_ =
                    case model.fileExplorerMouseDownOnTitleBar of
                        True ->
                            -- { model
                                -- | fileExplorerX = model.fileExplorerX - (Debug.log "" (model.fileExplorerStartX - model.absoluteX))
                            -- }
                            model
                        False ->
                            model
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

