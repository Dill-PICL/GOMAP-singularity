#!/usr/bin/env bash

mkdir -p tmp

if [ -z $GOMAP_LOC ]
then
    GOMAP_LOC="$PWD"
fi

# Declaring variables for different options

export IRODS_HOST="data.cyverse.org"
export IRODS_PORT="1247"
export IRODS_USER_NAME="anonymous"
export IRODS_ZONE_NAME="iplant"
export ICOMMANDS_IMG="icommands.sif"
export GOMAP_IMG="GOMAP.sif"
export GOMAP_URL="/iplant/home/shared/dillpicl/gomap/GOMAP/v1.3.3/$GOMAP_IMG"
export SINGULARITY_BINDPATH="$GOMAP_LOC:$GOMAP_LOC"


if [ ! -f $ICOMMANDS_IMG ]
then
    singularity pull -F $ICOMMANDS_IMG shub://wkpalan/icommands-cyverse:latest
elif [ ! -f $GOMAP_LOC/$GOMAP_IMG ]
then
    singularity run $ICOMMANDS_IMG ls $GOMAP_LOC
    singularity run $ICOMMANDS_IMG iget -P $GOMAP_URL $GOMAP_LOC/$GOMAP_IMG
else
    echo "The $GOMAP_LOC/$GOMAP_IMG exists" > /dev/stderr
    echo "Delete the image if you want to download it" /dev/stderr
fi
