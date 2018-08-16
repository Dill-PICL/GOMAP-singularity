#!/usr/bin/env bash
instance_name="GOMAP"
img_loc="$instance_name.simg"
mkdir -p $PWD/tmp
tmpdir=$HOME/tmpdir

if [ ! -f "$img_loc" ]
then
	singularity pull --name "$img_loc" shub://Dill-PICL/GOMAP-singularity
fi

./stop-GOMAP.sh
singularity instance.start \
	--bind $PWD/GOMAP-data/mysql/lib:/var/lib/mysql \
	--bind $PWD/GOMAP-data/mysql/log:/var/log/mysql \
	--bind $PWD/GOMAP:/opt/GOMAP \
	--bind $PWD/GOMAP-data:/opt/GOMAP/data \
  --bind $PWD:/workdir \
	--bind $tmpdir:/tmpdir \
	-W $PWD/tmp \
	$img_loc $instance_name 

# singularity exec  \
# 	instance://$instance_name /opt/GOMAP/gomap.py --step=seqsim --config=test/config.yml

# singularity exec  \
# 	instance://$instance_name /opt/GOMAP/gomap.py --step=domain --config=test/config.yml

mpirun -np 2 --slot-list 0:0-3 --hostfile hostfile \
singularity exec  \
	--bind $PWD/GOMAP-data/mysql/lib:/var/lib/mysql \
	--bind $PWD/GOMAP-data/mysql/log:/var/log/mysql \
	--bind $PWD/GOMAP:/opt/GOMAP \
	--bind $PWD/GOMAP-data:/opt/GOMAP/data \
    --bind $PWD:/workdir \
	--bind $tmpdir:/tmpdir \
	-W $PWD/tmp \
	$img_loc /opt/GOMAP/gomap.py --step=mixmeth-preproc --config=test/config.yml

#singularity run  \
#	$img_loc --step=mixmeth --config=test/config.yml
#singularity run  \
#	$img_loc --step=aggregate --config=test/config.yml
./stop-GOMAP.sh