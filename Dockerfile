FROM yelfive/phpfpm:full AS full
FROM yelfive/phpfpm:lv3-1.0
LABEL maintaner="yelfivehuang@gmail.com"

COPY --from=full /usr/local/lib/php/extensions/no-debug-non-zts-20170718/mongodb.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/mongodb.so
RUN echo extension=mongodb.so > /usr/local/etc/php/conf.d/mongodb.ini.disabled