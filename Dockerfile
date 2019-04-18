FROM yelfive/phpfpm-automated:7.2.3-1-xdebug AS xdebug
FROM yelfive/phpfpm-grpc-lite:1.0.0 AS grpc
LABEL maintaner="yelfivehuang@gmail.com"

FROM php:7.2-fpm-alpine

# xdebug.so
COPY --from=xdebug /usr/local/lib/php/extensions/no-debug-non-zts-20170718/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/xdebug.so
COPY --from=xdebug /usr/local/etc/php/conf.d/xdebug.ini.disabled /usr/local/etc/php/conf.d/xdebug.ini.disabled
# gd.so
COPY --from=grpc /usr/local/lib/php/extensions/no-debug-non-zts-20170718/gd.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/gd.so
# pdo_mysql.so
COPY --from=grpc /usr/local/lib/php/extensions/no-debug-non-zts-20170718/pdo_mysql.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/pdo_mysql.so
# zip.so
COPY --from=grpc /usr/local/lib/php/extensions/no-debug-non-zts-20170718/zip.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/zip.so
# yaml.so
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