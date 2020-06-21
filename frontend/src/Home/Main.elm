module Home.Main exposing (..)

import Browser
import Home.View.Desktop
import Home.Msg as Msg

import Home.Init.FileExplorer as Init

import Home.Types as Types

import Browser
-- import Browser.Events exposing (onAnimationFrameDelta, onMouseDown, onMouseMove, onMouseUp, onResize)
import Html
-- import Json.Decode as JD exposing (int)
-- import Time exposing (Posix(..), posixToMillis)


main : Program () Model Msg.Msg
main = Browser.document
    { init = init
    , view = Home.View.Desktop.view "Sewerslvt"
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL
type alias Model =
    { time : Float
    , absoluteX : Int
    , absoluteY : Int

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

init flags = 
    let
        model =
            { time = 0
            , absoluteX = 0
            , absoluteY = 0

            -- file explorer data
            , fileExplorerTitle = "File Explorer - C://MyDocuments/Albums"
            , fileExplorerMouseDownOnTitleBar = False
            , fileExplorerStartX = 0
            , fileExplorerStartY = 0
            , fileExplorerX = 200
            , fileExplorerY = 70
            , fileExplorerWidth = 500
            , fileExplorerHeight = 300
            , albums0 = Init.albums0
            , albums1 = Init.albums1
            , debug = 0
            }
        cmds =
            Cmd.none
    in
        ( model, cmds )


-- UPDATE

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
                    , fileExplorerStartX = model.absoluteX
                    , fileExplorerStartY = model.absoluteY
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
                model_ = 
                    { model
                        -- | absoluteX = Debug.log "x" coords.x
                        | absoluteX = coords.x
                        , absoluteY = coords.y
                        -- , debug = Debug.log "" <| model.fileExplorerX - ( model.fileExplorerStartX - coords.x)
                        , debug = Debug.log "" model.fileExplorerStartX - coords.x
                        -- , fileExplorerX = model.fileExplorerX - (model.fileExplorerStartX - coords.x)
                        -- , fileExplorerY = model.fileExplorerStartY - (model.fileExplorerStartY - coords.y)
                    }
                cmd_ = Cmd.none
            in
            case model.fileExplorerMouseDownOnTitleBar of
                False ->
                    ( model_, Cmd.none )
                True ->
                    -- let
                    --     model_ = 
                    --         { model
                    --             -- | absoluteX = Debug.log "x" coords.x
                    --             | absoluteX = coords.x
                    --             , absoluteY = coords.y
                    --             -- , debug = Debug.log "" <| model.fileExplorerX - ( model.fileExplorerStartX - coords.x)
                    --             , debug = Debug.log "" model.fileExplorerStartX - coords.x
                    --             -- , fileExplorerX = model.fileExplorerX - (model.fileExplorerStartX - coords.x)
                    --             -- , fileExplorerY = model.fileExplorerStartY - (model.fileExplorerStartY - coords.y)
                    --         }
                    --     cmd_ = Cmd.none
                    -- in
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

