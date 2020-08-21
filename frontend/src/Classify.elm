module Classify exposing (..)


{-| -}
type alias Device =
    { class : DeviceClass
    , orientation : Orientation
    }


{-| -}
type DeviceClass
    = Phone
    | Tablet
    | Desktop
    | BigDesktop


{-| -}
type Orientation
    = Portrait
    | Landscape


{-| Takes in a Window.Size and returns a device profile which can be used for responsiveness.

If you have more detailed concerns around responsiveness, it probably makes sense to copy this function into your codebase and modify as needed.

-}
classifyDevice : { window | height : Int, width : Int } -> Device
classifyDevice window =
    -- Tested in this ellie:
    -- https://ellie-app.com/68QM7wLW8b9a1
    { class =
        let
            longSide =
                max window.width window.height

            shortSide =
                min window.width window.height
        in
        if shortSide < 600 then
            Phone

        else if longSide <= 1200 then
            Tablet

        else if longSide > 1200 && longSide <= 1800 then
            Desktop

        else
            BigDesktop
    , orientation =
        if window.width < window.height then
            Portrait

        else
            Landscape
    }


