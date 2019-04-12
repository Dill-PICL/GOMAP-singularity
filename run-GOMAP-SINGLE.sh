#!/usr/bin/env bash

mkdir -p tmp

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

GOMAP_URL="shub://Dill-PICL/GOMAP-singularity:v1.1"
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
    tmpdir=${TMPDIR:-$PWD/tmp}
fi

echo $tmpdir

SINGULARITY_BINDPATH="GOMAP_DATA_LOC:/opt/GOMAP/data,$GOMAP_LOC/GOMAP:/opt/GOMAP"

if [ ! -z "$mixmeth" ]
then
    export SINGULARITY_BINDPATH="$SINGULARITY_BINDPATH$GOMAP_DATA_LOC/mysql/lib:/var/lib/mysql,$GOMAP_DATA_LOC/mysql/log:/var/log/mysql,$PWD:/workdir,$tmpdir:/tmpdir,$tmpdir:/run/mysqld"
    echo "$SINGULARITY_BINDPATH"
    echo "Starting GOMAP instance"
    $GOMAP_LOC/stop-GOMAP.sh && \
    singularity instance.start   \
        $GOMAP_IMG GOMAP && \
	sleep 10 && \
    singularity run \
        instance://GOMAP $@ && \
    $GOMAP_LOC/stop-GOMAP.sh
elif [ ! -z "$setup" ]
then
    export SINGULARITY_BINDPATH="$SINGULARITY_BINDPATH,$PWD:/workdir,$tmpdir:/tmpdir"
    echo "Running GOMAP $@"
    mkdir -p $GOMAP_DATA_LOC
    singularity run   \
        $GOMAP_IMG $@
else
    export SINGULARITY_BINDPATH="$SINGULARITY_BINDPATH,$PWD:/workdir,$tmpdir:/tmpdir,$MATLAB_LOC:/matlab"
    echo "Running GOMAP $@"
    singularity run \
        $GOMAP_IMG $@
fi
