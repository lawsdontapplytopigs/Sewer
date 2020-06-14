module Home.Msg exposing 
    ( Msg(..)
    )

import Home.Types as Types

type Msg
    = Tick Float
    | OpenApplication Types.App
    | UpdateFileExplorer
