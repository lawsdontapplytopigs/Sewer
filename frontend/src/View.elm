module View exposing (..)

import Element as E
import Element.Events as EEvents

import Html
import Html.Attributes
import Html.Events
import Json.Decode as JDecode

import Msg
import View.Desktop
import View.MediaPlayer
import View.Navbar


view title model =
    let
        desktop_ =
            E.layout
                [ E.inFront (View.Navbar.makeNavbar model)
                , E.htmlAttribute <| Html.Events.on "mousemove" (JDecode.map Msg.MouseMoved screenCoords)
                , E.htmlAttribute <| Html.Attributes.style "overflow" "hidden"
                , EEvents.onMouseUp Msg.MouseUpOnTitleBar
                ]
                <| View.Desktop.view model

        phone_ =
            E.layout
                [ E.width <| E.px model.viewportGeometry.width
                , E.height <| E.px model.viewportGeometry.height
                , E.htmlAttribute <| Html.Attributes.style "overflow" "hidden"
                ]
                <| View.MediaPlayer.viewPhone 
                    model.viewportGeometry
                    -- { viewportWidth = model.viewportWidth
                    -- , viewportHeight = model.viewportHeight
                    -- }
                    model

        device = E.classifyDevice model.viewportGeometry

        decided = 
            case device.class of
                E.Phone ->
                    phone_
                E.Tablet -> -- TODO
                    desktop_
                E.Desktop->
                    desktop_
                E.BigDesktop ->
                    desktop_
    in
        { title = title
        , body = [ decided ]
        }
    
screenCoords : JDecode.Decoder Coords
screenCoords =
    JDecode.map2 Coords
        (JDecode.field "screenX" JDecode.int)
        (JDecode.field "screenY" JDecode.int)

type alias Coords =
    { x : Int
    , y : Int
    }
