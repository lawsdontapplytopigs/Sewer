module View.ContactMeCard exposing (..)

import Element as E
import Element.Background as EBackground
import Element.Font as EFont
import Palette
import Window
import Windows
import View.Windoze


contactMeCard model =
    -- let
    --     windowGeometry = 
    --         case (Windows.get Window.PoorMansOutlookMainWindow model.windows) of
    --             (Window.Window type_ geometry) ->
    --                 geometry
    -- in
    E.row
        [ E.width E.fill
        , E.height E.fill
        , EBackground.color Palette.color0
        ]
        [ E.el
            [ E.width <| E.px 100
            , E.height E.fill
            ]
            <| E.image
                [ E.centerX
                , E.centerY
                , E.width <| E.px 32
                , E.height <| E.px 32
                ]
                { src = Palette.iconPoorMansOutlook
                , description = "cute mail image"
                }
        , E.column
            [ E.width E.fill
            , EFont.family
                [ EFont.typeface Palette.font0
                ]
            , EFont.size Palette.fontSize0
            , EFont.color Palette.color3
            , EFont.underline
            , E.spacing 10
            , E.centerY
            ]
            [ E.newTabLink
                [
                ]
                { url = "https://twitter.com/sewerslvt"
                , label = E.text "https://twitter.com/sewerslvt"
                }
            , E.newTabLink
                [
                ]
                { url = "https://sewerslvt.bandcamp.com/"
                , label = E.text "https://sewerslvt.bandcamp.com/"
                }
            , E.newTabLink
                [
                ]
                { url = "https://www.youtube.com/channel/UCnW2hq-0-3Urmz12oK2z3mQ"
                , label = E.text "my youtube channel"
                }
            ]
        ]

