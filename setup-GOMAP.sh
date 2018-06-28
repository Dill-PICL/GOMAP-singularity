#!/usr/bin/env bash

instance_name="GOMAP"
img_loc="$instance_name.simg"
mkdir -p $PWD/tmp $PWD/GOMAP-data

singularity instance.start \
	--bind $PWD/GOMAP-container:/opt/GOMAP \
	--bind $PWD/GOMAP-data:/opt/GOMAP/data \
    --bind $PWD:/workdir \
	-W $PWD/tmp \
	$img_loc $instance_name &&
singularity run  \
		instance://$instance_name --step=setup --config=test/config.yml

instance_running=`singularity instance.list | grep $instance_name`
if [ -n "$instance_running" ]
then
	singularity instance.stop $instance_name
fi