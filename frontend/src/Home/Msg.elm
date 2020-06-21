module Home.Msg exposing 
    ( Msg(..)
    )

import Home.Types as Types

type Msg
    = Tick Float
    | OpenApplication Types.App

    | FileExplorerMouseDownOnTitleBar
    | FileExplorerMouseUpOnTitleBar
    | MouseMoved Coords

type alias Coords =
    { x : Int
    , y : Int
    }
