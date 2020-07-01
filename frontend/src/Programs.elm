module Programs exposing
    ( ApplicationWindow(..)
    , openWindow
    , record
    , move
    )

import Programs.FileExplorer
import Programs.WinampRipoff
import Window

type ApplicationWindow
    = FileExplorerMainWindow
    | WinampMainWindow
    | WinampPlaylistWindow

openWindow window model =
    case window of
        FileExplorerMainWindow ->
            let
                oldWindows = model.programs.fileExplorer.windows
                newWindows = 
                    { oldWindows
                        | mainWindow = Window.open oldWindows.mainWindow
                    }

                oldFileExplorer = model.programs.fileExplorer
                newFileExplorer = 
                    { oldFileExplorer
                        | windows = newWindows
                    }
                    
                oldPrograms = model.programs
                newPrograms = 
                    { oldPrograms
                        | fileExplorer = newFileExplorer
                    }
            in
            { model
                | programs = newPrograms
            }
        WinampMainWindow ->
            let
                oldWindows = model.programs.winampRipoff.windows
                newWindows = 
                    { oldWindows
                        | mainWindow = Window.open oldWindows.mainWindow
                    }

                oldWinamp = model.programs.winampRipoff
                newWinamp = 
                    { oldWinamp
                        | windows = newWindows
                    }
                    
                oldPrograms = model.programs
                newPrograms = 
                    { oldPrograms
                        | winampRipoff = newWinamp
                    }
            in
            { model
                | programs = newPrograms
            }
        WinampPlaylistWindow ->
            let
                oldWindows = model.programs.winampRipoff.windows
                newWindows =
                    { oldWindows
                        | mainWindow = Window.open oldWindows.playlistWindow
                    }

                oldWinamp = model.programs.winampRipoff
                newWinamp = 
                    { oldWinamp
                        | windows = newWindows
                    }
                    
                oldPrograms = model.programs
                newPrograms = 
                    { oldPrograms
                        | winampRipoff = newWinamp
                    }
            in
            { model
                | programs = newPrograms
            }

record window model =
    let
        rec = model.record
    in
    case window of
        FileExplorerMainWindow ->
            let
                newRecord =
                    { rec
                        | windowX = model.programs.fileExplorer.windows.mainWindow.x
                        , windowY = model.programs.fileExplorer.windows.mainWindow.y
                        , absoluteX = model.absoluteX
                        , absoluteY = model.absoluteY
                    }
            in
                { model
                    | record = newRecord
                    , currentTitleBarHeldWindow = Debug.log "Titlebar window" (Just window)
                }
        WinampMainWindow ->
            let
                newRecord = 
                    { rec
                        | windowX = model.programs.winampRipoff.windows.mainWindow.x
                        , windowY = model.programs.winampRipoff.windows.mainWindow.y
                        , absoluteX = model.absoluteX
                        , absoluteY = model.absoluteY
                    }
            in
                { model
                    | record = newRecord
                    , currentTitleBarHeldWindow = Debug.log "Titlebar window" (Just window)
                }
        WinampPlaylistWindow ->
            let
                newRecord = 
                    { rec
                        | windowX = model.programs.winampRipoff.windows.playlistWindow.x
                        , windowY = model.programs.winampRipoff.windows.playlistWindow.y
                        , absoluteX = model.absoluteX
                        , absoluteY = model.absoluteY
                    }
            in
                { model
                    | record = newRecord
                    , currentTitleBarHeldWindow = Debug.log "Titlebar window" (Just window)
                }

-- to : { x : Int, y : Int }
move absoluteCoords to window model =
    case window of
        FileExplorerMainWindow ->
            let
                movedWindow = Window.move 
                    to
                    model.programs.fileExplorer.windows.mainWindow

                oldWindows = model.programs.fileExplorer.windows
                newWindows =
                    { oldWindows
                        | mainWindow = movedWindow
                    }

                oldFileExplorer = model.programs.fileExplorer
                newFileExplorer =
                    { oldFileExplorer
                        | windows = newWindows
                    }
                oldPrograms = model.programs
                newPrograms =
                    { oldPrograms
                        | fileExplorer = newFileExplorer
                    }
            in
                { model
                    | programs = newPrograms
                    , absoluteX = absoluteCoords.x
                    , absoluteY = absoluteCoords.y
                }
        WinampMainWindow ->
            let
                movedWindow = Window.move
                    to 
                    model.programs.winampRipoff.windows.mainWindow

                oldWindows = model.programs.winampRipoff.windows
                newWindows =
                    { oldWindows
                        | mainWindow = movedWindow
                    }

                oldWinamp = model.programs.winampRipoff
                newWinamp =
                    { oldWinamp
                        | windows = newWindows
                    }
                oldPrograms = model.programs
                newPrograms =
                    { oldPrograms
                        | winampRipoff = newWinamp
                    }
            in
                { model
                    | programs = newPrograms
                    , absoluteX = absoluteCoords.x
                    , absoluteY = absoluteCoords.y
                }
        WinampPlaylistWindow ->
            let
                movedWindow = Window.move
                    to
                    model.programs.winampRipoff.windows.playlistWindow

                oldWindows = model.programs.winampRipoff.windows
                newWindows =
                    { oldWindows
                        | playlistWindow = movedWindow
                    }

                oldWinamp = model.programs.winampRipoff
                newWinamp =
                    { oldWinamp
                        | windows = newWindows
                    }
                oldPrograms = model.programs
                newPrograms =
                    { oldPrograms
                        | winampRipoff = newWinamp
                    }
            in
                { model
                    | programs = newPrograms
                    , absoluteX = absoluteCoords.x
                    , absoluteY = absoluteCoords.y
                }


