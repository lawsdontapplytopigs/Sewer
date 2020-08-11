module Palette exposing (..)

import Element as E

-- font0 = "Droid Sans"
-- font0 = "MS Sans Serif"
font0 = "W95FA"
-- font0 = "px_sans_nouveaux"
-- font0 = "pix M 8pt"
font1 = "undefined"

fontSize0 = 14
fontSize1 = 15

gray0 = E.rgb255 30 20 26
gray1 = E.rgb255 150 70 120
gray3 = E.rgb255 220 180 205
gray4 = E.rgb255 225 195 255

white = E.rgb255 255 255 255

-- color0 = E.rgb255 255 170 210
color0 = E.rgb255 245 180 255
color1 = E.rgb255 255 215 228
color2 = E.rgb255 175 80 240
color3 = E.rgb255 0 0 176 -- windows95 blue


padding0 = 10
padding1 = 20
padding2 = 40
padding3 = 60
padding4 = 80
padding5 = 160

ic name = "./icons/" ++ name

iconMyComputer = ic "0.0.png"
iconFileExplorer = ic "2.0.png"
iconFileExplorerSmall = ic "2.1.png"
iconWebamp = ic "3.png"
iconPoorMansOutlook = ic "4.0.png"
iconPoorMansOutlookSmall = ic "4.1.png"
iconSpeaker = ic "5.0.png"
iconSpeakerSmall = ic "5.1.png"
