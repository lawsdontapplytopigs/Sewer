module Programs.MediaPlayer exposing 
    -- ( MediaPlayerData
    -- , Status(..)
    -- )
    (..)

type alias AlbumData =
    { title : String
    , albumCoverSrc : String
    , songs : List Song
    }

type alias SongData =
    { elapsed : Float
    , duration : Float
    , isPlaying : Bool
    , currentSong : Song
    }

type alias Song =
    { title : String
    , artist : String
    }

-- we don't actually use this to control anything on the js side
-- we only use this data to display stuff properly in the media player
type alias MediaPlayerData =
    { isPlaying : Bool
    , elapsed : Maybe Float
    , currentSongDuration : Maybe Float
    , currentSong : Maybe Song
    , playlist : List Song
    , albumCoverSrc : Maybe String
    , albumTitle : Maybe String
    }

init : MediaPlayerData
init =
    { isPlaying = False
    , elapsed = Just 0.0
    , currentSongDuration = Nothing
    , currentSong = Nothing
    , playlist = []
    , albumCoverSrc = Nothing
    , albumTitle = Nothing
    }

updateAlbum : AlbumData -> MediaPlayerData -> MediaPlayerData
updateAlbum data mpd =
    { mpd
        | albumTitle = Just data.title
        , albumCoverSrc = Just data.albumCoverSrc
        , playlist = data.songs
    }

updateSongData : SongData -> MediaPlayerData -> MediaPlayerData
updateSongData data mpd =
    { mpd
        | currentSongDuration = Just data.duration
        , elapsed = Just data.elapsed
        , isPlaying = data.isPlaying
        , currentSong = Just data.currentSong
    }
