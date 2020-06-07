#!/usr/bin/env bash


if [[ ! -d ./built ]]; then
    mkdir ./built
fi

cp ./art/windoze.jpg ./built/windoze.jpg

elm make ./src/Home/Main.elm --output=./built/index.html
