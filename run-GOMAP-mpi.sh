#!/usr/bin/env bash

mkdir -p tmp

if [ -z $GOMAP_LOC ]
then
    GOMAP_LOC="$PWD"
fi
GOMAP_IMG="$GOMAP_LOC/GOMAP.simg"
GOMAP_DATA_LOC="$GOMAP_LOC/GOMAP/data"

if [ ! -f "$GOMAP_IMG" ]
then
    singularity pull --name `basename $GOMAP_IMG` shub://Dill-PICL/GOMAP-singularity:condo
    mv `basename $GOMAP_IMG` `dirname $GOMAP_IMG`
fi

args="$@"
domain=`echo $@ | grep domain`
mixmeth_blast=`echo $@ | grep mixmeth-blast`
setup=`echo $@ | grep setup`

if [ -z "$tmpdir" ]
then
    tmpdir=${TMPDIR:-/tmp}
fi

if [ -z $SLURM_JOB_NUM_NODES ]
then
    nodes=1
else
	if [ ! -z "$mixmeth_blast" ] || [ ! -z "$domain" ]
	then
        nodes=$((SLURM_JOB_NUM_NODES + 1))
	else
		nodes=$((SLURM_JOB_NUM_NODES))
	fi
fi

SINGULARITY_BINDPATH="$GOMAP_LOC/GOMAP/data:/opt/GOMAP/data"

if [ ! -z "$domain" ] || [ ! -z "$mixmeth_blast" ]
then
    export SINGULARITY_BINDPATH="$SINGULARITY_BINDPATH,$PWD:/workdir,$tmpdir:/tmpdir"
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
