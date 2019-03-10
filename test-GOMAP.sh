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
    tmpdir="$PWD/temp"
fi



export MATLAB_LOC=${MATLAB_LOC:-/shared/hpc/matlab/R2017a}
export mysql_bind="$PWD/GOMAP-data/mysql/lib:/var/lib/mysql,$tmpdir:/run/mysqld"
export SINGULARITY_BINDPATH="$PWD/GOMAP:/opt/GOMAP,$PWD/GOMAP-data:/opt/GOMAP/data,$PWD:/workdir,$tmpdir:/tmpdir,$mysql_bind"

echo "$SINGULARITY_BINDPATH"

./stop-GOMAP.sh

echo "$@"

if [[ $# -eq 1 ]] 
then
	singularity instance.start \
		-W $PWD/tmp \
		$img_loc $instance_name && \
		singularity run instance://$instance_name --step=$1 --config=test/config.yml
else
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
fi
#./stop-GOMAP.sh
