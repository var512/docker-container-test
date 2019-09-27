FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

ENV APP_UID=1000
ENV APP_GID=1000

RUN userdel -f www-data && \
    if getent group www-data ; then groupdel www-data; fi && \
    groupadd -g ${APP_GID} www-data && \
    useradd -l -u ${APP_UID} -g www-data www-data

RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
        nginx openssl \
    && \
    apt-get -y --purge autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/{man,doc}

RUN chown -R www-data:www-data \
        /var/lib/nginx \
        /var/www && \
    install -d -m 0755 -o www-data -g www-data \
        /var/cache/nginx \
        /var/run/nginx && \
    rm -rf /var/www/html

COPY nginx.conf /etc/nginx/nginx.conf

RUN rm -rf /etc/nginx/sites-available /etc/nginx/sites-enabled

ADD ./startup.sh /opt/startup.sh

CMD ["/bin/bash", "/opt/startup.sh"]

EXPOSE 7280 7243 7480 7443
