#
# Dockerfile for mantisbt
#

FROM php:5.6-apache
MAINTAINER XelaRellum <XelaRellum@web.de>

RUN a2enmod rewrite

RUN set -xe \
    && apt-get update \
    && apt-get install -y libpng12-dev libjpeg-dev libpq-dev libxml2-dev \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd mbstring mysql mysqli pgsql soap \
    && rm -rf /var/lib/apt/lists/*

ENV MANTIS_VER 2.7.0
ENV MANTIS_SHA1 75c37213b47bb7cfef0ce6220f0c5795e1b5bcca
ENV MANTIS_URL http://jaist.dl.sourceforge.net/project/mantisbt/mantis-stable/${MANTIS_VER}/mantisbt-${MANTIS_VER}.tar.gz
ENV MANTIS_FILE mantisbt.tar.gz

RUN set -xe \
    && curl -fSL ${MANTIS_URL} -o ${MANTIS_FILE} \
    && echo "${MANTIS_SHA1}  ${MANTIS_FILE}" | sha1sum -c \
    && tar -xz --strip-components=1 -f ${MANTIS_FILE} \
    && rm ${MANTIS_FILE} \
    && chown -R www-data:www-data .

RUN set -xe \
    && ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && echo 'date.timezone = "Europe/Berlin"' > /usr/local/etc/php/php.ini