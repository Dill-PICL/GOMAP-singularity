#!/usr/bin/env bash

export GOMAP_LOC="$PWD/GOMAP.simg" && export GOMAP_DATA_LOC="$PWD/GOMAP-data"

mpirun -n 2 -host master,slave ./run-GOMAP.py --config test/config.yml --tmpdir=$HOME/tmpdir --step=$1