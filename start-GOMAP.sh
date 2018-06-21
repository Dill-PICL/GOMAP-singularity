instance_name="GOMAP"

singularity instance.start \
	--bind $PWD/GO-MAP-data/mysql/lib:/var/lib/mysql \
	--bind $PWD/GO-MAP-data/mysql/log:/var/log/mysql \
	--bind $PWD/GO-MAP-container:/opt/GO-MAP \
	--bind $PWD/GO-MAP-data:/opt/GO-MAP/data \
	--bind $PWD/test:/workdir \
	-W $PWD/tmp \
	-c $instance_name $instance_name 
	
#&& \


# --bind $PWD/test:/workdir \
# singularity run -c instance://$instance_name $@
# sudo singularity instance.stop $instance_name