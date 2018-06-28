#!/usr/bin/env bash


if [ ! -f "$HOME/.irods/irods_environment.json" ]
then
	echo "File not found"
	mkdir -p $HOME/.irods/ && cp irods_environment.json $HOME/.irods/
else
	echo "Using $HOME/.irods/irods_environment.json for icommands"
fi

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