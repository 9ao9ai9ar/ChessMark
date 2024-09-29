#!/usr/bin/env bash

rg --glob='*.pgn' --text --no-filename --no-line-number --crlf --no-unicode \
    '^\[Result "(1-0|0-1|1/2-1/2)"\]$' | 
    mawk -F '[-"]' 'BEGIN { a[1] = a[0] = a["1/2"] = 0 } 
                    { ++a[$2] }
                    END { print a[1] + a[0] + a["1/2"], a[1], a[0], a["1/2"] }'

