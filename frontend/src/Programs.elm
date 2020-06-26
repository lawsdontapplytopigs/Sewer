module Programs exposing 
    ( Program(..)
    )

type Program 
    = FileExplorer WindowInformation
    | WinampRipoff WindowInformation
    | BrokeAssOutlook WindowInformation

type alias WindowInformation =
    { x : Int
    , y : Int
    , width : Int
    , height : Int
    , minHeight : Int
    , minWidth: Int
    }

