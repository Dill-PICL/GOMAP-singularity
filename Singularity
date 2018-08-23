Bootstrap: shub
From: Dill-PICL/GOMAP-base

%labels
MAINTAINER Kokulapalan Wimalanathan
Version 1.0.1

%files

%environment
    export LC_ALL=C
	export DEBIAN_FRONTEND=noninteractive
	export MYSQL_USER=pannzer
    export MYSQL_DATABASE=pannzer
    export MYSQL_ROOT_PASSWORD=mysql

%post
	echo "Running post"
	pip install mpi4py 
	mkdir /opt/GOMAP/ 
	git clone --branch=hpc-dev https://github.com/Dill-PICL/GOMAP.git /opt/GOMAP/
	mkdir /workdir 
	mkdir /tmpdir
	echo "Completed Post"

%startscript
	chmod 777 /tmp
	nohup mysqld --user=$USER > /dev/null 2>&1 < /dev/null &

%runscript
	cd /opt/GOMAP/ 
	./gomap.py "$@"