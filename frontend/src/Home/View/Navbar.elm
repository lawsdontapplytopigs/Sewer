module Home.View.Navbar exposing 
    ( makeNavbar )

import Element as E
import Element.Background as EBackground
import Element.Border as EBorder
import Element.Font as EFont

import Window

makeNavbar model =
    let
        makeTallItem text =
            Window.makeHighElementBorder (Window.makeToolItem text)

        actualNavbar =
            E.el
                [ E.centerY
                , E.centerX
                , E.width <| E.maximum 1920 E.fill
                , EBackground.color <| E.rgb255 200 200 200
                ]
                <| E.el
                    [ E.alignRight
                    ]
                    <| Window.makeHighElementBorder
                        <| Window.makeMainBorder
                            <| Window.makeToolBar
                                [ makeTallItem "Home"
                                , makeTallItem "Library"
                                , makeTallItem "Contact"
                                -- TODO!!!!!! Instead of having a navbar, have the bottom clientsList as navigation between pages
                                ]
    in
    E.el
        [ E.alignBottom
        , E.width E.fill
        , EBackground.color <| E.rgb255 80 80 80
        ]
        <| actualNavbar





