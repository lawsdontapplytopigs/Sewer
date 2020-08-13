module View.FileExplorer exposing
    ( fileExplorer )


import Array
import Dict
import Element as E
import Element.Background as EBackground
import Element.Border as EBorder
import Element.Events as EEvents
import Element.Font as EFont


import Html
import Html.Attributes
import Icons

import Msg

import Palette
import Programs.MediaPlayer as MediaPlayer
import Window
import Windows

import View.Windoze as Windoze

fileExplorer viewportGeometry model =
    let
        imageSize = 80
        widthSpacing = 40
        heightSpacing = 40

        albumsTitleAndCover : Array.Array { title : String, albumCoverSrc : String }
        albumsTitleAndCover = Array.map (\a -> { title = a.title, albumCoverSrc = a.albumCoverSrc }) model.mediaPlayer.discography

        wrapRow =
            E.wrappedRow
                [ E.spacing 20
                , E.centerX
                ]
                <| Array.toList (Array.indexedMap makeAlbum albumsTitleAndCover)

        wholeContent =
            E.el
                [ E.centerX
                , E.width E.fill
                , E.paddingEach { top = 40, right = 20, bottom = 0, left = 20 }
                ]
                wrapRow
    in
        E.column
            [ E.width E.fill
            , E.height E.fill
            , EBackground.color Palette.color1
            ]
            [ Windoze.type1Level1DepressedBorder 1
                <| Windoze.type1Level2DepressedBorder 1 
                    <| E.el
                        [ E.height E.fill
                        , E.width E.fill
                        , E.inFront wholeContent
                        , E.scrollbarY
                        ]
                        <| E.none
            , E.el
                [ E.width E.fill
                , EBackground.color Palette.color0
                , EBorder.widthEach { top = 2, right = 0, bottom = 0, left = 0 }
                , EBorder.color <| Palette.color0
                ]
                <| Windoze.makeInfoBar "8 objects" "99999999999999999999kb"
            ]

makeAlbum : 
    Int
    -> { albumCoverSrc : String, title : String }
    -> E.Element Msg.Msg
makeAlbum indx { albumCoverSrc, title } =
    let
        imgSize = 80
    in
    E.column
        [ E.height <| E.px (imgSize + 60)
        , E.width <| E.px imgSize
        -- TODO: make this behave better. for example, check if the music player 
        -- is open, open it, focus it, bring it on top, etc. expected behaviour
        -- in a windows scenario
        , EEvents.onDoubleClick <| Msg.SelectedAlbumFromFileExplorer indx 
        ]
        [ E.html
            <| Html.div
                [ Html.Attributes.style "width" ((String.fromInt imgSize) ++ "px")
                , Html.Attributes.style "height" ((String.fromInt imgSize) ++ "px")
                , Html.Attributes.style "background-image" ("url(" ++ albumCoverSrc ++ ")")
                , Html.Attributes.style "background-size" "cover"
                ]
                []
        , E.paragraph
            [ E.width <| E.px imgSize
            -- , E.htmlAttribute <| Html.Attributes.style 
            , EFont.size Palette.fontSize0
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
        ]
