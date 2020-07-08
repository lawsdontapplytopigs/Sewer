module Programs.FileExplorer exposing
    ( FileExplorerData
    , init
    )

type alias FileExplorerData =
    { path : String
    }

init: FileExplorerData
init =
        { path = "C:\\\\MyDocuments\\Albums"
        }


