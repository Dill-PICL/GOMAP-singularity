#!/usr/bin/env bash
instance_name="GOMAP"
img_loc="/mnt/raid/lab_data/go_annotation/GOMAP-singularity/$instance_name.simg"
mkdir -p $PWD/tmp

singularity instance.start \
	--bind $PWD/GOMAP-data/mysql/lib:/var/lib/mysql \
	--bind $PWD/GOMAP-data/mysql/log:/var/log/mysql \
	--bind $PWD/GOMAP-container:/opt/GOMAP \
	--bind $PWD/GOMAP-data:/opt/GOMAP/data \
    --bind $PWD:/workdir \
	-W $PWD/tmp \
	$img_loc $instance_name
	
#&& \


# --bind $PWD/test:/workdir \
# singularity run -c instance://$instance_name $@
# sudo singularity instance.stop $instance_name