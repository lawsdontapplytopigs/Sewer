module Home.View.Desktop exposing (view)

import Element as E
import Element.Background as EBackground
import Element.Border as EBorder
import Element.Font as EFont
import Home.Msg as Msg
import Home.View.Navbar

import Html
import Html.Attributes

import Palette as Palette

import Window

import Icons

view title model =
    { title = title
    , body = 
        [ E.layout
            [ E.inFront (Home.View.Navbar.makeNavbar model)
            , E.htmlAttribute <| Html.Attributes.style "overflow" "hidden"
            , E.height E.fill
            ]
            <| mainDocumentColumn model
        ]
    }

mainDocumentColumn model =
    let
        postPic = "./bg.png"
        postPic2 = "./bg2.png"
        postPic3 = "./bg3.jpg"
        postPic4 = "./bg4.jpg"
    in
    E.column
        [ E.width E.fill
        -- , E.height E.fill
        -- , EBackground.color <| E.rgb255 10 20 36
        , EBackground.color <| E.rgb255 255 255 255
        -- , EFont.family
        --     -- [ EFont.typeface Palette.font1
        --     [ EFont.typeface Palette.font0
        --     ]
        -- , EFont.size 69
        -- , EFont.light
        
        -- , E.htmlAttribute <| Html.Attributes.style "width" ((String.fromInt maxWidth) ++ "px")
        -- , E.htmlAttribute Html.Attributes.style "height" ((String.fromInt imageHeight) ++ "px")
        , E.htmlAttribute <| Html.Attributes.style "background-image" ("url(" ++ postPic4 ++ ")")
        , E.htmlAttribute <| Html.Attributes.style "background-size" "cover"
        ]
        -- [ block0 model
        [ block1 model
        , heightBlock 200
        ]

block0 model =
    let
        maxWidth = 800
        billboard = "./billboard.png"
        logo = "./logo.png"
    in
    E.column
        [ E.height <| E.px 640
        , E.width E.fill
        -- , EBackground.color <| E.rgb255 80 80 80
        , E.centerX
        , E.htmlAttribute <| Html.Attributes.style "background-image" ("url(" ++ billboard ++ ")")
        , E.htmlAttribute <| Html.Attributes.style "background-size" "cover"
        ]
        [ E.el 
            [ E.width <| E.maximum maxWidth E.fill
            -- , E.height <| E.px 800 
            , E.centerX
            , E.centerY
            ]
            <| E.image 
                [ E.width <| E.px 420
                , E.centerX
                , E.centerY
                ]
                { src = logo
                , description = ""
                }
        ]

block1 model =
    let
        imageSize = 200
        widthSpacing = 40
        heightSpacing = 40

        makeAlbum : 
            Int 
            -> { coverImage : String, title : String, maybeAuthor : Maybe String } 
            -> E.Element msg
        makeAlbum imgSize { coverImage, title, maybeAuthor } =
            E.column
                [ E.height <| E.px (imgSize + 60)
                , E.width <| E.px imgSize
                -- , EBackground.color <| E.rgb255 215 15 15
                ]
                [ E.html
                    <| Html.div
                        [ Html.Attributes.style "width" ((String.fromInt imgSize) ++ "px")
                        , Html.Attributes.style "height" ((String.fromInt imgSize) ++ "px")
                        , Html.Attributes.style "background-image" ("url(" ++ coverImage ++ ")")
                        , Html.Attributes.style "background-size" "cover"
                        ]
                        []
                , E.paragraph
                    [ E.width <| E.px imgSize
                    -- , E.htmlAttribute <| Html.Attributes.style 
                    , EFont.size 16
                    , EFont.family
                        [ EFont.typeface Palette.font0
                        ]
                    -- , EFont.color <| E.rgb255 230 80 170
                    -- , EFont.color <| E.rgb255 255 255 255
                    , EFont.color <| E.rgb255 32 20 26
                    -- , EBackground.color <| E.rgb255 10 110 10
                    ]
                    [ E.text title
                    ]
                , case maybeAuthor of
                    Just str ->
                        E.el
                            [ EFont.size 14
                            , EFont.light
                            , EFont.family
                                [ EFont.typeface Palette.font0
                                ]
                            -- , EFont.color <| E.rgb255 230 80 170
                            , EFont.color <| E.rgb255 32 20 26
                            ]
                            <| E.text str
                    Nothing ->
                        E.none
                ]
        makeAlbumSized =
            makeAlbum imageSize

        albums0 =
            [ makeAlbumSized
                { coverImage = "./albums/0.jpg"
                , title = "Draining Love Story"
                , maybeAuthor = Nothing
                }
            , makeAlbumSized
                { coverImage = "./albums/1.jpg"
                , title = "Drowning In The Sewer"
                , maybeAuthor = Nothing
                }
            , makeAlbumSized
                { coverImage = "./albums/2.jpg"
                , title = "Starving Slvts Always Get Their Fix"
                , maybeAuthor = Nothing
                }
            , makeAlbumSized
                { coverImage = "./albums/3.jpg"
                , title = "Sewer//Slvt - EP"
                , maybeAuthor = Nothing
                }
            ]
        albums1 =
            [ makeAlbumSized
                { coverImage = "./albums/4.jpg"
                , title = "Selected Sewer Works (2017-19)"
                , maybeAuthor = Nothing
                }
            , makeAlbumSized
                { coverImage = "./albums/5.jpg"
                , title = "Euphoric Filth (Cheru's Theme)"
                , maybeAuthor = Nothing
                }
            , makeAlbumSized
                { coverImage = "./albums/6.jpg"
                , title = "Kawaii Razor Blades (feat. yandere)"
                , maybeAuthor = Nothing
                }
            , makeAlbumSized
                { coverImage = "./albums/7.jpg"
                , title = "Mr. Kill Myself"
                , maybeAuthor = Nothing
                }
            ]

        albums = 
            E.column
                [ E.centerX
                -- , EBackground.color <| E.rgb255  240 190 10
                -- TODO: take this out. It wouldn't be needed if the code were written properly
                , E.paddingEach { top = 60, right = 0, bottom = 0, left = 0 }                 
                ]
                [ E.row
                    [ E.spacing widthSpacing
                    ]
                    albums0
                , E.row
                    [ E.spacing widthSpacing
                    ]
                    albums1
                ]

        wholeContent =
            E.el
                [ E.width <| E.px ((imageSize * 4) + 300)
                , E.height <| E.px ((imageSize * 4))
                , E.centerX
                ]
                <| E.el
                    [ E.width E.fill
                    , E.height E.fill
                    , EBackground.color <| E.rgb255  255 200 220
                    ]
                    albums
                    -- <| E.column
                    --     [ E.centerX
                    --     ]
                    --     albums
    in
        E.column
            [ E.centerX
            ]
            [ E.el
                [ EFont.size 60
                , EFont.color <| E.rgb255 230 30 10
                , EFont.family
                    [ EFont.typeface Palette.font1
                    ]
                , E.centerY
                , E.height <| E.px 240
                , E.paddingEach { top = 120, right = 0, bottom = 0, left = 0 }
                ]
                <| E.text "My music :)"
            , Window.makeWindow 
                { title = "Untitled - Notepad"
                , buttons = [ Window.makeButton Icons.xIcon ]
                , toolsList = 
                    [ Window.makeToolItem "File" 
                    , Window.makeToolItem "Edit"
                    , Window.makeToolItem "Help"
                    ]
                }
                wholeContent
            ]

heightBlock height =
    E.el
        [ E.height <| E.maximum height E.fill
        ]
        <| E.text ""
