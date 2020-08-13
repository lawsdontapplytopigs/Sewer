#!/usr/bin/env bash

serveCMD='go run ./backend/main.go'

cd frontend
./make.sh && cd .. && $serveCMD
