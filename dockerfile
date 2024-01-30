FROM php:8.1.2-apache

RUN a2enmod rewrite

RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libicu-dev \
    libxml2-dev \
    libpq-dev \
    libzip-dev


RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install zip
RUN docker-php-ext-install intl
# RUN docker-php-ext-install xmlrpc
RUN docker-php-ext-install soap
RUN docker-php-ext-install opcache

RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd


RUN apt-get update -y 

# Add Node 8 LTS
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs
RUN apt-get autoremove -y

COPY --from=composer /usr/bin/composer /usr/bin/composer

COPY  docker/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY  docker/.env /var/www/html/.env
COPY  docker/php.ini /usr/local/etc/php/php.ini

ENV COMPOSER_ALLOW_SUPERUSER 1

COPY  . /var/www/html/
WORKDIR /var/www/html/

RUN chown -R www-data:www-data /var/www/html  \
    && composer install  && composer dumpautoload 