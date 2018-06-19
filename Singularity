Bootstrap: docker
From: ubuntu:bionic

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

%post
	echo "Running post.sh"
	ls /root/
	/root/post.sh

%startscript
	echo 'show databases;'
	chmod 777 /tmp
	nohup mysqld -P 9999 > /dev/null 2>&1 < /dev/null &

%runscript
	/opt/GO-MAP/run_gomap.py
