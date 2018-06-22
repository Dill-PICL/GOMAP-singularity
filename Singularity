Bootstrap: localimage
From: /home/gokul/lab_data/singularity/GOMAP-base/GOMAP-base.simg

%labels
MAINTAINER Kokulapalan Wimalanathan
Version 0.2

%environment
    export LC_ALL=C
    export MYSQL_USER=pannzer
    export MYSQL_DATABASE=pannzer
    export MYSQL_ROOT_PASSWORD=mysql
	export DEBIAN_FRONTEND=noninteractive

%files
	mysqld.cnf /root/

%post
	echo "Running post.sh"
	mv /root/mysqld.cnf /etc/mysql/mysql.conf.d/
	mkdir /var/lib/mysql-files
	mkdir -p /opt/GOMAP/data
	mkdir /workdir
	echo "Completed Post"

%startscript
	chmod 777 /tmp
	nohup mysqld --user=$USER > /dev/null 2>&1 < /dev/null &

%runscript
	cd /opt/GOMAP/ 
	./gomap.py "$@"
 