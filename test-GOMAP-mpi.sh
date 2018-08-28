#!/usr/bin/env bash
instance_name="GOMAP"
img_loc="$PWD/$instance_name.simg"
mkdir -p $PWD/tmp
tmpdir=$HOME/tmpdir

if [ ! -f "$img_loc" ]
then
	singularity pull --name "$img_loc" shub://Dill-PICL/GOMAP-singularity
fi



# singularity exec  \
# 	instance://$instance_name /opt/GOMAP/gomap.py --step=seqsim --config=test/config.yml

# singularity exec  \
# 	instance://$instance_name /opt/GOMAP/gomap.py --step=domain --config=test/config.yml

# singularity exec  \
# 	instance://$instance_name /opt/GOMAP/gomap.py --step=mixmeth-blast --config=test/config.yml

mpirun -n 2 -hosts master,slave \
singularity run  \
	--bind $PWD/GOMAP-data/mysql/lib:/var/lib/mysql \
	--bind $PWD/GOMAP-data/mysql/log:/var/log/mysql \
	--bind $PWD/GOMAP:/opt/GOMAP \
	--bind $PWD/GOMAP-data:/opt/GOMAP/data \
    --bind $PWD:/workdir \
	--bind $tmpdir:/tmpdir \
	-W $PWD/tmp \
	$img_loc --step=mixmeth-blast --config=test/config.yml

./stop-GOMAP.sh
#singularity instance.start \
#	--bind $PWD/GOMAP-data/mysql/lib:/var/lib/mysql \
#	--bind $PWD/GOMAP-data/mysql/log:/var/log/mysql \
#	--bind $PWD/GOMAP:/opt/GOMAP \
#	--bind $PWD/GOMAP-data:/opt/GOMAP/data \
 # 	--bind $PWD:/workdir \
#	--bind $tmpdir:/tmpdir \
#	-W $PWD/tmp \
#	$img_loc $instance_name 

#singularity run  \
#	instance://$instance_name --step=mixmeth --config=test/config.yml
#./stop-GOMAP.sh
#singularity run  \
#	$img_loc --step=aggregate --config=test/config.yml
