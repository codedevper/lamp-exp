#!/usr/bin/env bash

set -euo pipefail

ARG_HOME=/home/server
ARG_USER=server

sudo rm -rf /etc/supervisor/conf.d/openserver.conf

sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl status

sudo pkill -f openserver >/dev/null 2>&1 || true
sudo fuser -k 8000/tcp >/dev/null 2>&1 || true