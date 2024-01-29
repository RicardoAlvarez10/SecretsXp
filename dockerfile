# Usa una imagen base de PHP con Apache
FROM php:8.1.2-apache

# Instala las dependencias necesarias
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    && docker-php-ext-install zip

# Habilita el módulo de Apache necesario para Laravel
RUN a2enmod rewrite

# Copia los archivos de la aplicación al contenedor
COPY . /var/www/html/

# Establece los permisos adecuados
RUN chown -R www-data:www-data /var/www/html/storage

# Instala las dependencias de Composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --optimize-autoloader --no-dev

# Configura el contenedor para que escuche en el puerto 80
EXPOSE 80

# Inicia Apache al ejecutar el contenedor
CMD ["apache2-foreground"]
