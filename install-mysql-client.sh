#!/bin/bash

MYSQL_APT_CONFIG="mysql-apt-config_0.8.29-1_all.deb"

apt-key adv --keyserver pgp.mit.edu --recv-keys B7B3B788A8D3785C && echo "deb http://repo.mysql.com/apt/debian/ buster mysql-8.0" > /etc/apt/sources.list.d/mysql.list
