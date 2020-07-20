module Palette exposing (..)

import Element as E

-- font0 = "Droid Sans"
-- font0 = "MS Sans Serif"
font0 = "W95FA"
-- font0 = "pix M 8pt"
font1 = "undefined"

fontSize0 = 14
fontSize1 = 16

gray0 = E.rgb255 30 20 26
gray1 = E.rgb255 150 70 120
gray3 = E.rgb255 220 180 205
gray4 = E.rgb255 255 210 230

white = E.rgb255 255 255 255

color0 = E.rgb255 255 170 210
color1 = E.rgb255 255 215 228

ic name = "./icons/" ++ name

iconMyComputer = ic "0.ico"
iconFileExplorer = ic "2.0.png"
iconFileExplorerSmall = ic "2.1.png"
iconWebamp = ic "3.png"
iconPoorMansOutlook = ic "4.0.png"
iconPoorMansOutlookSmall = ic "4.1.png"
