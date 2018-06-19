#!/bin/bash

apt-get -q -y update
apt-get -q -y install debconf-utils
bash -c 'debconf-set-selections <<< "mysql-server mysql-server/root_password password mysql"'
bash -c 'debconf-set-selections <<< "mysql-server mysql-server/root_password_again password mysql"'
apt-get -y install mysql-server libmysqlclient-dev

apt-get -yq install wget python-pip libfuse2 r-base openjdk-8-jdk
R -e 'install.packages(c("data.table","futile.logger","ggplot2","ontologyIndex","reshape2","scales","jsonlite","yaml"))'

# wget ftp://ftp.renci.org/pub/irods/releases/4.1.9/ubuntu14/irods-icommands-4.1.9-ubuntu14-x86_64.deb
# dpkg -i irods-icommands-4.1.9-ubuntu14-x86_64.deb
# chmod 777 /tmp

mkdir /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
chmod 700 /var/run/mysqld
ls -lh /var/run/mysqld

chown -R mysql:mysql /var/lib/mysql
chmod 700 /var/lib/mysql

mkdir /misc
mkdir -p /opt/GO-MAP/data
mkdir /workdir

echo "Completed Post"
