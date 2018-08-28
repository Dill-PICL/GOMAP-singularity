Bootstrap: shub
From: Dill-PICL/GOMAP-base

%labels
MAINTAINER Kokulapalan Wimalanathan
Version 1.1.0

%files

%environment
    export LC_ALL=C
	export DEBIAN_FRONTEND=noninteractive
	export MYSQL_USER=pannzer
    export MYSQL_DATABASE=pannzer
    export MYSQL_ROOT_PASSWORD=mysql 

%post
	echo "Running post"

    #Installing mpich
    wget http://www.mpich.org/static/downloads/3.2/mpich-3.2.tar.gz && \
    tar -xf  mpich-3.2.tar.gz && \
    cd mpich-3.2 &&  \
    ./configure && make -j4 && make install && \
    cd .. 

    
	pip install mpi4py==3.0.0 

	mkdir /opt/GOMAP/
	git clone --branch=hpc-dev https://github.com/Dill-PICL/GOMAP.git /opt/GOMAP/
	mkdir -p /workdir
	mkdir -p /tmpdir
	mkdir -p /var/log/mysql
	echo "Completed Post"

%startscript
	chmod 777 /tmp
	nohup mysqld --user=$USER > /dev/null 2>&1 < /dev/null &

%runscript
	cd /opt/GOMAP/ 
	./gomap.py "$@"