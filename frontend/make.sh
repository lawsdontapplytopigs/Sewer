#!/usr/bin/env bash


if [[ ! -d ./built ]]; then
    mkdir ./built
fi

elm make ./src/Home/Main.elm --output=./built/index.html
