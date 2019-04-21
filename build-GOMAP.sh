export SINGULARITY_CACHEDIR="/media/data/tmp/"
export SINGULARITY_TMPDIR="/media/data/tmp/"
export SINGULARITY_LOCALCACHEDIR="/media/data/tmp/"

instance_name="GOMAP"
if [ -f "$instance_name.simg" ]
then
    sudo rm -r "$instance_name.simg"
fi

if [ ! -d $instance_name-dir.simg ]
then
    sudo singularity -v build -s $instance_name-dir.simg singularity/Singularity.v1.2
fi

time sudo singularity -v build $instance_name.simg $instance_name-dir.simg && \
sudo chown gokul:gokul $instance_name.simg