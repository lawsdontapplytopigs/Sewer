#!/usr/bin/env bash


if [[ ! -d ./built ]]; then
    mkdir ./built
fi
cp ./prebuilt/index.html ./built/index.html

if [[ ! -d ./built/icons ]]; then
    mkdir ./built/icons
fi
#IMAGES
cp ./prebuilt/no_signal_bars.jpg ./built/
cp ./prebuilt/shuffle.png ./built/
cp ./prebuilt/repeat.png ./built/
# cp -r ./prebuilt/albums ./built/ #un-comment this for production

#ICONS
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


# all the js
cp ./prebuilt/howler.core.min.js ./built/
cp ./prebuilt/albums.js ./built/
# all the css
cp ./prebuilt/general.css ./built/general.css

JS="./built/elm.js"
MIN="./built/elm.min.js"
ELM_MAIN="./src/Main.elm"


if [[ "$1" = "--optimize" ]]; then
    
    elm make $ELM_MAIN --optimize --output="$JS"
    uglifyjs $JS --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle > $MIN
    echo "Compiled size:$(cat $JS | wc -c) bytes  ($JS)"
    echo "Minified size:$(cat $MIN | wc -c) bytes  ($MIN)"
    echo "Gzipped size: $(cat $MIN | gzip -c | wc -c) bytes"
else
    elm make $ELM_MAIN --output="$JS"

fi



