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
<<<<<<< HEAD
export GOMAP_URL="/iplant/home/shared/dillpicl/gomap/GOMAP/v1.3.3/$GOMAP_IMG"
=======
export GOMAP_URL="/iplant/home/shared/dillpicl/gomap/GOMAP/1.3.3/$GOMAP_IMG"
>>>>>>> dev

if [ ! -f $GOMAP_LOC/$GOMAP_IMG ]
then
    singularity pull -F $ICOMMANDS_IMG shub://wkpalan/icommands-cyverse:latest && \
    singularity run $ICOMMANDS_IMG irsync -v i:$GOMAP_URL $GOMAP_LOC/$GOMAP_IMG && \
    rm $ICOMMANDS_IMG
else
    echo "The $GOMAP_LOC/$GOMAP_IMG exists" > /dev/stderr
    echo "Delete the image if you want to download it again" > /dev/stderr
fi
