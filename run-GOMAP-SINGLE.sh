#!/usr/bin/env bash

mkdir -p tmp

if [ -z $GOMAP_LOC ]
then
    GOMAP_LOC="$PWD"
fi

GOMAP_IMG="$GOMAP_LOC/GOMAP.simg"
GOMAP_DATA_LOC="$GOMAP_LOC/GOMAP/data"

GOMAP_URL="shub://Dill-PICL/GOMAP-singularity:v1.2"

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

SINGULARITY_BINDPATH="$GOMAP_LOC/GOMAP/data:/opt/GOMAP/data"

if [ ! -z "$mixmeth" ]
then
    export SINGULARITY_BINDPATH="$SINGULARITY_BINDPATH,$GOMAP_LOC/data/mysql/lib:/var/lib/mysql,$GOMAP_LOC/data/mysql/log:/var/log/mysql,$PWD:/workdir,$tmpdir:/tmpdir,$tmpdir:/run/mysqld"
    echo "Starting GOMAP instance"
    $GOMAP_LOC/stop-GOMAP.sh && \
    singularity instance.start -c  \
        $GOMAP_IMG GOMAP && \
	sleep 10 && \
    singularity run \
        instance://GOMAP $@ && \
    $GOMAP_LOC/stop-GOMAP.sh
elif [ ! -z "$setup" ]
then
    mkdir -p $GOMAP_LOC/GOMAP/data
    export SINGULARITY_BINDPATH="$SINGULARITY_BINDPATH,$PWD:/workdir,$tmpdir:/tmpdir"
    echo "Running GOMAP $@"
    mkdir -p $GOMAP_DATA_LOC
    singularity run \
        $GOMAP_IMG $@
else
    export SINGULARITY_BINDPATH="$GOMAP_DATA_LOC:/opt/GOMAP/data,$PWD:/workdir,$tmpdir:/tmpdir"   
    echo "Running GOMAP $@"
    singularity run -c \
        $GOMAP_IMG $@
fi
