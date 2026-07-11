#!/usr/bin/env bash

# Add the ondrej/php repository.
sudo apt update
sudo apt install -y software-properties-common
sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y
sudo apt update

# Install PHP.
sudo apt install -y php8.4

apt-get install -y \
    libgd3 \
    php8.4-cli \
    php8.4-dev \
    php8.4-pgsql \
    php8.4-sqlite3 \
    php8.4-gd \
    php8.4-curl \
    php8.4-mongodb \
    php8.4-imap \
    php8.4-mysql \
    php8.4-mbstring \
    php8.4-xml \
    php8.4-zip \
    php8.4-bcmath \
    php8.4-soap \
    php8.4-intl \
    php8.4-readline \
    php8.4-ldap \
    php8.4-msgpack \
    php8.4-igbinary \
    php8.4-redis \
    php8.4-swoole \
    php8.4-memcached \
    php8.4-pcov \
    php8.4-imagick \
    php8.4-xdebug

which php