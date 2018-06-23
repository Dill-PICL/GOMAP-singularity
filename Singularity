Bootstrap: localimage
From: /home/gokul/lab_data/singularity/GOMAP-base/GOMAP-base.simg

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
	mysqld.cnf
	my.cnf

%post
	echo "Running post"
	#mv mysqld.cnf /etc/mysql/mysql.conf.d/
	#mv my.cnf /etc/mysql/
	mkdir /opt/GOMAP/
	mkdir /workdir
	echo "Completed Post"

%startscript
	chmod 777 /tmp
	nohup mysqld --user=$USER > /dev/null 2>&1 < /dev/null &

%runscript
	cd /opt/GOMAP/ 
	./gomap.py "$@"
 