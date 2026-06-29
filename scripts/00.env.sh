#!/usr/bin/env bash

system_check
require_root

ARG_HOME=/home/server
ARG_USER=server

if id $ARG_USER &>/dev/null; then
loginctl terminate-user $ARG_USER 2>/dev/null || true
pkill -9 -u $ARG_USER 2>/dev/null || true
sleep 2
userdel -f -r $ARG_USER
fi

sleep 2

sudo useradd -m \
-d $ARG_HOME \
-s /bin/bash \
$ARG_USER

sudo tee /etc/sudoers.d/$ARG_USER >/dev/null <<EOF
$ARG_USER ALL=(root) NOPASSWD: ALL
EOF

sudo tee $ARG_HOME/.env >/dev/null <<EOF
HOME=$ARG_HOME
USER=$ARG_USER
EOF

sudo chown -R $ARG_USER:$ARG_USER $ARG_HOME

ENV_FILE="$ARG_HOME/.env"

set -a
source "$ENV_FILE"
set +a
