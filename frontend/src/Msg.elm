module Msg exposing 
    ( Msg(..)
    )

import Programs

type Msg
    = Tick Float
    | OpenApplication Programs.Program

    | MouseDownOnTitleBar Programs.Program
    | MouseUpOnTitleBar
    | MouseMoved Coords

type alias Coords =
    { x : Int
    , y : Int
    }
