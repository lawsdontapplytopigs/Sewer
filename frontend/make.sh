#!/usr/bin/env bash


if [[ ! -d ./built ]]; then
    mkdir ./built
fi
# cp ./art/windoze.jpg ./built/windoze.jpg
cp ./prebuilt/index.html ./built/index.html

if [[ ! -d ./built/icons ]]; then
    mkdir ./built/icons
fi
cp ./art/icons/w95_16.ico ./built/icons/0.ico
cp ./art/icons/w95_40.ico ./built/icons/1.ico #TODO: replace this with the right 'Start' icon
cp ./art/icons/w95_5.ico ./built/icons/2.ico # File Explorer
cp ./art/icons/w95_6.ico ./built/icons/3.ico #TODO: get the right icon
cp ./art/icons/w95_31.ico ./built/icons/4.ico # wannabe Outlook

cp -r ./prebuilt/fonts ./built/

cp -r ./prebuilt/albums ./built/

elm make ./src/Main.elm --output=./built/app.js
