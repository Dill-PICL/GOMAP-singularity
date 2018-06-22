Bootstrap: shub
From: wkpalan/GOMAP-base

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
	post.sh /root/
	requirements.txt /root/
	mysqld.cnf /root/

%post
	echo "Running post.sh"
	ls /root/
	/root/post.sh

%startscript
	chmod 777 /tmp
	nohup mysqld --user=$USER > /dev/null 2>&1 < /dev/null &

%runscript
	cd /opt/GO-MAP/ 
	./gomap.py "$@"
 