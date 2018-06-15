instance_name="GO_MAP_test"
instance_running=`sudo singularity instance.list | grep $instance_name`
if [ -n "$instance_running" ]
then
	sudo singularity instance.stop $instance_name
fi
sudo singularity instance.start -w -c --bind mysql:/var/lib/mysql --bind tmp:/misc GO-MAP-test $instance_name && \
sudo singularity shell -c -w instance://$instance_name
