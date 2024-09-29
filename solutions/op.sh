#!/usr/bin/env bash

find . -type f -name '*.pgn' -print0 |
    xargs -0 mawk -F '[-"]' '/Result/{ ++a[$2] } 
        END { print a["1"] + a["0"] + a["1/2"], a["1"], a["0"], a["1/2"] }'

