#
# Use this dockerfile to run apigility.
#
# Start the server using docker-compose:
#
#   docker-compose build
#   docker-compose up
#
# You can install dependencies via the container:
#
#   docker-compose run apigility composer install
#
# You can manipulate dev mode from the container:
#
#   docker-compose run apigility composer development-enable
#   docker-compose run apigility composer development-disable
#   docker-compose run apigility composer development-status
#
# OR use plain old docker 
#
#   docker build -f Dockerfile-dev -t apigility .
#   docker run -it -p "8080:80" -v $PWD:/var/www apigility
#
FROM php:7.2-apache

ENV XDEBUG_ENABLE 0
ENV XDEBUG_REMOTE_HOST host.docker.internal
ENV XDEBUG_SETTINGS_TARGET /usr/local/etc/php/conf.d/xdebug_settings.ini

RUN apt-get update \
 && apt-get install -y git zlib1g-dev \
 && docker-php-ext-install zip \
 && a2enmod rewrite \
 && sed -i 's!/var/www/html!/var/www/public!g' /etc/apache2/sites-available/000-default.conf \
 && mv /var/www/html /var/www/public \
 && curl -sS https://getcomposer.org/installer \
  | php -- --install-dir=/usr/local/bin --filename=composer \
 && echo "AllowEncodedSlashes On" >> /etc/apache2/apache2.conf

RUN docker-php-ext-install pdo pdo_mysql

RUN apt-get install -y sudo

WORKDIR /var/www

COPY docker/zf3-apigility-doctrine-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/zf3-apigility-doctrine-entrypoint.sh

ENTRYPOINT ["zf3-apigility-doctrine-entrypoint.sh"]
CMD ["apache2-foreground"]