#!/usr/bin/env bash

sudo -u $USER -H bash <<EOF
git clone https://github.com/codedevper/laravel-exp.git "$HOME/.openserver"

cd $HOME/.openserver

git fetch origin
git checkout 12.openserver-live

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

composer setup
EOF

# Permissions
sudo chown -R $USER:$USER $HOME/.openserver
sudo chmod -R 775 $HOME/.openserver/storage
sudo chmod -R 775 $HOME/.openserver/bootstrap/cache

sudo tee "/etc/supervisor/conf.d/openserver.conf" >/dev/null <<EOF
[program:openserver]
process_name=%(program_name)s
user=$USER
directory=$HOME/.openserver
command=/usr/bin/php artisan serve --host=0.0.0.0 --port=8000
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile=$HOME/.openserver/storage/logs/openserver.log
stopwaitsecs=3600
EOF

sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl status
