#!/usr/bin/env bash

export LC_ALL=C
grep -E --recursive --include='*.pgn' --no-filename --line-buffered \
    $'^\[Result "(1-0|0-1|1/2-1/2)"\]\r*$' |
    awk -F '[-"]' 'BEGIN { a[1] = a[0] = a["1/2"] = 0 } 
                   { ++a[$2] } 
                   END { print a[1] + a[0] + a["1/2"], a[1], a[0], a["1/2"] }'

