module Msg exposing
    ( Msg(..)
    )

import Windows

type Msg
    = Tick Float
    -- We could just have individual messages here for each program, since we
    -- know at compile time all possible programs that the user would be able 
    -- to open, but if we decide to change this in the future, I think doing
    -- it like this may be better

    -- I'd make "OpenApplication", but that's not what we're actually trying
    -- to do...
    | OpenWindow Windows.Window
    | MouseDownOnTitleBar Windows.Window

    | MouseUpOnTitleBar
    | MouseMoved Coords

type alias Coords =
    { x : Int
    , y : Int
    }
