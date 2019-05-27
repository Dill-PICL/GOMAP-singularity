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

export ZENODO_URL="https://sandbox.zenodo.org/record/274851/files/GOMAP.simg?download=1"
export GOMAP_IMG="GOMAP.simg"

if [ ! -f $GOMAP_LOC/$GOMAP_IMG ]
then
    wget $ZENODO_URL -O $GOMAP_LOC/$GOMAP_IMG
else
    echo "The $GOMAP_LOC/$GOMAP_IMG existis" > /dev/stderr
    echo "Delete the image if you want to download it" /dev/stderr
fi