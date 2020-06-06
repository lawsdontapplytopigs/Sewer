module Icons exposing (xIcon)
import Svg exposing
  ( Svg, Attribute, text, node, map
  , svg, foreignObject
  , circle, ellipse, image, line, path, polygon, polyline, rect, use
  , animate, animateColor, animateMotion, animateTransform, mpath, set
  , desc, metadata, title
  , a, defs, g, marker, mask, pattern, switch, symbol
  , altGlyph, altGlyphDef, altGlyphItem, glyph, glyphRef, textPath, text_
  , tref, tspan
  , font
  , linearGradient, radialGradient, stop
  , feBlend, feColorMatrix, feComponentTransfer, feComposite
  , feConvolveMatrix, feDiffuseLighting, feDisplacementMap, feFlood, feFuncA
  , feFuncB, feFuncG, feFuncR, feGaussianBlur, feImage, feMerge, feMergeNode
  , feMorphology, feOffset, feSpecularLighting, feTile, feTurbulence
  , feDistantLight, fePointLight, feSpotLight
  , clipPath, colorProfile, cursor, filter
  -- , style
  , view
  )
import Svg.Attributes exposing (..)
import Html exposing (Html)


-- xIcon =
--     let
--         scaling = "2"
--     in
--     svg
--         [ id "svg8"
--         , version "1.1"
--         , viewBox "0 0 4.2333332 4.2333335"
--         , height "16"
--         , width "16" 
--         , Svg.Attributes.transform <| "scale(" ++ scaling ++ ")"
--         ]
--         [ defs
--             [ id "defs2" ]
--             []
--         , g [ id "layer2" ]
--             [ rect [ y "1.8520833", x "1.8520833", height "0.26458332", width "0.26458332", id "rect15", style "fill:#808080;stroke-width:0.264583" ] []
--             , rect [ style "fill:#808080;stroke-width:0.264583", id "rect17", width "0.26458332", height "0.26458332", x "2.1166668", y "1.5875001" ] []
--             , rect [ y "1.3229166", x "2.3812499", height "0.26458332", width "0.26458332", id "rect19", style "fill:#808080;stroke-width:0.264583" ] []
--             , rect [ style "fill:#808080;stroke-width:0.264583", id "rect21", width "0.26458332", height "0.26458332", x "2.6458333", y "1.0583333" ] []
--             , rect [ style "fill:#808080;stroke-width:0.264583", id "rect23", width "0.26458332", height "0.26458332", x "1.5875", y "1.5875" ] []
--             , rect [ y "1.3229166", x "1.3229166", height "0.26458332", width "0.26458332", id "rect25", style "fill:#808080;stroke-width:0.264583" ] []
--             , rect [ style "fill:#808080;stroke-width:0.264583", id "rect27", width "0.26458332", height "0.26458332", x "1.0583334", y "1.0583334" ] []
--             , rect [ style "fill:#808080;stroke-width:0.264583", id "rect29", width "0.26458332", height "0.26458332", x "1.5875", y "2.1166668" ] []
--             , rect [ y "2.3812499", x "1.3229166", height "0.26458332", width "0.26458332", id "rect31", style "fill:#808080;stroke-width:0.264583" ] []
--             , rect [ style "fill:#808080;stroke-width:0.264583", id "rect33", width "0.26458332", height "0.26458332", x "1.0583334", y "2.6458333" ] []
--             , rect [ y "2.1166666", x "2.1166668", height "0.26458332", width "0.26458332", id "rect35", style "fill:#808080;stroke-width:0.264583" ] []
--             , rect [ style "fill:#808080;stroke-width:0.264583", id "rect37", width "0.26458332", height "0.26458332", x "2.3812499", y "2.3812499" ] []
--             , rect [ y "2.6458333", x "2.6458333", height "0.26458332", width "0.26458332", id "rect39", style "fill:#808080;stroke-width:0.264583" ] []
--             ] 
--         ]

xIcon = svg [ id "svg8", version "1.1", viewBox "0 0 8.4666664 8.466667", height "32", width "32" ] [ defs [ id "defs2" ] [], metadata [ id "metadata5" ] [], g [ style "display:none", id "layer1" ] [ Svg.path [ id "rect12", style "fill:#e6e6e6;stroke-width:2", d "M 0,0 V 32 H 32 V 0 Z", transform "scale(0.26458333)" ] [] ], g [ id "layer2", style "display:inline" ] [ Svg.path [ id "path878", style "fill:#1e141a;fill-opacity:1;stroke-width:2.50312", d "M 2.6923693,1.5393509 1.9307186,2.3010016 6.0466694,6.4169525 6.8083201,5.6553018 Z" ] [], Svg.path [ d "M 1.9307186,5.6553018 2.6923693,6.4169525 6.8083202,2.3010017 6.0466695,1.539351 Z", style "fill:#1e141a;fill-opacity:1;stroke-width:2.50312", id "path880" ] [] ] ]
