#!/usr/bin/env bash

sudo apt-get install apt-transport-https curl
sudo mkdir -p /etc/apt/keyrings
sudo curl -o /etc/apt/keyrings/mariadb-keyring.asc 'https://mariadb.org/mariadb_release_signing_key.pgp'

# MariaDB 11.4 repository list - created 2026-06-20 17:56 UTC
# https://mariadb.org/download/
X-Repolib-Name: MariaDB
Types: deb
# deb.mariadb.org is a dynamic mirror if your preferred mirror goes offline. See https://mariadb.org/mirrorbits/ for details.
# URIs: https://deb.mariadb.org/11.4/ubuntu
URIs: https://mirror.realcompute.io/mariadb/repo/11.4/ubuntu
Suites: jammy
Components: main main/debug
Signed-By: /etc/apt/keyrings/mariadb-keyring.asc

sudo apt-get update
sudo apt-get install mariadb-server mariadb-client -y

which mariadb
