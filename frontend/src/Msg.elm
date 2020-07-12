module Msg exposing
    ( Msg(..)
    )

import Window

type Msg
    = Tick Float

    | OpenWindow Window.WindowType
    | MouseDownOnTitleBar Window.WindowType
    | MouseUpOnTitleBar
    | MouseMoved Coords

    | EmailInput String
    | SubjectInput String
    | EmailContentInput String
    | TryToSendEmail
    | StartButtonPressed
    | NavbarItemClicked Window.WindowType

type alias Coords =
    { x : Int
    , y : Int
    }
