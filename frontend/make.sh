#!/usr/bin/env bash


if [[ ! -d ./built ]]; then
    mkdir ./built
fi
# cp ./art/windoze.jpg ./built/windoze.jpg
cp ./prebuilt/index.html ./built/index.html

if [[ ! -d ./built/icons ]]; then
    mkdir ./built/icons
fi

IC='./art/icons/additional/windows98-icons/png'

#My computer icons
cp "$IC/computer_explorer-2.png" ./built/icons/0.0.png

cp ./art/icons/w95_40.ico ./built/icons/1.ico #TODO: replace this with the right 'Start' icon
cp ./art/winampRipoff/SWamp.png ./built/icons/3.png #Webamp

# we get the ico files here from somewhere else, because they look better
cp "./art/icons/w95_5.ico" ./built/icons/2.0.png # File Explorer 
cp "./art/icons/w95_5.ico" ./built/icons/2.1.png # File Explorer

#Poor man's outlook icons
cp "$IC/message_envelope_open-0.png" ./built/icons/4.0.png
cp "$IC/message_envelope_open-1.png" ./built/icons/4.1.png

cp "$IC/loudspeaker_rays-0.png" ./built/icons/5.0.png
cp "$IC/loudspeaker_rays-1.png" ./built/icons/5.1.png

cp -r ./prebuilt/fonts ./built/
cp -r ./prebuilt/albums ./built/

# all the js
cp ./prebuilt/webamp.bundle.min.js ./built/webamp.bundle.min.js
# all the css
cp ./prebuilt/general.css ./built/general.css

elm make ./src/Main.elm --output=./built/app.js
