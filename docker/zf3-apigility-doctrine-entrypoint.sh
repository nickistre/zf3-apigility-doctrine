#!/usr/bin/env bash

# Install and configure xdebug here, based on environment

if (( $XDEBUG_ENABLE != 0 )); then
    echo "Install and configure xdebug"

    pecl install xdebug
    printf "xdebug.default_enable = 1\n\
xdebug.collect_params = 4\n\
xdebug.collect_vars = 0\n\
\n\
xdebug.remote_host = ${XDEBUG_REMOTE_HOST}\n\
xdebug.remote_enable = 1\n\
xdebug.remote_port = 9000\n" | tee "$XDEBUG_SETTINGS_TARGET"

    docker-php-ext-enable xdebug
else
    echo "Disable xdebug (if installed)"
    printf "xdebug.default_enable = 0\n" | tee "$XDEBUG_SETTINGS_TARGET"
fi

# Install required libraries
composer install

# Setup data folder
find data/ -type d -exec chmod 777 {} \;
find data/ -type f -exec chmod 666 {} \;

# Setup module for apigility development

find module/ -type d -exec chmod 777 {} \;
find module/ -type f -exec chmod 666 {} \;

docker-php-entrypoint "$1"


