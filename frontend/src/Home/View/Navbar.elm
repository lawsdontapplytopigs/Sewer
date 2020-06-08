module Home.View.Navbar exposing 
    ( makeNavbar )

import Element as E
import Element.Background as EBackground
import Element.Border as EBorder
import Element.Font as EFont

import Palette

import Windoze

makeNavbar model =
    let
        makeTallItem text =
            Windoze.level2RaisedElementBorder 
                <| E.paragraph
                    [ EFont.family
                        [ EFont.typeface Palette.font0
                        ]
                    , EFont.size 16
                    , E.padding 5
                    ]
                    [ E.text text
                    ]
        actualNavbar =
            E.el
                [ E.width E.fill
                , EBackground.color <| E.rgb255 10 10 10
                -- , E.paddingEach { top = 5, right = 0, bottom = 0, left = 0 }
                ]
                <| Windoze.makeToolBar
                    [ makeTallItem "Home"
                    , makeTallItem "Library"
                    , makeTallItem "Contact"
                    -- TODO!!!!!! Instead of having a navbar, have the bottom clientsList as navigation between pages
                    ]

        raise content_ =
            E.el
                [ EBorder.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                , EBorder.color Palette.gray0
                , E.width E.fill
                ]
                <| E.el
                    [ E.width E.fill
                    , E.height E.fill
                    , EBorder.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
                    , EBorder.color Palette.gray4
                    ]
                    <| E.el
                        [ EBorder.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                        , EBorder.color Palette.gray1
                        , E.width E.fill
                        ]
                        <| E.el
                            [ E.width E.fill
                            , E.height E.fill
                            , EBorder.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
                            , EBorder.color <| E.rgb255 255 255 255 --TODO: make pink
                            ]
                            <| content_
    in
        
        E.el
            [ E.alignBottom
            , E.width E.fill
            -- , EBackground.color <| E.rgb255 80 80 80
            ]
            <| raise
                
                -- <| Windoze.makeMainBorder
                    actualNavbar





