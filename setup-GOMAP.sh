instance_name="GOMAP"
img_loc="/mnt/raid/lab_data/go_annotation/GOMAP-singularity/$instance_name.simg"
mkdir -p $PWD/tmp

singularity instance.start \
	--bind $PWD/GOMAP-container:/opt/GOMAP \
	--bind $PWD/GOMAP-data:/opt/GOMAP/data \
    --bind $PWD:/workdir \
	-W $PWD/tmp \
	$img_loc $instance_name &&
singularity run  \
		instance://$instance_name --step=setup --config=test/config.yml
./stop-GOMAP.sh