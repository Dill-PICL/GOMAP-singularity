instance_name="GOMAP"
# --bind $PWD/test:/workdir \
singularity run -c instance://$instance_name $@
# sudo singularity instance.stop $instance_name
# --bind $PWD/GO-MAP-data/mysql/run:/var/run/mysqld \