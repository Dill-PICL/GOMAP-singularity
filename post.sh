#!/bin/bash

apt-get -q -y update
apt-get -q -y install debconf-utils
bash -c 'debconf-set-selections <<< "mysql-server mysql-server/root_password password mysql"'
bash -c 'debconf-set-selections <<< "mysql-server mysql-server/root_password_again password mysql"'
apt-get -y install mysql-server

apt-get -yq install wget git python-pip
chmod 777 /tmp

mkdir /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
chmod 700 /var/run/mysqld
ls -lh /var/run/mysqld

chown -R mysql:mysql /var/lib/mysql
chmod 700 /var/lib/mysql

mkdir /misc
mkdir /opt/GO-MAP

echo "Completed Post"
