instance_name="mysql"
instance_name="GO_MAP_test"
instance_running=`sudo singularity instance.list | grep $instance_name`
if [ -n "$instance_running" ]
then
	echo sudo singularity instance.stop $instance_name
	sudo singularity shell -c -w instance://$instance_name
else
	sudo singularity instance.start \
 	-c -w \
	--bind $PWD/GO-MAP-data/mysql/lib:/var/lib/mysql \
	--bind $PWD/GO-MAP-data/mysql/run:/var/run/mysqld \
	--bind $PWD/GO-MAP-container:/opt/GO-MAP \
	--bind $PWD/GO-MAP-data:/opt/GO-MAP/data \
	--bind /tmp:/tmp \
	--bind $PWD/test:/workdir \
	 $instance_name $instance_name && \
	 sudo singularity shell -c -w instance://$instance_name
fi


#	--bind GO-MAP-data/mysql/log:/var/log/mysql \
