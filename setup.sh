#!/usr/bin/env bash

mkdir -p tmp

if [ -z $GOMAP_LOC ]
then
    GOMAP_LOC="$PWD"
fi

if [ -z $GOMAP_IMG_TYPE ]
then
    GOMAP_IMG_TYPE="condo"
fi

# Declaring variables for different options

export GOMAP_CYVERSE_URL="/iplant/home/shared/dillpicl/gomap/GOMAP-data.v1.2/$GOMAP_IMG_TYPE"
export CYVERSE_MYSQL="/iplant/home/shared/dillpicl/gomap/GOMAP-data.v1.2/mysql.tar.gz"
export GOMAP_IMG="GOMAP.simg"
export ICOMMANDS_IMG="icommands.simg"
export ICOMMANDS_URL="shub://wkpalan/icommands-cyverse:latest"
export SINGULARITY_BINDPATH="$GOMAP_LOC:/workdir"
export IRODS_HOST=data.iplantcollaborative.org
export IRODS_PORT=1247
export IRODS_USER_NAME=anonymous
export IRODS_ZONE_NAME=iplant

if [ ! -f "$ICOMMANDS_IMG" ]
then
    singularity pull --name $ICOMMANDS_IMG "$ICOMMANDS_URL"
fi

if [ ! -f $GOMAP_LOC/$GOMAP_IMG ]
then
    singularity exec $ICOMMANDS_IMG iget -P $GOMAP_CYVERSE_URL/$GOMAP_IMG /workdir/$GOMAP_IMG
else
    echo "The $GOMAP_LOC/$GOMAP_IMG existis" > /dev/stderr
    echo "Delete the image if you want to download it" /dev/stderr
fi

if [ ! -d $GOMAP_LOC/mysql ]
then
    singularity exec $ICOMMANDS_IMG iget -P $CYVERSE_MYSQL /workdir/mysql.tar.gz && \
    tar -xvf $GOMAP_LOC/mysql.tar.gz && rm -rf $GOMAP_LOC/mysql.tar.gz
else
    echo "The $GOMAP_LOC/mysql directory existis" > /dev/stderr
    echo "Delete the directory if you want to download it" /dev/stderr
fi
    





