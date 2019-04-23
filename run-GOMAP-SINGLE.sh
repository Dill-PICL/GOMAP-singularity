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
mixmeth=`echo $@ | grep mixmeth | grep -v mixmeth-blast | grep -v mixmeth-preproc`
setup=`echo $@ | grep setup`

if [ -z $tmpdir ]
then
    tmpdir=${TMPDIR:-$PWD/tmp}
fi

#SINGULARITY_BINDPATH="$GOMAP_LOC/GOMAP:/opt/GOMAP"

if [ ! -z "$mixmeth" ]
then
    echo "Running GOMAP $@"
    export SINGULARITY_BINDPATH="$SINGULARITY_BINDPATH,$PWD:/workdir,$tmpdir:/tmpdir,tmp:/run/mysqld,$GOMAP_LOC/mysql:/var/lib/mysql"
    echo "Starting GOMAP instance"
    $GOMAP_LOC/stop-GOMAP.sh && \
    singularity instance.start -c \
        $GOMAP_IMG GOMAP && \
	sleep 1 && \
    singularity run  \
        instance://GOMAP $@ #&& \
    #$GOMAP_LOC/stop-GOMAP.sh
elif [ ! -z "$setup" ]
then
    echo "The setup has been moved from this script to is own script" > /dev/stderr
    echo "Please run the step using $GOMAP_LOC/setup.sh for the setup step" > /dev/stderr
    exit 1
else
    export SINGULARITY_BINDPATH="$SINGULARITY_BINDPATH,$PWD:/workdir,$tmpdir:/tmpdir"   
    echo "$SINGULARITY_BINDPATH"
    echo "Running GOMAP $@"
    singularity run -c \
        $GOMAP_IMG $@
fi
