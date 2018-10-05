#!/usr/bin/env bash

GOMAP_LOC="$PWD/GOMAP.simg"
GOMAP_DATA_LOC="$PWD/GOMAP-data"

if [ ! -f "$GOMAP_LOC" ]
then
    echo singularity pull --name `basename $GOMAP_LOC` shub://Dill-PICL/GOMAP-singularity:bridges
fi

args="$@"
mixmeth=`echo $args | grep mixmeth | grep -v mixmeth-blast`

if [[ "$SLURM_CLUSTER_NAME" = "condo2017" ]]
then
    tmpdir="$TMPDIR"
else
    tmpdir="/tmp"
fi

if [ ! -z $mixmeth ]
then
    echo "Starting GOMAP instance"
    singularity instance.start   \
        --bind $GOMAP_DATA_LOC/mysql/lib:/var/lib/mysql  \
        --bind $GOMAP_DATA_LOC/mysql/log:/var/log/mysql  \
        --bind $GOMAP_DATA_LOC:/opt/GOMAP/data \
        --bind $PWD:/workdir  \
        --bind $tmpdir:/tmpdir  \
        -W $PWD/tmp \
        $GOMAP_LOC GOMAP && \
        sleep 10 && \
    singularity run \
        instance://GOMAP $@
    ./stop-GOMAP.sh
else
    echo "Running GOMAP $@"
    mpiexec -n $SLURM_JOB_NUM_NODES singularity run   \
        --bind $GOMAP_DATA_LOC/mysql/lib:/var/lib/mysql  \
        --bind $GOMAP_DATA_LOC/mysql/log:/var/log/mysql  \
        --bind $GOMAP_DATA_LOC:/opt/GOMAP/data \
        --bind $PWD:/workdir  \
        --bind $tmpdir:/tmpdir  \
        -W $PWD/tmp \
        $GOMAP_LOC $@
fi
