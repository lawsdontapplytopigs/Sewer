module Main exposing (..)

import Browser
import Html
import Init.FileExplorer

import View.Desktop
import Msg

import Programs

import Set
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

type alias Model =
    { time : Float
    , absoluteX : Int
    , absoluteY : Int

    , absoluteRecordX : Int
    , absoluteRecordY : Int

    , installedPrograms : Set.Set Programs.Program
    , openPrograms : Set.Set Programs.Program
    , currentTitleBarHeldProgram : Maybe Programs.Program

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

        fileExplorer = 
            Programs.FileExplorer Init.FileExplorer.windowInformation


        model =
            { time = 0
            , absoluteX = 0
            , absoluteY = 0

            -- we'll use this to track how much to move the window
            -- we set these when the mouse is pressed on the window's titlebar
            , absoluteRecordX = Nothing
            , absoluteRecordY = Nothing

            , installedPrograms = Set.singleton fileExplorer
            , openPrograms = Set.empty
            , currentTitleBarHeldProgram = Nothing

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
                Programs.FileExplorer info ->
                    ( model, Cmd.none )
                Programs.WinampRipoff info ->
                    ( model, Cmd.none )
                Programs.BrokeAssOutlook info ->
                    ( model, Cmd.none )
        Msg.MouseDownOnTitleBar program ->
            ( 
                { model 
                    -- | fileExplorerStartX = model.fileExplorerX
                    -- , fileExplorerStartY = model.fileExplorerY
                    , absoluteStartX = model.absoluteX
                    , absoluteStartY = model.absoluteY
                    , currentTitleBarHeldProgram = Debug.log "titleBar Program" (Just program)
                    -- | fileExplorerMouseDownOnTitleBar = True
                }
            , Cmd.none 
            )
        Msg.FileExplorerMouseUpOnTitleBar ->
            (
                { model
                    | currentTitleBarHeldProgram = Nothing
                    -- | fileExplorerMouseDownOnTitleBar = False
                }
            , Cmd.none
            )
        Msg.MouseMoved coords ->
            let
                model_ = 
                    case model.currentTitleBarHeldProgram of
                        Just program ->

                            let
                                moveByX = model.absoluteX - model.absoluteStartX
                                moveByY = model.absoluteY - model.absoluteStartY

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

