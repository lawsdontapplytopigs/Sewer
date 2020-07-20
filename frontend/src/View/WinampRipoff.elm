module View.WinampRipoff exposing
    ( jsonToWinampMsg
    , winampRipoff
    , WinampMsg(..)
    )

import Element as E

import Html
import Html.Attributes


import Json.Decode as JDecode
import Window
import Windows

winampRipoff model =
    let
        windowData =
            case (Windows.get Window.WinampMainWindow model.windows) of
                (Window.Window t_ geom) ->
                    geom

        shouldShow =
            let
                windowType = Window.WinampMainWindow
            in
            -- JESUS IT WAS HARD JUST GETTING THIS TO WORK PROPERLY
            case Windows.isOpen windowType model.windows of
                True ->
                    case (Windows.get windowType model.windows) of
                        (Window.Window t_ geometry) ->
                            case geometry.isMinimized of
                                True ->
                                    "none"
                                False ->
                                    "inline"
                False ->
                    "none"
    in
    E.html
        <| Html.div
            [ Html.Attributes.id "weenamp"
            , Html.Attributes.style "z-index" (String.fromInt windowData.zIndex)
            , Html.Attributes.style "display" shouldShow
            ]
            []

-- we use this to decode what comes through the "winampIn" port
jsonToWinampMsg : String -> WinampMsg
jsonToWinampMsg str =
    let
        decoded = case JDecode.decodeString winampJsonDecoder str of
            Ok val ->
                val
            Err val ->
                JDecode.errorToString val
    in
        case decoded of
            "close" ->
                Close
            "windowClicked" ->
                WindowClicked
            "minimize" ->
                Minimize
            "unMinimize" ->
                UnMinimize
            _ ->
                SomethingWentTerriblyWrong 

type WinampMsg 
    = WindowClicked
    | Close
    | Minimize
    | UnMinimize
    | SomethingWentTerriblyWrong -- jk, it's probably just a stupid error on the js side

winampJsonDecoder =
    JDecode.field "event" JDecode.string

