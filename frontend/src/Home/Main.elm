module Home.Main exposing (..)

import Browser
import Home.View.Desktop
import Home.Msg as Msg

import Home.FileExplorer.Model

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
    , fileExplorerModel : Home.FileExplorer.Model.Model
    }

-- type Client =
--     { title : String
--     }

init flags = 
    ( 
        { time = 0
        , fileExplorerModel = Home.FileExplorer.Model.init
        }
    , Cmd.none
    )
        
-- initModel : Model
-- initModel =


-- initCmd : Cmd Msg.Msg
-- initCmd =

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
        Msg.UpdateFileExplorer ->
            ( model, Cmd.none )

subscriptions : Model -> Sub Msg.Msg
subscriptions model =
    Sub.none

-- HELPERS
-- decodeMouse : (Int -> Int -> Msg.Msg) -> JD.Decoder Msg.Msg
-- decodeMouse mapper =
--     JD.map2 mapper
--         (JD.field "clientX" int)
--         (JD.field "clientY" int)

