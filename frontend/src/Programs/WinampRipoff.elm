module Programs.WinampRipoff exposing 
    ( WinampRipoffData
    , init
    )

type Song
    = CherusTheme

type alias WinampRipoffData =
    { currentSong : Song
    }

init =
    { currentSong = CherusTheme
    }
