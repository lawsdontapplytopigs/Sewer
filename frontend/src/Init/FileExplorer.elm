module Init.FileExplorer exposing 
    ( albums0
    , albums1
    , windowInformation
    )

import Programs

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

initWindowInformation =
    { title = "File Explorer - C://MyDocuments/Albums"
    , x = 200
    , y = 70
    , width = 500
    , height = 300
    , minWidth = 200
    , minHeight = 300
    , recordX = Nothing
    , recordY = Nothing
    }
