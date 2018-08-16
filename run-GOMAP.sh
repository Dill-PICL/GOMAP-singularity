#!/usr/bin/env bash

instance_name="GOMAP"
gomap_loc="$PWD"
img_loc="$gomap_loc/$instance_name.simg"

mkdir -p $PWD/tmp

./stop-GOMAP.sh
singularity instance.start \
	--bind $gomap_loc/GOMAP-data/mysql/lib:/var/lib/mysql \
	--bind $gomap_loc/GOMAP-data/mysql/log:/var/log/mysql \
	--bind $gomap_loc/GOMAP-data:/opt/GOMAP/data \
	--bind $HOME/tmpdir:/tmpdir \
    --bind $PWD:/workdir \
	-W $PWD/tmp \
	$img_loc $instance_name && \
singularity run  \
            instance://$instance_name $@
./stop-GOMAP.sh