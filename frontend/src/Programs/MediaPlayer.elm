module Programs.MediaPlayer exposing 
    -- ( MediaPlayerData
    -- , Status(..)
    -- )
    (..)

type alias AlbumData =
    { title : String
    , albumCoverSrc : String
    , songs : List SongData
    }

type alias TimeData =
    { elapsed : Maybe Int -- I would use a float here, but I think there's and elm compiler bug
    , duration : Float
    , isPlaying : Bool
    }

type alias SongData =
    { title : String
    , artist : String
    , duration : Int -- in seconds
    }

-- we don't actually use this to control anything on the js side
-- we only use this data to display stuff properly in the media player
type alias MediaPlayerData =
    { isPlaying : Bool
    , elapsed : Maybe Int
    , currentSongDuration : Maybe Float
    , currentSong : Maybe SongData
    , playlist : List SongData
    , albumCoverSrc : Maybe String
    , albumTitle : Maybe String
    , shouldShuffle : Bool
    , shouldRepeat : Bool
    }

init : MediaPlayerData
init =
    { isPlaying = False
    , elapsed = Nothing
    , currentSongDuration = Nothing
    , currentSong = Nothing
    , playlist = []
    , albumCoverSrc = Nothing
    , albumTitle = Nothing
    , shouldShuffle = False
    , shouldRepeat = False
    }

toggleShuffle : MediaPlayerData -> MediaPlayerData
toggleShuffle mpd =
    { mpd
        | shouldShuffle = not mpd.shouldShuffle
    }

toggleRepeat : MediaPlayerData -> MediaPlayerData
toggleRepeat mpd =
    { mpd
        | shouldRepeat = not mpd.shouldRepeat
    }

updateAlbum : AlbumData -> MediaPlayerData -> MediaPlayerData
updateAlbum data mpd =
    { mpd
        | albumTitle = Just data.title
        , albumCoverSrc = Just data.albumCoverSrc
        , playlist = data.songs
    }

updateTimeData : TimeData -> MediaPlayerData -> MediaPlayerData
updateTimeData data mpd =
    { mpd
        | currentSongDuration = Just data.duration
        , elapsed = data.elapsed -- we might get null here, so fuck it. we just store it anyway
        , isPlaying = data.isPlaying
    }
updateCurrentSong : SongData -> MediaPlayerData -> MediaPlayerData
updateCurrentSong data mpd =
    { mpd
        | currentSong = Just data
    }

