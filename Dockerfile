FROM yelfive/phpfpm-automated:7.2.3-1-xdebug AS xdebug
FROM yelfive/phpfpm-grpc-lite:1.0.0 AS grpc
LABEL maintaner="yelfivehuang@gmail.com"

FROM php:7.2-fpm-alpine

# xdebug.so
COPY --from=xdebug /usr/local/lib/php/extensions/no-debug-non-zts-20170718/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/xdebug.so
COPY --from=xdebug /usr/local/etc/php/conf.d/xdebug.ini.disabled /usr/local/etc/php/conf.d/xdebug.ini.disabled
# pdo_mysql.so
COPY --from=grpc /usr/local/lib/php/extensions/no-debug-non-zts-20170718/pdo_mysql.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/pdo_mysql.so
RUN echo extension=pdo_mysql.so > /usr/local/etc/php/conf.d/pdo_mysql.ini
# zip.so
# installed, disabled
COPY --from=grpc /usr/local/lib/php/extensions/no-debug-non-zts-20170718/zip.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/zip.so
# yaml.so
# installed, disabled
COPY --from=grpc /usr/local/lib/php/extensions/no-debug-non-zts-20170718/yaml.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/yaml.so
# grpc.so
COPY --from=grpc /usr/local/lib/php/extensions/no-debug-non-zts-20170718/grpc.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/grpc.so
RUN echo extension=grpc.so > /usr/local/etc/php/conf.d/grpc.ini
RUN apk add gcompat gcc
# protobuf.so
COPY --from=grpc /usr/local/lib/php/extensions/no-debug-non-zts-20170718/protobuf.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/protobuf.so
RUN echo extension=protobuf.so > /usr/local/etc/php/conf.d/protobuf.ini
# protoc
COPY --from=grpc /usr/local/bin/protoc /usr/local/bin/protoc
COPY --from=grpc /usr/local/include/protobuf /usr/local/include/google/protobuf
# grpc_php_plugin
COPY --from=grpc /usr/local/bin/grpc_php_plugin /usr/local/bin/grpc_php_plugin
# composer
COPY --from=grpc /usr/bin/composer /usr/local/bin/composer

# iconv gd
RUN apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev && \
    docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    docker-php-ext-install -j${NPROC} gd && \
    docker-php-ext-install -j$(nproc) iconv && \
    apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev