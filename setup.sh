#!/usr/bin/env bash

mkdir -p tmp

if [ -z $GOMAP_LOC ]
then
    GOMAP_LOC="$PWD"
fi

# Declaring variables for different options

export ICOMMANDS_IMG="icommands.sif"
export GOMAP_IMG="GOMAP.sif"
export GOMAP_URL="/iplant/home/shared/dillpicl/gomap/GOMAP/1.3.3/$GOMAP_IMG"

if [ ! -f $GOMAP_LOC/$GOMAP_IMG ]
then
    singularity pull -F $ICOMMANDS_IMG shub://wkpalan/icommands-cyverse:latest && \
    singularity run $ICOMMANDS_IMG irsync -v i:$GOMAP_URL $GOMAP_LOC/$GOMAP_IMG && \
    rm $ICOMMANDS_IMG
else
    echo "The $GOMAP_LOC/$GOMAP_IMG exists" > /dev/stderr
    echo "Delete the image if you want to download it" /dev/stderr
fi
