FROM yelfive/phpfpm:lv2-1.0
LABEL maintaner="yelfivehuang@gmail.com"

RUN apk update  \
    && apk add libxml2-dev \
    && docker-php-ext-install soap

# Disable soap as it's an old-fashioned protocol
RUN rm /usr/local/etc/php/conf.d/docker-php-ext-soap.ini