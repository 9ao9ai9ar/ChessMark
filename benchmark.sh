#!/usr/bin/env bash

export TESTREPO=$(realpath --canonicalize-existing "${1:-./ChessData-master}")
! [[ -d "$TESTREPO" ]] && exit
PROJECTROOT=$(dirname "$(realpath "${BASH_SOURCE[@]}")")
serial=$(date --rfc-3339=seconds --utc | sed 's/+00:00\|[-: ]//g')
repo_name=$(basename "$TESTREPO")
RESULT="$TESTREPO/../$repo_name-$serial.log"
TIMEFORMAT=$'real\t%2R\nuser\t%2U\nsys\t%2S'
runs=$(( ${RUNS:-7} ))
[[ $runs -le 0 ]] && exit

OLDWD=$(pwd)
trap 'cd "$OLDWD"' ERR RETURN
cd "$TESTREPO"
if [[ -n "$POSIX" ]]
then
    function mawk { awk "$@"; }
    export -f mawk
fi
exec 3>&1 1>>"$RESULT"
exec 4>&2 2>&1
for i in $(seq 1 $runs)
do
    for solution in $(shuf --echo "$PROJECTROOT/solutions/"*.sh)
    do
        name=$(basename $solution)
        if [[ -n "$POSIX" ]]
        then
            [[ "$name" =~ ^rg.*\.sh$ ]] && continue
        else
            [[ "$name" =~ ^grep.*\.sh$ ]] && continue
        fi
        [[ -n "$KEEP_CACHES" ]] || "$PROJECTROOT/drop_caches.sh"
        echo "$name"
        time "$solution"
        sleep 3
    done
done
exec 1>&3 3>&-
exec 2>&4 4>&-
unset -f mawk

{
    seq 1 $runs | 
        awk 'BEGIN { RS = $'\0'; OFS = "," } { $1 = $1; print "solution", $0 }'
    grep -E --no-group-separator -A2 '^.*\.sh$' "$RESULT" | 
        awk -F '\t' '/^.*\.sh$/{ k = $1; getline; getline; a[k] = a[k]","$2 } 
                     END { for (s in a) { print s a[s] } }' | sort
} >>"${RESULT/%.log/.csv}"

title="$repo_name benchmark"
[[ -n "$POSIX" ]] && title="$title, POSIX commands"
[[ -n "$KEEP_CACHES" ]] && title="$title, cached" 
cd "$PROJECTROOT"
. .venv/bin/activate
python - <<EOF
import pandas as pd
import plotly.express as px
import plotly.io as pio

pio.renderers.default = "png"
df = pd.read_csv("${RESULT/%.log/.csv}")
dft = df.set_index('solution').T
fig = (px.line(dft, title="$title")
       .update_layout(xaxis_title="runs", yaxis_title="seconds"))
fig.write_image("${RESULT/%.log/.png}")
print("mean", dft.mean().sort_values(), sep="\r\n")
print("median", dft.median().sort_values(), sep="\r\n")
fig.show(renderer="firefox")
EOF

