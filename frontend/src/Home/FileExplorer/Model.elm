module Home.FileExplorer.Model exposing ( .. )

type alias Model =
    { albums : List (List AlbumData)
    }

init model = 
    { albums =
        [ albums0
        , albums1
        ]
    }

type alias AlbumData =
    { coverImage : String
    , title : String
    , maybeAuthor : Maybe String
    }


albums0 =
    [ { coverImage = "./albums/0.jpg"
        , title = "Draining Love Story"
        , maybeAuthor = Nothing
        }
    , { coverImage = "./albums/1.jpg"
        , title = "Drowning In The Sewer"
        , maybeAuthor = Nothing
        }
    , { coverImage = "./albums/2.jpg"
        , title = "Starving Slvts Always Get Their Fix"
        , maybeAuthor = Nothing
        }
    , { coverImage = "./albums/3.jpg"
        , title = "Sewer//Slvt - EP"
        , maybeAuthor = Nothing
        }
    ]
albums1 =
    [ { coverImage = "./albums/4.jpg"
        , title = "Selected Sewer Works (2017-19)"
        , maybeAuthor = Nothing
        }
    , { coverImage = "./albums/5.jpg"
        , title = "Euphoric Filth (Cheru's Theme)"
        , maybeAuthor = Nothing
        }
    , { coverImage = "./albums/6.jpg"
        , title = "Kawaii Razor Blades (feat. yandere)"
        , maybeAuthor = Nothing
        }
    , { coverImage = "./albums/7.jpg"
        , title = "Mr. Kill Myself"
        , maybeAuthor = Nothing
        }
    ]
