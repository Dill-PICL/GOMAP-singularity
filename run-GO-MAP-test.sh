instance_name="GO_MAP_test"
	# sudo singularity instance.start \
 	# -c -w \
	# --bind $PWD/GO-MAP-data/mysql/lib:/var/lib/mysql \
	# --bind $PWD/GO-MAP-data/mysql/run:/var/run/mysqld \
	# --bind $PWD/GO-MAP-container:/opt/GO-MAP \
	# --bind $PWD/GO-MAP-data:/opt/GO-MAP/data \
	# --bind /tmp:/tmp \
	# --bind $PWD/test:/workdir \
	#  $instance_name $instance_name && \
sudo singularity run -c -w instance://$instance_name $@


#	--bind GO-MAP-data/mysql/log:/var/log/mysql \
