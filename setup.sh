#!/usr/bin/env bash

mkdir -p tmp

if [ -z $GOMAP_LOC ]
then
    GOMAP_LOC="$PWD"
fi

if [ -z $GOMAP_IMG_TYPE ]
then
    GOMAP_IMG_TYPE="mpich-3.2.1"
fi

# Declaring variables for different options

export IMG_URL="https://gomap-data.s3.us-east-2.amazonaws.com/GOMAP-1.3.1/imgs/GOMAP.sif"
export GOMAP_IMG="GOMAP.sif"

if [ ! -f $GOMAP_LOC/$GOMAP_IMG ]
then
    wget $IMG_URL -O $GOMAP_LOC/$GOMAP_IMG
else
    echo "The $GOMAP_LOC/$GOMAP_IMG exists" > /dev/stderr
    echo "Delete the image if you want to download it" /dev/stderr
fi