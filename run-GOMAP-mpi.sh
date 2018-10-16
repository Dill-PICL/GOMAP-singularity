#!/usr/bin/env bash

if [ -z $GOMAP_LOC ]
then
    GOMAP_LOC="$PWD"
fi
GOMAP_IMG="$GOMAP_LOC/GOMAP.simg"
GOMAP_DATA_LOC="$GOMAP_LOC/GOMAP-data"

if [ ! -f "$GOMAP_IMG" ]
then
    singularity pull --name `$GOMAP_IMG` shub://Dill-PICL/GOMAP-singularity:bridges
fi

args="$@"
mixmeth=`echo $@ | grep mixmeth | grep -v mixmeth-blast | grep -v mixmeth-preproc`
mixmeth_blast=`echo $@ | grep mixmeth-blast`

if [[ "$SLURM_CLUSTER_NAME" = "condo2017" ]]
then
    tmpdir="$TMPDIR"
else
    tmpdir="/tmp"
fi

if [ ! -z $SLURM_JOB_NUM_NODES ]
then
	if [ ! -z "$mixmeth_blast" ]
	then
    		nodes=$((SLURM_JOB_NUM_NODES + 1))
	else
		nodes=$((SLURM_JOB_NUM_NODES))
	fi
else
    nodes=1
fi

if [ ! -z "$mixmeth" ]
then
    echo "Starting GOMAP instance"
    $GOMAP_LOC/stop-GOMAP.sh
    rsync -aP $GOMAP_LOC/GOMAP-data/mysql $tmpdir/
    singularity instance.start   \
        --bind $tmpdir/mysql/lib:/var/lib/mysql  \
        --bind $tmpdir/mysql/log:/var/log/mysql  \
        --bind $GOMAP_DATA_LOC:/opt/GOMAP/data \
        --bind $PWD:/workdir  \
        --bind $tmpdir:/tmpdir  \
        -W $PWD/tmp \
        $GOMAP_IMG GOMAP && \
    singularity run \
        instance://GOMAP $@ &&
    $GOMAP_LOC/stop-GOMAP.sh
else
    echo "Running GOMAP $@"
    echo "using $SLURM_JOB_NUM_NODES for the process"
    mpiexec -np $nodes singularity run   \
        --bind $GOMAP_DATA_LOC/mysql/lib:/var/lib/mysql  \
        --bind $GOMAP_DATA_LOC/mysql/log:/var/log/mysql  \
        --bind $GOMAP_DATA_LOC:/opt/GOMAP/data \
        --bind $PWD:/workdir  \
        --bind $tmpdir:/tmpdir  \
        -W $PWD/tmp \
        $GOMAP_IMG $@
fi
