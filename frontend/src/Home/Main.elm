module Home.Main exposing (..)

import Browser
import Home.View.Desktop
import Home.Msg as Msg

import Browser
-- import Browser.Events exposing (onAnimationFrameDelta, onMouseDown, onMouseMove, onMouseUp, onResize)
import Html
-- import Json.Decode as JD exposing (int)
-- import Time exposing (Posix(..), posixToMillis)


main : Program () Model Msg.Msg
main = Browser.document
    { init = always ( initModel, initCmd )
    , view = Home.View.Desktop.view "Sewerslvt"
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL
type alias Model =
    { time : Float
    }


initModel : Model
initModel =
    { time = 0
    }


initCmd : Cmd Msg.Msg
initCmd =
    Cmd.none

-- UPDATE

update : Msg.Msg -> Model -> ( Model, Cmd Msg.Msg )
update msg model =
    case msg of
        Msg.Tick dt ->
            ( { model | time = model.time + dt / 1000 }, Cmd.none )


subscriptions : Model -> Sub Msg.Msg
subscriptions model =
    Sub.none

-- HELPERS
-- decodeMouse : (Int -> Int -> Msg.Msg) -> JD.Decoder Msg.Msg
-- decodeMouse mapper =
--     JD.map2 mapper
--         (JD.field "clientX" int)
--         (JD.field "clientY" int)

