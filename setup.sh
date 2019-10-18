#!/usr/bin/env bash

mkdir -p tmp

if [ -z $GOMAP_LOC ]
then
    GOMAP_LOC="$PWD"
fi

# Declaring variables for different options

export IMG_URL="https://gomap.blob.core.windows.net/gomap/GOMAP/1.3.1/GOMAP.sif"
export GOMAP_IMG="GOMAP.sif"

if [ ! -f $GOMAP_LOC/$GOMAP_IMG ]
then
    wget $IMG_URL -O $GOMAP_LOC/$GOMAP_IMG
else
    echo "The $GOMAP_LOC/$GOMAP_IMG exists" > /dev/stderr
    echo "Delete the image if you want to download it" /dev/stderr
fi