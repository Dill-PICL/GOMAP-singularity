Bootstrap: shub
From: Dill-PICL/GOMAP-base

%labels
MAINTAINER Kokulapalan Wimalanathan
Version 1.0.1

%environment
    export LC_ALL=C
	export DEBIAN_FRONTEND=noninteractive
	export MYSQL_USER=pannzer
    export MYSQL_DATABASE=pannzer
    export MYSQL_ROOT_PASSWORD=mysql

%post
	echo "Running post"
	mkdir /opt/GOMAP/
	git clone --branch=v1.0.2 https://github.com/Dill-PICL/GOMAP.git /opt/GOMAP/
	mkdir /workdir 
	echo "Completed Post"

%startscript
	chmod 777 /tmp
	nohup mysqld --user=$USER > /dev/null 2>&1 < /dev/null &

%runscript
	cd /opt/GOMAP/ 
	./gomap.py "$@"
 
