instance_name="mysql"
instance_name="GO_MAP_test"
instance_running=`sudo singularity instance.list | grep $instance_name`
if [ -n "$instance_running" ]
then
	sudo singularity instance.stop $instance_name
fi
sudo singularity instance.start \
 	-w -c \
	--bind GO-MAP-data/mysql/lib:/var/lib/mysql \
	--bind GO-MAP-data/mysql/run:/var/run/mysqld \
	--bind GO-MAP-container /opt/GO-MAP \
	--bind GO-MAP-data /opt/GO-MAP/data \
	 $instance_name $instance_name && \
sudo singularity shell -c -w instance://$instance_name

#	--bind GO-MAP-data/mysql/log:/var/log/mysql \
