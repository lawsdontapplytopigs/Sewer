module View.FileExplorer exposing
    ( fileExplorer )


import Dict
import Element as E
import Element.Background as EBackground
import Element.Border as EBorder
import Element.Font as EFont

import Icons

import Html
import Html.Attributes

import Palette
import Windows

import View.Windoze as Windoze

fileExplorer model =
    let
        imageSize = 100
        widthSpacing = 40
        heightSpacing = 40

        maybeWindowData = Dict.get (Windows.toString Windows.FileExplorerMainWindow) model.windows
        windowData =
            case maybeWindowData of
                Just data ->
                    data
                Nothing ->
                    Windows.initFileExplorerMainWindow
                

        makeAlbumSized =
            makeAlbum imageSize

        wholeContent =
            E.el
                [ E.width <| E.px ((imageSize * 4) + 200)
                , E.height <| E.px ((imageSize * 3) + 100)
                , E.centerX
                ]
                <| E.el
                    [ E.width E.fill
                    , E.height E.fill
                    , EBackground.color <| E.rgb255  255 225 238
                    ]
                    <| E.column
                        [ E.centerX
                        -- , EBackground.color <| E.rgb255  240 190 10
                        -- TODO: take this out & refactor. 
                        -- It wouldn't be needed if the code were written properly
                        , E.paddingEach { top = 60, right = 0, bottom = 0, left = 0 }                 
                        ]
                        [ E.row
                            [ E.spacing widthSpacing
                            ]
                            <| List.map makeAlbumSized model.albums0
                        , E.row
                            [ E.spacing widthSpacing
                            ]
                            <| List.map makeAlbumSized model.albums1
                        ]


        toolBar = Windoze.makeToolBar
            [ Windoze.makeToolItem "File" 
            , Windoze.makeToolItem "Edit"
            , Windoze.makeToolItem "Help"
            ]
        titleBar = Windoze.makeTitleBar 
            -- { mouseDownMsg = Msg.FileExplorerMouseDownOnTitleBar
            -- , mouseUpMsg = Msg.FileExplorerMouseUpOnTitleBar
            -- }
            [ Windoze.makeButton Icons.xIcon ]
            Windows.FileExplorerMainWindow
            windowData.title
    in
        E.el
            [ E.htmlAttribute <| Html.Attributes.style "left" ((String.fromInt windowData.x) ++ "px")
            , E.htmlAttribute <| Html.Attributes.style "top" ((String.fromInt windowData.y) ++ "px")
            ]
            <| Windoze.type1Level2RaisedBorder
                <| Windoze.type1Level1RaisedBorder
                    <| Windoze.makeMainBorder 
                        <| E.column
                            [
                            ]
                            [ titleBar
                            , E.el 
                                [ E.width E.fill
                                , E.height E.fill 
                                , EBackground.color Palette.color0
                                ]
                                <| toolBar
                            , Windoze.type1Level1DepressedBorder 
                                <| Windoze.type1Level2DepressedBorder wholeContent
                            ]

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
        , case maybeAuthor of
            Just str ->
                E.el
                    [ EFont.size Palette.fontSize0
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
