module Msg exposing
    ( Msg(..)
    )

import Array
import Time exposing (Posix)
import Window
import Programs.MediaPlayer

type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone
    | GotViewportGeometry { width : Int , height : Int }

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
    | GotDiscography (Array.Array Programs.MediaPlayer.Album)
    | GotSelectedAlbumAndSong Programs.MediaPlayer.SelectedAlbumAndSong
    | GotTimeData Programs.MediaPlayer.TimeData
    -- | GotSongData Programs.MediaPlayer.SongData
    -- | GotAlbums Programs.MediaPlayer.Album

    | SelectedAlbum AlbumIndex
    | SelectedSong AlbumIndex SongIndex

    | PressedPlayOrPause
    | PressedNextSong
    | PressedPrevSong
    | PressedToggleShuffle
    | PressedToggleRepeat
    | PressedSongsMenuButton
    | PressedCloseSongsMenuButton
    | PressedToggleDownPlayMenu
    | PressedToggleUpPlayMenu
    | MediaPlayerTrackSliderMoved Float

    | SongLoaded
    | SongEnded
    | SongPlaying
    | SongPaused
    | JsonParseError String

    | NoOp

type alias AlbumIndex = Int
type alias SongIndex = Int

type alias Coords =
    { x : Int
    , y : Int
    }

