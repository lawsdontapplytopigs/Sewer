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

cp -r ./prebuilt/fonts ./built/

cp -r ./prebuilt/albums ./built/

elm make ./src/Home/Main.elm --output=./built/app.js
