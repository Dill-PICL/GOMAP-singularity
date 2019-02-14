#!/usr/bin/env bash
instance_name="GOMAP"
instance_running=`singularity instance.list | grep $instance_name`
if [ -n "$instance_running" ]
then
	singularity instance.stop $instance_name && sleep 20

else
	echo "There are no instances named $instance_name running."
fi
