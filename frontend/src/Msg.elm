module Msg exposing
    ( Msg(..)
    )

import Time exposing (Posix)
import Window
import Programs.MediaPlayer

type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone

    -- Window Related
    | OpenWindow Window.WindowType
    | CloseWindow Window.WindowType
    | MinimizeWindow Window.WindowType
    | MouseDownOnTitleBar Window.WindowType
    | MouseUpOnTitleBar
    | MouseMoved Coords
    | WindowClicked Window.WindowType

    -- Navbar
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

    -- Audio Related
    | GotSongData Programs.MediaPlayer.SongData
    | GotAlbumData Programs.MediaPlayer.AlbumData

    | PressedPlayOrPause
    | PressedNextSong
    | PressedPrevSong
    | SongLoaded
    | MediaPlayerTrackSliderMoved Float
    | SongEnded
    | SongPlaying
    | SongPaused
    | JsonParseError String

    | NoOp

type alias Coords =
    { x : Int
    , y : Int
    }

