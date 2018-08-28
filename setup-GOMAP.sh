#!/usr/bin/env bash

instance_name="GOMAP"
img_loc="$instance_name.simg"

if [ ! -f "$img_loc" ]
then
	singularity pull --name "$img_loc" shub://Dill-PICL/GOMAP-singularity
fi


if [ ! -f "$HOME/.irods/irods_environment.json" ]
then
	echo "irods environment file not found"
	mkdir -p $HOME/.irods/ && cp irods_environment.json $HOME/.irods/
else
	echo "Using $HOME/.irods/irods_environment.json for icommands"
fi

mkdir -p $PWD/tmp $PWD/GOMAP-data

singularity instance.start \
	--bind $PWD/GOMAP-data:/opt/GOMAP/data \
    --bind $PWD:/workdir \
	-W $PWD/tmp \
	$img_loc $instance_name &&
singularity run  \
		instance://$instance_name --step=setup --config=test/config.yml

./stop-GOMAP.sh