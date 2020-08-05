module Programs.MediaPlayer exposing 
    -- ( MediaPlayerData
    -- , Status(..)
    -- )
    (..)

import Array

type alias TimeData =
    { elapsed : Maybe Int -- I would use a float here, but I think there's an elm compiler or core library bug
    , duration : Float
    , isPlaying : Bool
    }

type alias SongData =
    { title : String
    , artist : String
    , duration : Int -- in seconds
    }

type alias Album =
    { title : String
    , albumCoverSrc : String
    , songs : Array.Array SongData
    }

-- we use this because on tablets we want to show something selected by default,
-- but on phones we want to make it look like nothing is selected
type SelectedAlbumAndSong 
    = Default Int Int
    | Selected Int Int

-- type PlayPanelState 
--     = NotShowingPlayPanel
--     | ToggledUpPlayPanel Int
--     | ToggledDownPlayPanel Int

-- type SongsPanelState
--     = NotShowingSongsPanel
--     | ShowingSongsPanel Int
    

-- we don't actually use this to control anything on the js side
-- we only use this data to display stuff properly in the media player
type alias MediaPlayerData =
    { discography : Array.Array Album
    , selected : SelectedAlbumAndSong

    , elapsed : Maybe Int
    , currentSongDuration : Maybe Float
    , isPlaying : Bool

    , shouldShuffle : Bool
    , shouldRepeat : Bool
    , playPanelYPercentageOffset : Float -- 0 to 1
    , songsPanelXPercentageOffset : Float -- 0 to 1
    -- , playPanelState : PlayPanelState
    -- , songsPanelState : SongsPanelState
    }

updatePlayPanelYOffset : Float -> MediaPlayerData -> MediaPlayerData
updatePlayPanelYOffset y mpd =
    let
        flt = 
            if y > 1 then
                1
            else if y < 0 then
                0
            else
                y
    in
    { mpd
        | playPanelYPercentageOffset = flt
    }

updateSongsPanelXOffset : Float -> MediaPlayerData -> MediaPlayerData
updateSongsPanelXOffset x mpd =
    let
        flt = 
            if x > 1 then
                1
            else if x < 0 then
                0
            else
                x
    in
    { mpd
        | songsPanelXPercentageOffset = flt
    }

init : MediaPlayerData
init =
    { discography = Array.empty
    , selected = Default 0 0

    , elapsed = Nothing
    , currentSongDuration = Nothing
    , isPlaying = False
    , shouldShuffle = False
    , shouldRepeat = False
    , playPanelYPercentageOffset = 0.0
    , songsPanelXPercentageOffset = 0.0
    }

updateDiscography : (Array.Array Album) -> MediaPlayerData -> MediaPlayerData
updateDiscography albums mpd =
    { mpd
        | discography = albums
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

updateSelected : SelectedAlbumAndSong -> MediaPlayerData -> MediaPlayerData
updateSelected sel mpd =
    { mpd
        | selected = sel
    }

updateTimeData : TimeData -> MediaPlayerData -> MediaPlayerData
updateTimeData data mpd =
    { mpd
        | currentSongDuration = Just data.duration
        , elapsed = data.elapsed -- we might get Nothing here, so fuck it. we just store it anyway
        , isPlaying = data.isPlaying
    }

getAlbumIndex : SelectedAlbumAndSong -> Int
getAlbumIndex sel =
    case sel of
        Default albumIndex _ ->
            albumIndex
        Selected albumIndex _ ->
            albumIndex

getSongIndex : SelectedAlbumAndSong -> Int
getSongIndex sel =
    case sel of
        Default _ songIndex ->
            songIndex
        Selected _ songIndex ->
            songIndex

getSelectedSong : SelectedAlbumAndSong -> MediaPlayerData -> Maybe SongData
getSelectedSong sel mpd =
    let
        albumInd = getAlbumIndex sel
        songInd = getSongIndex sel

        album =
            Array.get albumInd mpd.discography
    in
        case album of
            Just alb ->
                Array.get songInd alb.songs
            Nothing ->
                Nothing

getSelectedAlbum : SelectedAlbumAndSong -> MediaPlayerData -> Maybe Album
getSelectedAlbum sel mpd =
    Array.get (getAlbumIndex sel) mpd.discography

getTotalNumberOfAlbumSeconds : Album -> Int
getTotalNumberOfAlbumSeconds album =
    let
        getSongDurations songs_ = Array.map .duration songs_
    in
        Array.foldl (+) 0 (getSongDurations album.songs)

getTotalNumberOfAlbumTracks : Album -> Int
getTotalNumberOfAlbumTracks album =
    Array.length album.songs

-- updateAlbum : AlbumData -> MediaPlayerData -> MediaPlayerData
-- updateAlbum data mpd =
--     { mpd
--         | albumTitle = Just data.title
--         , albumCoverSrc = Just data.albumCoverSrc
--         , playlist = data.songs
--     }
