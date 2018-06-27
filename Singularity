Bootstrap: shub
From: wkpalan/GOMAP-base

%labels
MAINTAINER Kokulapalan Wimalanathan
Version 0.2

%environment
    export LC_ALL=C
	export DEBIAN_FRONTEND=noninteractive
	export MYSQL_USER=pannzer
    export MYSQL_DATABASE=pannzer
    export MYSQL_ROOT_PASSWORD=mysql

%files
	irods_environment.json
	.passwd

%post
	echo "Running post"
	mkdir /opt/GOMAP/
	mkdir /workdir
	mv irods_environment.json /root/.irods/
	cat .passwd | iinit
	ils
	echo "Completed Post"

%startscript
	chmod 777 /tmp
	nohup mysqld --user=$USER > /dev/null 2>&1 < /dev/null &

%runscript
	cd /opt/GOMAP/ 
	./gomap.py "$@"
 