module View.Navbar exposing 
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
                <| Windoze.level1RaisedElementBorder
                    <| E.row
                        [ EFont.family
                            [ EFont.typeface Palette.font0
                            ]
                        , EFont.light
                        , EFont.size Palette.fontSize0
                        , E.padding 5
                        ]
                        [ E.text text
                        ]
        actualNavbar =
            E.el
                [ E.width E.fill
                -- , EBackground.color <| E.rgb255 10 10 10
                , E.padding 2
                -- , E.paddingEach { top = 5, right = 0, bottom = 0, left = 0 }
                ]
                <| Windoze.makeToolBar
                    [ makeTallItem "Home"
                    , makeTallItem "Library"
                    , makeTallItem "Contact"
                    , makeTallItem "My Computer"
                    -- TODO!!!!!! Instead of having a navbar, have the bottom clientsList as navigation between pages
                    ]

        raise content_ =
            E.el
                [ E.width E.fill
                , E.height E.fill
                , EBorder.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
                , EBorder.color Palette.gray4
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
            , EBackground.color Palette.color0
            ]
            <| raise
                
                -- <| Windoze.makeMainBorder
                    actualNavbar





