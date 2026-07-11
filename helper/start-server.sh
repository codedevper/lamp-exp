#!/usr/bin/env bash

set -euo pipefail

ARG_HOME=/home/master
ARG_USER=master

sudo pkill -f openserver >/dev/null 2>&1 || true
sudo fuser -k 8000/tcp >/dev/null 2>&1 || true

PHP_BIN=$(which php)

sudo tee /etc/supervisor/conf.d/openserver.conf >/dev/null <<EOF
[program:openserver]
process_name=%(program_name)s
user=$ARG_USER
directory=$ARG_HOME/.ops
command=php artisan serve --host=0.0.0.0 --port=8000
environment=PATH="$PHP_BIN:/usr/local/bin:/usr/bin:/bin"
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile=$ARG_HOME/.ops/storage/logs/openserver.log
stopwaitsecs=3600
EOF

sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl status