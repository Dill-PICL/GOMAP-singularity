#!/usr/bin/env bash

mkdir -p tmp

if [ -z $GOMAP_LOC ]
then
    GOMAP_LOC="$PWD"
fi

GOMAP_IMG="$GOMAP_LOC/GOMAP.simg"
MYSQL_IMG="mysql-data.img"
GOMAP_DATA_LOC="$GOMAP_LOC/GOMAP/data"

GOMAP_URL="shub://Dill-PICL/GOMAP-singularity:v1.2"

if [ ! -f "$GOMAP_IMG" ]
then
    singularity pull --name `basename $GOMAP_IMG` "$GOMAP_URL"
    mv  `basename $GOMAP_IMG` `dirname $GOMAP_IMG`
fi

args="$@"
mixmeth=`echo $@ | grep mixmeth | grep -v mixmeth-blast | grep -v mixmeth-preproc`
mixmeth_blast=`echo $@ | grep mixmeth-blast`
setup=`echo $@ | grep setup`

if [ -z $tmpdir ]
then
    tmpdir=${TMPDIR:-$PWD/tmp}
fi

if [ ! -f $GOMAP_LOC/$MYSQL_IMG ]
then
    echo "Creating the overlay image for running mysql"
    export SINGULARITY_BINDPATH="$GOMAP_LOC:/workdir"
    singularity exec iget -fP \
        /iplant/home/shared/dillpicl/gomap/GOMAP-data.v1.2/$MYSQL_IMG.gz \
        /workdir/$MYSQL_IMG.gz && \
        gunzip $GOMAP_LOC/$MYSQL_IMG.gz
    #singularity image.create -s 13000 $MYSQL_IMG
fi

if [ ! -z "$mixmeth" ]
then
    export SINGULARITY_BINDPATH="$PWD:/workdir,$tmpdir:/tmpdir,tmp:/run/mysqld"
    echo "Starting GOMAP instance"
    $GOMAP_LOC/stop-GOMAP.sh && \
    singularity instance.start -c  \
        -o $MYSQL_IMG \
        $GOMAP_IMG GOMAP && \
	sleep 1 && \
    singularity run  \
        instance://GOMAP $@ #&& \
    #$GOMAP_LOC/stop-GOMAP.sh
#elif [ ! -z "$setup" ]
#then
#    mkdir -p $GOMAP_LOC/GOMAP/datals /va
#    export SINGULARITY_BINDPATH="$SINGULARITY_BINDPATH,$PWD:/workdir,$tmpdir:/tmpdir"
#    echo "Running GOMAP $@"
#    mkdir -p $GOMAP_DATA_LOC
#    singularity run \
#        $GOMAP_IMG $@
else
    export SINGULARITY_BINDPATH="$SINGULARITY_BINDPATH,$PWD:/workdir,$tmpdir:/tmpdir"   
    echo "$SINGULARITY_BINDPATH"
    echo "Running GOMAP $@"
    singularity run -c \
        -o $MYSQL_IMG \
        $GOMAP_IMG $@
fi
