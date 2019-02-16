#!/usr/bin/env bash

mkdir -p tmp

if [ -z $GOMAP_LOC ]
then
    GOMAP_LOC="$PWD"
fi

GOMAP_URL="shub://Dill-PICL/GOMAP-singularity"

GOMAP_IMG="$GOMAP_LOC/GOMAP.simg"
GOMAP_DATA_LOC="$GOMAP_LOC/GOMAP-data"

if [ -z $MATLAB_LOC ]
then
    MATLAB_LOC="/shared/hpc/matlab/R2017a"
fi

if [ ! -f "$GOMAP_IMG" ]
then
    singularity pull --name `basename $GOMAP_IMG` "$GOMAP_URL"
    mv  `basename $GOMAP_IMG` `dirname $GOMAP_IMG`
fi

args="$@"
mixmeth=`echo $@ | grep mixmeth | grep -v mixmeth-blast | grep -v mixmeth-preproc`
mixmeth_blast=`echo $@ | grep mixmeth-blast`
setup=`echo $@ | grep setup`

if [ -z $tmpdir ]
then
    tmpdir=${TMPDIR:-/tmp}
fi

#chown -R $USER $tmpdir/ && \

if [ ! -z "$mixmeth" ]
then
    export SINGULARITY_BINDPATH="$GOMAP_DATA_LOC:/opt/GOMAP/data,$GOMAP_DATA_LOC/mysql/lib:/var/lib/mysql,$GOMAP_DATA_LOC/mysql/log:/var/log/mysql,$PWD:/workdir,$tmpdir:/tmpdir"
    echo "Starting GOMAP instance"
    $GOMAP_LOC/stop-GOMAP.sh && \
    rsync -avu $GOMAP_LOC/GOMAP-data/mysql $tmpdir/ && \
    singularity instance.start   \
        $GOMAP_IMG GOMAP && \
	sleep 30 && \
    singularity run \
        instance://GOMAP $@ && \
    $GOMAP_LOC/stop-GOMAP.sh
elif [ ! -z "$setup" ]
then
    export SINGULARITY_BINDPATH="$GOMAP_DATA_LOC:/opt/GOMAP/data,$PWD:/workdir,$tmpdir:/tmpdir"
    echo "Running GOMAP $@"
    mkdir -p $GOMAP_DATA_LOC
    singularity run   \
        $GOMAP_IMG $@
else
    export SINGULARITY_BINDPATH="$GOMAP_DATA_LOC:/opt/GOMAP/data,$PWD:/workdir,$tmpdir:/tmpdir,$MATLAB_LOC:/matlab"
    echo "Running GOMAP $@"
    echo "using $SLURM_JOB_NUM_NODES for the process"
    singularity run   \
        $GOMAP_IMG $@
fi
