# ChessMark

## Setup

```shell
sudo dnf install mawk ripgrep zstd
# Install frawk: https://github.com/ezrosent/frawk
python -m venv .venv
. .venv/bin/activate
python -m pip install pandas plotly kaleido
# Download default dataset as a gzip file and extract it: https://github.com/rozim/ChessData
# For any dataset X to be used, make an X.tar.zst compressed archive using pzstd.
# Below is an example command using the default dataset extracted at ChessData-master:
# tar --create --use-compress-program='pzstd' --file='./ChessData-master.tar.zst' ./ChessData-master
```

## Usage

```shell
# Default dataset: ./ChessData-master
./benchmark.sh
# Specify a dataset
./benchmark.sh ./LumbrasGigaBase
# Do not drop caches
KEEP_CACHES=1 ./benchmark.sh
# GNU commands only
GNU=1 ./benchmark.sh
# Custom runs
RUNS=10 ./benchmark.sh
```
