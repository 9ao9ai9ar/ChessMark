# ChessMark

## Setup

```bash
sudo dnf install mawk ripgrep zstd
# Install frawk: https://github.com/ezrosent/frawk
python -m venv .venv
. .venv/bin/activate
python -m pip install pandas plotly kaleido
# Download default dataset as a gzip file and extract it: https://github.com/rozim/ChessData
# For any dataset X to be used, make a X.tar.zst compressed archive
```

## Usage

```bash
# Default dataset: ./ChessData-master
./benchmark.sh
# Specify a dataset
./benchmark.sh ./LumbrasGigaBase
# Do not drop cache
KEEP_CACHES=1 ./benchmark.sh
# POSIX commands only
POSIX=1 ./benchmark.sh
# Custom runs
RUNS=10 ./benchmark.sh
```

