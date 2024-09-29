#!/usr/bin/env bash

rg --glob='*.pgn' --text --no-filename --no-line-number --crlf --no-unicode \
    '^\[Result "(1-0|0-1|1/2-1/2)"\]$' | 
    mawk '{ ++count[$0] }
          END {
              for (i in count) split(i, r, "[-\"]") && a[r[2]] += count[i];
              for (i in a) total += a[i];
              print +total, +a["1"], +a["0"], +a["1/2"];
          }'

