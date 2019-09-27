FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

ENV APP_UID=1000
ENV APP_GID=1000

ENV COMPOSER_HOME /.composer
ENV PATH="/.composer/vendor/bin:${PATH}"

RUN userdel -f www-data && \
    if getent group www-data ; then groupdel www-data; fi && \
    groupadd -g ${APP_GID} www-data && \
    useradd -l -u ${APP_UID} -g www-data www-data

# php base
# wkhtmltopdf needs libxrender1, etc
RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
        ca-certificates curl git zip unzip \
        php7.2-cli php7.2-curl php7.2-fpm php7.2-gd php7.2-gmp php7.2-intl \
        php7.2-mbstring php7.2-mysql php7.2-pgsql php7.2-sqlite php7.2-xsl php7.2-zip \
        php7.2-imagick php7.2-xdebug php7.2-bcmath \
        libxext6 libxfont2 libfontconfig1 libxrender1 fonts-urw-base35 xfonts-75dpi \
    && \
    apt-get -y --purge autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/{man,doc}

# composer
RUN install -d -m 0755 -o www-data -g www-data /.composer && \
    curl -sS https://getcomposer.org/installer | \
        php -- --install-dir=/usr/local/bin \
               --filename=composer && \
    chown -R www-data:www-data /.composer

# php-fpm conf
COPY www.conf /etc/php/www.conf
COPY www-xdebug.conf /etc/php/www-xdebug.conf

# php ini
COPY 99-custom.ini /etc/php/99-custom.ini
COPY ./xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# inject a default ini and conf files
RUN rm -f /etc/php/7.2/fpm/php-fpm.conf && \
    rm -f /etc/php/7.2/fpm/pool.d/www.conf && \
    ln -s /etc/php/7.2/fpm/conf.d /etc/php/fpm-conf.d && \
    ln -s /etc/php/7.2/cli/conf.d /etc/php/cli-conf.d \
    ln -s /etc/php/www.conf /etc/php/7.2/fpm/php-fpm.conf && \
    ln -s /etc/php/www-xdebug.conf /etc/php/7.2/fpm/pool.d/www-xdebug.conf && \
    ln -s /etc/php/99-custom.ini /etc/php/7.2/fpm/conf.d/99-custom.ini

RUN rm -rf /etc/apache2

###############################################################################

WORKDIR /var/www

CMD ["php-fpm7.2", "--nodaemonize"]

EXPOSE 9072 9972
