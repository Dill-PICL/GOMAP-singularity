#!/usr/bin/env bash

mkdir -p tmp

if [ -z $GOMAP_LOC ]
then
    GOMAP_LOC="$PWD"
fi
GOMAP_IMG="$GOMAP_LOC/GOMAP.simg"

if [ ! -f "$GOMAP_IMG" ]
then
    echo "The GOMAP image is missing" > /dev/stderr
    echo "Please run the setup.sh before running the test" > /dev/stderr
    exit 1
fi

args="$@"
domain=`echo $@ | grep domain`
mixmeth_blast=`echo $@ | grep mixmeth-blast`

if [ -z "$tmpdir" ]
then
    echo $TMPDIR
    tmpdir=${TMPDIR:-$PWD/tmp}
fi

nodes=$((SLURM_JOB_NUM_NODES + 1))

#SINGULARITY_BINDPATH="$GOMAP_LOC/GOMAP:/opt/GOMAP"

if [ ! -z "$domain" ] || [ ! -z "$mixmeth_blast" ]
then
    export SINGULARITY_BINDPATH="$PWD:/workdir,$tmpdir:/tmpdir"
    echo $SINGULARITY_BINDPATH
    echo "Running GOMAP $@"
    echo "using $SLURM_JOB_NUM_NODES for the process"
    mpiexec -np $nodes singularity run \
        -W $PWD/tmp \
        $GOMAP_IMG $@
else
    echo "ERROR: run-GOMAP-mpi.sh can only run the steps domain and mixmeth-blast using MPI" >> /dev/stderr
    echo "ERROR: Please run the other steps using run-GOMAP-SINGLE.sh " >> /dev/stderr
    exit 1
fi
