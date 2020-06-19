module Home.Msg exposing 
    ( Msg(..)
    )

import Home.Types as Types

type Msg
    = Tick Float
    | OpenApplication Types.App

    | FileExplorerMouseDownOnTitleBar
    | FileExplorerMouseUpOnTitleBar
    | GotAbsoluteMouseCoords Coords

type alias Coords =
    { x : Int
    , y : Int
    }
