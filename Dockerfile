FROM php:7.2.3-fpm
LABEL maintaner="yelfivehuang@gmail.com"

RUN apt-get update && apt-get install -y \
        apt-utils \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql zip

# install composer
RUN php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/bin/composer

# install yaml ext
RUN apt-get install -y libyaml-dev \
    && printf "\n" | pecl install yaml \
    && echo 'extension=yaml.so' > /usr/local/etc/php/conf.d/yaml.ini
