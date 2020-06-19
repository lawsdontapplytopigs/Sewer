#!/usr/bin/env bash

#serveCMD='python3 -m http.server --bind=127.0.0.1 8080 --directory=./built'
serveCMD='go run ./backend/main.go'

cd frontend
./make.sh && cd .. && $serveCMD
