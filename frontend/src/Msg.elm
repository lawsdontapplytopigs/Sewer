module Msg exposing 
    ( Msg(..)
    )

import Types

type Msg
    = Tick Float
    | OpenApplication Types.App

    | FileExplorerMouseDownOnTitleBar
    | FileExplorerMouseUpOnTitleBar
    | MouseMoved Coords
    | TitleBarMouseMoved Coords

type alias Coords =
    { x : Int
    , y : Int
    }
