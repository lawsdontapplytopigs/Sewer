module Home.Msg exposing 
    ( Msg(..)
    )


import OBJ.Types exposing (Mesh)
import WebGL.Texture exposing (Texture)
import Dict exposing (Dict)

type Msg
    = Tick Float
    | Zoom Float
    | LoadObj String (Result String (Dict String (Dict String Mesh)))
    | TextureLoaded (Result String Texture)
    | MouseMove Int Int
    | MouseDown Int Int
    | MouseUp
    | ResizeWindow Int Int
