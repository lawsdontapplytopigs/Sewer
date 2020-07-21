module Msg exposing
    ( Msg(..)
    )

import Time exposing (Posix)
import Window

type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone

    | OpenWindow Window.WindowType
    | CloseWindow Window.WindowType
    | MinimizeWindow Window.WindowType
    | MouseDownOnTitleBar Window.WindowType
    | MouseUpOnTitleBar
    | MouseMoved Coords
    | WindowClicked Window.WindowType

    -- navbar
    | StartButtonPressed
    -- TODO: We can take this out if we have each navbar item decide what to do
    -- when clicked. for example, whether the navbar item clicked should send a
    -- `FocusWindow` Msg or a `MinimizeWindow` Msg
    | NavbarItemClicked Window.WindowType

    -- poor man's outlook related
    | EmailInput String
    | SubjectInput String
    | EmailContentInput String
    | TryToSendEmail

    -- webamp related
    | WinampIn String
    | NoOp

type alias Coords =
    { x : Int
    , y : Int
    }
