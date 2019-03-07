#!/usr/bin/env bash

if [ -z $GOMAP_LOC ]
then
    GOMAP_LOC="$PWD"
fi
GOMAP_IMG="$GOMAP_LOC/GOMAP.simg"
GOMAP_DATA_LOC="$GOMAP_LOC/GOMAP-data"

if [ -z $MATLAB_LOC ]
then
    MATLAB_LOC="/shared/hpc/matlab/R2017a"
fi

if [ ! -f "$GOMAP_IMG" ]
then
    singularity pull --name `basename $GOMAP_IMG` "shub://Dill-PICL/GOMAP-singularity"
    mv  `basename $GOMAP_IMG` `dirname $GOMAP_IMG`
fi

args="$@"
mixmeth=`echo $@ | grep mixmeth | grep -v mixmeth-blast | grep -v mixmeth-preproc`
mixmeth_blast=`echo $@ | grep mixmeth-blast`
setup=`echo $@ | grep setup`

if [[ "$SLURM_CLUSTER_NAME" = "condo2017" ]]
then
    tmpdir="$TMPDIR"
else
    tmpdir="/tmp"
fi

export SINGULARITY_BINDPATH="$GOMAP_DATA_LOC:/opt/GOMAP/data,$GOMAP_DATA_LOC/mysql/lib:/var/lib/mysql,$GOMAP_DATA_LOC/mysql/log:/var/log/mysql,$PWD:/workdir,$tmpdir:/tmpdir"

if [ ! -z "$mixmeth" ]
then
    echo "Starting GOMAP instance"
    $GOMAP_LOC/stop-GOMAP.sh && \
    rsync -aq $GOMAP_LOC/GOMAP-data/mysql $tmpdir/ && \
    singularity instance.start   \
        -W $PWD/tmp \
        $GOMAP_IMG GOMAP && \
    singularity run \
        instance://GOMAP $@ && \
    $GOMAP_LOC/stop-GOMAP.sh
elif [ ! -z "$setup" ]
then
    echo "Running GOMAP $@"
    mkdir -p $GOMAP_DATA_LOC
    singularity run   \
        -W $PWD/tmp \
        $GOMAP_IMG $@
else
    echo "Running GOMAP $@"
    singularity run   \
        -W $PWD/tmp \
        $GOMAP_IMG $@
fi
