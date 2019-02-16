#!/usr/bin/env bash

instance_name="GOMAP"
img_loc="$PWD/$instance_name.simg"
mkdir -p $PWD/tmp


if [ ! -f "$img_loc" ]
then
	singularity pull --name "$img_loc" shub://Dill-PICL/GOMAP-singularity
fi

if [ -z $tmpdir ]
then
    tmpdir=${TMPDIR:-/tmp}
fi

MATLAB_LOC=${MATLAB_LOC:-/shared/hpc/matlab/R2017a}

export SINGULARITY_BINDPATH="$PWD/GOMAP-data:/opt/GOMAP/data,$PWD/GOMAP-data/mysql/lib:/var/lib/mysql,$PWD/GOMAP-data/mysql/log:/var/log/mysql,$PWD:/workdir,$tmpdir:/tmpdir,$MATLAB_LOC:/matlab"

./stop-GOMAP.sh

singularity instance.start \
	-W $PWD/tmp \
	$img_loc $instance_name && \
	singularity run instance://$instance_name --step=seqsim --config=test/config.yml && \
	singularity run instance://$instance_name --step=domain --config=test/config.yml && \
	singularity run instance://$instance_name --step=fanngo --config=test/config.yml && \
	singularity run instance://$instance_name --step=mixmeth-blast --config=test/config.yml && \
	singularity run instance://$instance_name --step=mixmeth-preproc --config=test/config.yml && \
	singularity run instance://$instance_name --step=mixmeth --config=test/config.yml && \
	singularity run instance://$instance_name --step=aggregate --config=test/config.yml

./stop-GOMAP.sh
