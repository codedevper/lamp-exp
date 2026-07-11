#!/usr/bin/env bash

sudo dpkg -P mysql

sudo dpkg -i mysql-apt-config_0.8.39-1_all.deb

sudo dpkg-reconfigure mysql-apt-config

sudo apt-get update

sudo apt-get install mysql-server mysql-client -y

which mysql
