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
    in
    E.html
        <| Html.div
            [ Html.Attributes.id "weenamp"
            , Html.Attributes.style "z-index" (String.fromInt windowData.zIndex)
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
            _ ->
                SomethingWentTerriblyWrong 

type WinampMsg 
    = WindowClicked
    | Close
    | Minimize
    | SomethingWentTerriblyWrong -- jk, it's probably just a stupid error on the js side

winampJsonDecoder =
    JDecode.field "event" JDecode.string

