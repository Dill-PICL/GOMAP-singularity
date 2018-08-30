#!/usr/bin/env bash

GOMAP_LOC="$PWD/GOMAP.simg"
GOMAP_DATA_LOC="$PWD/GOMAP-data"

if [ ! -f "$GOMAP_LOC" ]
then
    module load singularity/2.6.0 && \
    SINGULARITY_PULLFOLDER=`dirname $GOMAP_LOC` \ 
    singularity pull --name `basename $GOMAP_LOC` shub://Dill-PICL/GOMAP-singularity:bridges
fi

config=$1
step=$2

name=`cat $config | grep -v "#" | fgrep basename | cut -f 2 -d ":" | tr -d ' '`
tmpdir="$HOME/tmpdir"

singularity run   \
    --bind GOMAP:/opt/GOMAP/ \
    --bind $GOMAP_DATA_LOC/mysql/lib:/var/lib/mysql  \
    --bind $GOMAP_DATA_LOC/mysql/log:/var/log/mysql  \
    --bind $GOMAP_DATA_LOC:/opt/GOMAP/data \
    --bind $PWD:/workdir  \
    --bind $tmpdir:/tmpdir  \
    -W $PWD/tmp \
    $GOMAP_LOC --step=$step --config=$config