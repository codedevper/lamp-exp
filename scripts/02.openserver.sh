#!/usr/bin/env bash

sudo -u $USER -H bash <<EOF
cd $HOME

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }"
php composer-setup.php
php -r "unlink('composer-setup.php');"

sudo mv composer.phar /usr/local/bin/composer

which composer

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
sudo chown -R $USER:$USER $HOME
sudo chmod -R 775 $HOME/.openserver
sudo chmod -R 775 $HOME/.openserver/storage
sudo chmod -R 775 $HOME/.openserver/bootstrap/cache
