#!/usr/bin/env bash

export LC_ALL=C
tar --extract --to-stdout --use-compress-program='pzstd' \
    --wildcards --wildcards-match-slash \
    --file="$TESTREPO/../$(basename "$TESTREPO").tar.zst" '*.pgn' | 
    grep -E --text --no-filename --line-buffered \
        $'^\[Result "(1-0|0-1|1/2-1/2)"\]\r*$' |
    mawk '{ ++count[$0] }
          END {
              for (i in count) split(i, r, "[-\"]") && a[r[2]] += count[i];
              for (i in a) total += a[i];
              print +total, +a["1"], +a["0"], +a["1/2"];
          }'

