#!/bin/bash
#####################################
# Author: jasonwu                   #
# Date: 2021.01.08                  #
# Version: 1.0                      #
# Description: install zabbix server#
#####################################

set -x

# Determine if the zabbix  is already installed
sudo dpkg -l zabbix 

if [ `echo $?` == '1' ];then
    echo "zabbix is not installed!"
    continue
else 
    echo "zabbix is already installed!"
    exit 1
fi

# Addding zabbix repository
## For Ubuntu 20.04, run the following commands:
sudo wget https://repo.zabbix.com/zabbix/4.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.0-3+focal_all.deb

sudo dpkg -i zabbix-release_4.0-3+focal_all.deb

sudo apt update


# Zabbix server/proxy/frontend installation
## To install Zabbix server with MySQL support
sudo apt install -y zabbix-server-mysql

## To install Zabbix proxy with MySQL support
## apt install -y zabbix-proxy-mysql  // TODO

## To install Zabbix frontend
sudo apt install -y zabbix-frontend-php

## To install MySQL server
sudo apt install -y mariadb-server

## To start MySQL server process
sudo systemctl start mariadb.service && systemctl enable mariadb.service


# Creating database
## To set the mysql password
mysqladmin password OverpowerHk123

## To create database
mysql -uroot -pOverpowerHk123 -e "create database zabbix character set utf8 collate utf8_bin;"

## To create zabbix user
mysql -uroot -pOverpowerHk123 -e "create user 'zabbix'@'localhost' identified by 'OverpowerHk123';"

## To grant privileges zabbix user
mysql -uroot -pOverpowerHk123 -e "grant all privileges on zabbix.* to 'zabbix'@'localhost';"

## To flush privileges;
mysql -uroot -pOverpowerHk123 -e "flush privileges;"


# Importing data
## Now import initial schema and data for the server with MySQL
sudo zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | mysql -uzabbix -pOverpowerHk123 zabbix


# Configure database for zabbix server
## Edit zabbix_server.conf
sudo sed -i 's/# DBHost=localhost/DBHost=localhost/g' /etc/zabbix/zabbix_server.conf

# sudo sed -i 's/DBName=/DBName=zabbix/g' /etc/zabbix/zabbix_server.conf(default)

# sudo sed -i 's/DBUser=/DBUser=zabbix/g' /etc/zabbix/zabbix_server.conf(default)

sudo sed -i 's/# DBPassword=/DBPassword=OverpowerHk123/g' /etc/zabbix/zabbix_server.conf


# Starting zabbix server process
## To start zabbix server process and make it starts at system boot
sudo systemctl start zabbix-server.service && sudo systemctl enable zabbix-server.service

# Configure apache http server time zone
## Edit /etc/apache2/conf-enabled/zabbix.conf
sudo sed -i 's#\# php_value date.timezone Europe/Riga#php_value date.timezone Asia/Hong_Kong#g' /etc/apache2/conf-enabled/zabbix.conf

## Restart apache2 http server
sudo systemctl restart apache2.service