module Msg exposing
    ( Msg(..)
    )

import Windows

type Msg
    = Tick Float

    | OpenWindow Windows.Window
    | MouseDownOnTitleBar Windows.Window
    | MouseUpOnTitleBar
    | MouseMoved Coords

    | EmailInput String
    | SubjectInput String
    | EmailContentInput String
    | TryToSendEmail
    | StartButtonPressed
    | ToggleMinimize Windows.Window

type alias Coords =
    { x : Int
    , y : Int
    }
