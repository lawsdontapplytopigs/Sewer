module Window exposing
    ( WindowData
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
    , close
    , open
    , minimize
    , maximize
    )

type alias WindowData =
    { x : Int
    , y : Int
    , width : Int
    , height : Int
    , minWidth : Int
    , minHeight : Int
    , isOpen : Bool
    , isClosable : Bool
    , isMinimized : Bool
    , isMaximized : Bool
    , title : String
    }

expandTop : Int -> WindowData -> WindowData
expandTop px win =
    { win
        | y = win.y - px
        , height = win.height + px
    }

expandRight : Int -> WindowData -> WindowData
expandRight px win =
    { win
        | width = win.width + px
    }

expandBottom : Int -> WindowData -> WindowData
expandBottom px win =
    { win
        | height = win.height + px
    }

expandLeft : Int -> WindowData -> WindowData
expandLeft px win =
    { win
        | x = win.x - px
        , width = win.width + px
    }

-- TODO: take into account the minimal dimensions
shrinkTop : Int -> WindowData -> WindowData
shrinkTop px win =
    { win
        | y = win.y + px
        , height = win.height - px
    }

shrinkRight : Int -> WindowData -> WindowData
shrinkRight px win =
    { win
        | width = win.width - px
    }

shrinkBottom : Int -> WindowData -> WindowData
shrinkBottom px win =
    { win
        | width = win.height - px
    }

shrinkLeft : Int -> WindowData -> WindowData
shrinkLeft px win =
    { win
        | x = win.x + px
        , width = win.width - px
    }

moveX : Int -> WindowData -> WindowData
moveX x win =
    { win
        | x = x
    }

moveY : Int -> WindowData -> WindowData
moveY y win =
    { win
        | y = y
    }

move { x, y } win =
    { win
        | x = x
        , y = y
    }

close : WindowData -> WindowData
close win =
    { win 
        | isOpen = False
    }

open : WindowData -> WindowData
open win =
    { win
        | isOpen = True
    }

minimize : WindowData -> WindowData
minimize win =
    { win
        | isMinimized = True
    }

maximize : WindowData -> WindowData
maximize win =
    { win
        | isMaximized = True
    }

