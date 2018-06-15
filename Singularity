Bootstrap: docker
From: ubuntu:bionic

%labels
MAINTAINER Kokulapalan Wimalanathan
Version v0.2

%environment
    export LC_ALL=en_US.UTF-8
		    export MYSQL_USER=pannzer
		    export MYSQL_DATABASE=pannzer
			export DEBIAN_FRONTEND=noninteractive

%post
	apt-get -yq update && apt-get -yq upgrade && apt-get -yq install mysql-server

	mkdir /var/run/mysqld
	chown -R mysql:mysql /var/run/mysqld

	chown -R mysql:mysql /var/lib/mysql
	chmod 700 /var/lib/mysql

	mkdir /misc
    mkdir /opt/GO-MAP

%startscript
	chmod 777 /tmp
	nohup mysqld > /dev/null 2>&1 < /dev/null &
