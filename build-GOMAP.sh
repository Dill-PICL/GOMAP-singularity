instance_name="GOMAP"
if [ -f "$instance_name.simg" ]
then
    sudo rm -r "$instance_name.simg"
fi

sudo singularity build -i $instance_name.simg singularity/Singularity.stampede2