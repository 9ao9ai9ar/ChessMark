#!/usr/bin/env bash

frawk -F ':' '/w:/{ white = $2 } 
              /b:/{ black = $2 } 
              /d:/{ draw = $2 } 
              END { print white + black + draw, white, black, draw }' \
    <(rg --glob='*.pgn' --text --no-filename --count --line-buffered \
         --crlf --no-unicode '^\[Result "1-0"\]$' | 
        frawk '{ s += $0 } END { print "w:" s }') \
    <(rg --glob='*.pgn' --text --no-filename --count --line-buffered \
         --crlf --no-unicode '^\[Result "0-1"\]$' | 
        frawk '{ s += $0 } END { print "b:" s }') \
    <(rg --glob='*.pgn' --text --no-filename --count --line-buffered \
         --crlf --no-unicode '^\[Result "1/2-1/2"\]$' | 
        frawk '{ s += $0 } END { print "d:" s }')

