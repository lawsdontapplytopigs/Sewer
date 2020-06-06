module Home.Main exposing (..)

import Browser
import Home.View.Desktop
import Home.Msg as Msg

import Browser
import Browser.Events exposing (onAnimationFrameDelta, onMouseDown, onMouseMove, onMouseUp, onResize)
import Html
import Html.Events exposing (on, onCheck, onInput)
import Json.Decode as JD exposing (int)
import Math.Matrix4 as M4 exposing (Mat4)
import Math.Vector2 as Vec2 exposing (Vec2, vec2)
import Math.Vector3 exposing (Vec3, vec3)
import OBJ
import OBJ.Types exposing (Mesh(..), ObjFile)
import String exposing (fromInt)
import Task
import Time exposing (Posix(..), posixToMillis)
import WebGL as GL
-- import WebGL.Settings exposing (cullFace, front)
import WebGL.Texture exposing (Error(..), Texture)


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
    , mesh : Result String ObjFile
    , currentModel : String
    , zoom : Float
    , texture : Result String Texture
    , isDown : Bool
    , lastMousePos : Vec2
    , mouseDelta : Vec2
    , windowSize : Size
    , withTangent : Bool
    }


initModel : Model
initModel =
    { mesh = Err "loading ..."
    , currentModel = "./cherry.obj"
    , time = 0
    , zoom = 5
    , texture = Err "Loading texture..."
    , isDown = False
    , lastMousePos = vec2 0 0
    , mouseDelta = vec2 0 (pi / 2)
    , windowSize = Size 800 600
    , withTangent = True
    }


initCmd : Cmd Msg.Msg
initCmd =
    Cmd.batch
        [ loadModel True "./cherry.obj"
        , loadTexture "./model.jpg" Msg.TextureLoaded
        ]


loadModel : Bool -> String -> Cmd Msg.Msg
loadModel withTangents url =
    OBJ.loadObjFileWith { withTangents = withTangents } url (Msg.LoadObj url)



-- UPDATE


type alias Size =
    { width : Int, height : Int }

type alias CameraInfo =
    { projection : Mat4, view : Mat4, viewProjection : Mat4, position : Vec3 }


update : Msg.Msg -> Model -> ( Model, Cmd Msg.Msg )
update msg model =
    case msg of
        Msg.Tick dt ->
            ( { model | time = model.time + dt / 1000 }, Cmd.none )

        Msg.Zoom dy ->
            ( { model | zoom = max 0.01 (model.zoom + dy / 100) }, Cmd.none )

        Msg.LoadObj url mesh ->
            ( { model | mesh = mesh, currentModel = url }, Cmd.none )

        Msg.TextureLoaded t ->
            ( { model | texture = t }, Cmd.none )

        Msg.MouseMove x y ->
            let
                pos =
                    vec2 (toFloat x) (toFloat y)
            in
            ( { model | mouseDelta = getDelta pos model.lastMousePos model.mouseDelta, lastMousePos = pos }, Cmd.none )

        Msg.MouseDown x y ->
            ( { model | isDown = True, lastMousePos = vec2 (toFloat x) (toFloat y) }, Cmd.none )

        Msg.MouseUp ->
            ( { model | isDown = False }, Cmd.none )

        Msg.ResizeWindow x y ->
            ( { model | windowSize = { width = x, height = y } }, Cmd.none )



-- VIEW / RENDER
-- SUBS


subscriptions : Model -> Sub Msg.Msg
subscriptions model =
    Sub.batch
        ((if model.isDown then
            [ onMouseMove (decodeMouse Msg.MouseMove) ]

          else
            []
         )
            ++ [ onAnimationFrameDelta Msg.Tick
               , onMouseUp (JD.succeed Msg.MouseUp)
               , onMouseDown (decodeMouse Msg.MouseDown)
               , onResize Msg.ResizeWindow
               ]
        )



-- HELPERS


decodeMouse : (Int -> Int -> Msg.Msg) -> JD.Decoder Msg.Msg
decodeMouse mapper =
    JD.map2 mapper
        (JD.field "clientX" int)
        (JD.field "clientY" int)

getDelta : Vec2 -> Vec2 -> Vec2 -> Vec2
getDelta curr lastP delta =
    vec2 ((Vec2.getX curr - Vec2.getX lastP) / 100 + Vec2.getX delta)
        ((Vec2.getY curr - Vec2.getY lastP) / 100 + Vec2.getY delta |> clamp 0.01 pi)


loadTexture : String -> (Result String Texture -> msg) -> Cmd msg
loadTexture url msg =
    WebGL.Texture.load url
        |> Task.attempt
            (\r ->
                case r of
                    Ok t ->
                        msg (Ok t)

                    Err LoadError ->
                        msg (Err "Failed to load texture")

                    Err (SizeError w h) ->
                        msg (Err ("Invalid texture size: " ++ fromInt w ++ " x " ++ fromInt h))
            )

