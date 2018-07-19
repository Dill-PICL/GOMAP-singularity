#!/usr/bin/env bash

instance_name="GOMAP"
instance_running=`singularity instance.list | grep $instance_name`
if [ -n "$instance_running" ]
then
	singularity shell -c instance://$instance_name
fi