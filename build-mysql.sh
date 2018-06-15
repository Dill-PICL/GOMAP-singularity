instance_name="mysql"
instance_running=`sudo singularity instance.list | grep $instance_name`
if [ -n "$instance_running" ]
then
	sudo singularity instance.stop $instance_name
fi
sudo rm -rf $instance_name
sudo rm -rf tmp/*
sudo singularity build --sandbox $instance_name $instance_name.txt
