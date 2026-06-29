#!/usr/bin/env bash

source "$BASH_DIR/scripts/lib/apache2.sh"

source "$BASH_DIR/scripts/lib/php.sh"

sudo a2enmod rewrite proxy_fcgi
sudo systemctl restart apache2

source "$BASH_DIR/scripts/lib/nodejs.sh"

source "$BASH_DIR/scripts/lib/docker.sh"

sudo usermod -aG docker $USER

sudo mkdir -p $HOME/.docker
sudo chown $USER:$USER $HOME/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R