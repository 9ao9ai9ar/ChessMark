#!/usr/bin/env bash

mawk -F ':' '/w:/{ white = $2 } 
             /b:/{ black = $2 } 
             /d:/{ draw = $2 } 
             END { print white + black + draw, +white, +black, +draw }' \
    <(rg --glob='*.pgn' --text --no-filename --count \
         --crlf --no-unicode '^\[Result "1-0"\]$' | 
        mawk '{ s += $0 } END { print "w:" s }') \
    <(rg --glob='*.pgn' --text --no-filename --count \
         --crlf --no-unicode '^\[Result "0-1"\]$' | 
        mawk '{ s += $0 } END { print "b:" s }') \
    <(rg --glob='*.pgn' --text --no-filename --count \
         --crlf --no-unicode '^\[Result "1/2-1/2"\]$' | 
        mawk '{ s += $0 } END { print "d:" s }')

