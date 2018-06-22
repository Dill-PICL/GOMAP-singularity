#!/bin/bash

# apt-get -q -y update
# apt-get -q -y install debconf-utils


# apt-get -yq install less vim wget python-pip libfuse2 r-base openjdk-8-jdk
# # R -e 'install.packages(c("data.table","futile.logger","ggplot2","ontologyIndex","reshape2","scales","jsonlite","yaml"))'
# sed -i 's/make/make -j4/g' /usr/lib/R/etc/Renviron
# R -e 'install.packages(c("data.table","futile.logger","ontologyIndex","scales","yaml"))'

# pip install -r /root/requirements.txt

# bash -c 'debconf-set-selections <<< "mysql-server mysql-server/root_password password mysql"'
# bash -c 'debconf-set-selections <<< "mysql-server mysql-server/root_password_again password mysql"'
# apt-get -y install mysql-server

# wget ftp://ftp.renci.org/pub/irods/releases/4.1.9/ubuntu14/irods-icommands-4.1.9-ubuntu14-x86_64.deb
# dpkg -i irods-icommands-4.1.9-ubuntu14-x86_64.deb


# mkdir /var/run/mysqld
# # chown -R mysql:mysql /var/run/mysqld
# chmod 777 /var/run/mysqld
# ls -lh /var/run/mysqld

mkdir /var/lib/mysql
# chown -R mysql:mysql /var/lib/mysql
chmod 777 /var/lib/mysql

mkdir -p /opt/GO-MAP/data
mkdir /workdir

echo "Completed Post"
