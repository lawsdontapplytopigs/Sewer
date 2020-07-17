module Msg exposing
    ( Msg(..)
    )

import Window

type Msg
    = Tick Float

    | OpenWindow Window.WindowType
    | CloseWindow Window.WindowType
    | MouseDownOnTitleBar Window.WindowType
    | MouseUpOnTitleBar
    | MouseMoved Coords
    | WindowClicked Window.WindowType

    -- navbar
    | StartButtonPressed
    | NavbarItemClicked Window.WindowType

    -- poor man's outlook related
    | EmailInput String
    | SubjectInput String
    | EmailContentInput String
    | TryToSendEmail

    -- webamp related
    | WinampIn String
    | OpenWinamp

type alias Coords =
    { x : Int
    , y : Int
    }
