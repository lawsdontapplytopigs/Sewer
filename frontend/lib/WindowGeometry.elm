module WindowGeometry exposing
    ( WindowGeometry
    , expandTop
    , expandRight
    , expandBottom
    , expandLeft
    , shrinkTop
    , shrinkRight
    , shrinkBottom
    , shrinkLeft
    , moveX
    , moveY
    , move
    , minimize
    , maximize
    )

-- type Window = 
--     Window WindowGeometry WindowType

-- type Program =
--     Program
--         { mainWindow = MainWindow
--         , secondaryWindows = Maybe ( List Window )
--         }

-- type MainWindow =
--     MainWindow 
--         Window
--         { isMinimized : Bool
--         , isMaximized : Bool
--         }

-- TODO: Maybe I can work out some better data type to hold all this together..
-- can the `type` of the window change while it's being shown?
-- can a "child" window be its own parent? etc..
-- Note: I left a possible implementation snippet above
type alias WindowGeometry =
    { x : Int
    , y : Int
    , width : Int
    , height : Int
    , minWidth : Int
    , minHeight : Int
    , isMaximized : Bool
    , isMinimized : Bool
    , title : String
    , wantsToNotBeClosed : Bool
    }

expandTop : Int -> WindowGeometry -> WindowGeometry
expandTop px win =
    { win
        | y = win.y - px
        , height = win.height + px
    }

expandRight : Int -> WindowGeometry -> WindowGeometry
expandRight px win =
    { win
        | width = win.width + px
    }

expandBottom : Int -> WindowGeometry -> WindowGeometry
expandBottom px win =
    { win
        | height = win.height + px
    }

expandLeft : Int -> WindowGeometry -> WindowGeometry
expandLeft px win =
    { win
        | x = win.x - px
        , width = win.width + px
    }

-- TODO: take into account the minimal dimensions
shrinkTop : Int -> WindowGeometry -> WindowGeometry
shrinkTop px win =
    { win
        | y = win.y + px
        , height = win.height - px
    }

shrinkRight : Int -> WindowGeometry -> WindowGeometry
shrinkRight px win =
    { win
        | width = win.width - px
    }

shrinkBottom : Int -> WindowGeometry -> WindowGeometry
shrinkBottom px win =
    { win
        | width = win.height - px
    }

shrinkLeft : Int -> WindowGeometry -> WindowGeometry
shrinkLeft px win =
    { win
        | x = win.x + px
        , width = win.width - px
    }

moveX : Int -> WindowGeometry -> WindowGeometry
moveX x win =
    { win
        | x = x
    }

moveY : Int -> WindowGeometry -> WindowGeometry
moveY y win =
    { win
        | y = y
    }

move { x, y } win =
    { win
        | x = x
        , y = y
    }

-- TODO: Take these out and refactor this module
minimize win =
    win
maximize win =
    win
