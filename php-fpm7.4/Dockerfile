FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

ENV APP_UID=1000
ENV APP_GID=1000

ENV COMPOSER_HOME /.composer
ENV PATH="/.composer/vendor/bin:${PATH}"

COPY ondrej.pgp /root/ondrej.pgp

RUN userdel -f www-data && \
    if getent group www-data ; then groupdel www-data; fi && \
    groupadd -g ${APP_GID} www-data && \
    useradd -l -u ${APP_UID} -g www-data www-data

# php ppa
RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
        apt-utils ca-certificates curl git gnupg zip unzip \
    && \
    cat /root/ondrej.pgp | apt-key add && \
        printf "deb [arch=amd64] http://ppa.launchpad.net/ondrej/php/ubuntu bionic main\n" \
>/etc/apt/sources.list.d/ondrej.list && \
    rm -f /root/ondrej.pgp && \
    apt-get update && \
    apt-get -y --purge autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/{man,doc}

# php base
# wkhtmltopdf needs libxrender1, etc
RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
        php7.4-cli php7.4-curl php7.4-fpm php7.4-gd php7.4-gmp php7.4-intl \
        php7.4-mbstring php7.4-mysql php7.4-pgsql php7.4-sqlite php7.4-xsl php7.4-zip \
        php-imagick php-xdebug php7.4-bcmath \
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

# cleanup
RUN rm -rf \
    /etc/php/5.6 \
    /etc/php/7.0 \
    /etc/php/7.1 \
    /etc/php/7.2

# set up PID and sessions directories
RUN install -d -m 0755 -o www-data -g www-data \
    /var/run/php-fpm \
    /var/lib/php/sessions

# inject a default ini and conf files
RUN rm -f /etc/php/7.4/fpm/php-fpm.conf && \
    rm -f /etc/php/7.4/fpm/pool.d/www.conf && \
    ln -s /etc/php/7.4/fpm/conf.d /etc/php/fpm-conf.d && \
    ln -s /etc/php/7.4/cli/conf.d /etc/php/cli-conf.d && \
    ln -s /etc/php/www.conf /etc/php/7.4/fpm/php-fpm.conf && \
    ln -s /etc/php/www-xdebug.conf /etc/php/7.4/fpm/pool.d/www-xdebug.conf && \
    ln -s /etc/php/99-custom.ini /etc/php/7.4/fpm/conf.d/99-custom.ini

RUN rm -rf /etc/apache2

###############################################################################

WORKDIR /var/www

CMD ["php-fpm7.4", "--nodaemonize"]

EXPOSE 9074 9974
