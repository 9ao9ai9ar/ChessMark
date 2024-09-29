#!/usr/bin/env bash

export LC_ALL=C
awk -F ':' '/w:/{ white = $2 } 
            /b:/{ black = $2 } 
            /d:/{ draw = $2 } 
            END { print white + black + draw, white, black, draw }' \
    <(grep -E --no-filename --count --line-buffered \
           --recursive --include='*.pgn' $'^\[Result "1-0"\]\r*$' | 
        awk '{ s += $0 } END { print "w:" s }') \
    <(grep -E --no-filename --count --line-buffered \
           --recursive --include='*.pgn' $'^\[Result "0-1"\]\r*$' | 
        awk '{ s += $0 } END { print "b:" s }') \
    <(grep -E --no-filename --count --line-buffered \
           --recursive --include='*.pgn' $'^\[Result "1/2-1/2"\]\r*$' | 
        awk '{ s += $0 } END { print "d:" s }')

