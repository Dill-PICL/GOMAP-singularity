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
export GOMAP_VERSION="v1.3.4"
export GOMAP_URL="/iplant/home/shared/dillpicl/gomap/GOMAP/$GOMAP_VERSION/$GOMAP_IMG"


if [ ! -f $GOMAP_LOC/$GOMAP_IMG ]
then
    # Making the irods directory and copying files if they don't exist    
    if [ ! -f "~/.irods/irods_environmnt.json" ]
    then
        mkdir -p ~/.irods &&
        cp irods_environment.json ~/.irods/
    fi
    #Downloading icommands image if it doesn't exist.
    if [ ! -f $ICOMMANDS_IMG ]
    then
        singularity pull -F $ICOMMANDS_IMG shub://wkpalan/icommands-cyverse:latest
    fi
    #Downloading GOMAP Image
    singularity run $ICOMMANDS_IMG iget -PvT $GOMAP_URL $GOMAP_LOC/$GOMAP_IMG && \
    rm $ICOMMANDS_IMG
else
    echo "The $GOMAP_LOC/$GOMAP_IMG exists" > /dev/stderr
    echo "Delete the image if you want to download it again" > /dev/stderr
fi
