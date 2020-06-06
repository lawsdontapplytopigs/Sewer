#!/usr/bin/env bash

serveCMD='python3 -m http.server --bind=127.0.0.1 8080 --directory=./built'

cd frontend
./make.sh && $serveCMD
