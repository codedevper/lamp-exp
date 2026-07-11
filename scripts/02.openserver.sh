#!/usr/bin/env bash

sudo chown -R $USER:$USER $HOME

sudo -u $USER -H bash <<EOF
cd ~

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }"
php composer-setup.php
php -r "unlink('composer-setup.php');"

sudo mv composer.phar /usr/local/bin/composer

which composer

git clone https://github.com/codedevper/laravel-exp.git "$HOME/.ops"

cd $HOME/.ops

git fetch origin
git checkout 12.openserver-test

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

composer setup

npm i -g opencode-ai
npm install -g firebase-tools
npm i -g cloudflared

cd ~

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

wp --info
EOF

# Permissions
sudo chown -R $USER:$USER $HOME/.ops
sudo chmod -R 775 $HOME/.ops/storage
sudo chmod -R 775 $HOME/.ops/bootstrap/cache

sudo tee "/etc/supervisor/conf.d/openserver.conf" >/dev/null <<EOF
[program:openserver]
process_name=%(program_name)s
user=$USER
directory=$HOME/.ops
command=/usr/bin/php artisan serve --host=0.0.0.0 --port=8000
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile=$HOME/.ops/storage/logs/openserver.log
stopwaitsecs=3600
EOF

sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl status
