#!/usr/bin/env bash

tar --extract --to-stdout --use-compress-program='pzstd' \
    --wildcards --wildcards-match-slash \
    --file="$TESTREPO/../$(basename "$TESTREPO").tar.zst" '*.pgn' | 
    mawk -F '[-"]' 'BEGIN { a[1] = a[0] = a["1/2"] = 0 } 
                    /Result/{ ++a[$2] } 
                    END { print a[1] + a[0] + a["1/2"], a[1], a[0], a["1/2"] }'

