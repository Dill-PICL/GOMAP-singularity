#!/usr/bin/env bash
instance_name="GOMAP"
img_loc="$PWD/$instance_name.simg"
mkdir -p $PWD/tmp

if [ ! -f "$img_loc" ]
then
	singularity pull --name "$img_loc" shub://Dill-PICL/GOMAP-singularity
fi

./stop-GOMAP.sh

singularity instance.start \
	--bind $PWD/GOMAP-data/mysql/lib:/var/lib/mysql \
	--bind $PWD/GOMAP-data/mysql/log:/var/log/mysql \
	--bind $PWD/GOMAP-data:/opt/GOMAP/data \
	--bind $PWD:/workdir \
	--bind $TMPDIR:/tmpdir \
	-W $PWD/tmp \
	$img_loc $instance_name && \
sleep 10 && \
singularity run instance://$instance_name --step=seqsim --config=test/config.yml && \
singularity run instance://$instance_name --step=domain --config=test/config.yml && \
singularity run instance://$instance_name --step=mixmeth-blast --config=test/config.yml && \
singularity run instance://$instance_name --step=mixmeth-preproc --config=test/config.yml && \
singularity run instance://$instance_name --step=mixmeth --config=test/config.yml && \
singularity run instance://$instance_name --step=aggregate --config=test/config.yml

./stop-GOMAP.sh
