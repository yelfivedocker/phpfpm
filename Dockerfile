FROM yelfive/phpfpm-automated:7.2.3-1
LABEL maintaner="yelfivehuang@gmail.com"

RUN curl -O https://xdebug.org/files/xdebug-2.6.0.tgz \
    && tar -zxf xdebug-2.6.0.tgz \
    && cd xdebug-2.6.0 \
    && phpize \
    && ./configure \
    && make \
    && cp ./.libs/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-`phpize -v | head -n 2| tail -n 1|awk '{print $4}'`/ \
    && cd .. && rm -rf xdebug-2.6.0* package.xml \
    # Using `xdebug` inside container to start debug session.
    && echo alias "xdebug='export XDEBUG_CONFIG=\"remote_enable=1 remote_mode=req remote_port=9000 remote_host=10.254.254.254 remote_connect_back=0\" PHP_IDE_CONFIG=\"serverName=localhost\"'" >> ~/.bashrc

# Copy ini file but do not load it
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini.disabled