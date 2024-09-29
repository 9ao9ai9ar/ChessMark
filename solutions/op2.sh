#!/usr/bin/env bash

n=$(nproc)
find . -type f -name '*.pgn' -print0 | 
    xargs --null -n $n --max-procs=$n mawk -F '[-"]' \
        'BEGIN { a[1] = a[0] = a["1/2"] = 0 } 
         /Result/{ ++a[$2] } 
         END { print a[1] + a[0] + a["1/2"], a[1], a[0], a["1/2"] }' |
    mawk '{ games += $1; white += $2; black += $3; draw += $4; } 
          END { print games, white, black, draw }'

