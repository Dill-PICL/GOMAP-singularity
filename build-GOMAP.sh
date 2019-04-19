instance_name="GOMAP"
if [ -f "$instance_name.simg" ]
then
    sudo rm -r "$instance_name.simg"
fi

sudo singularity build $instance_name.simg singularity/Singularity.v1.2 && \
sudo chown gokul:gokul $instance_name.simg