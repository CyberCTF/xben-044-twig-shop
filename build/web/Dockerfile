# Upstream's Dockerfile (XBEN-044-24/app/Dockerfile) with these changes:
# - the sources are copied from app/app/ (the vendored benchmark folder sits in app/)
# - the build argument FLAG defaults to this lab's fixed flag, the value upstream's Makefile passes
#   (FLAG{sha256 of "XBEN-044-24"}), since the spec passes no build arguments
# - on a Debian buster or bullseye base, apt reads archive.debian.org: both releases have left (or
#   are leaving) the Debian mirrors, so upstream's apt-get install fails there
# - composer:latest is pinned to composer:2.7
FROM php:8.0-apache
RUN . /etc/os-release && case "$VERSION_CODENAME" in \
      buster) sec=buster/updates ;; bullseye) sec=bullseye-security ;; *) sec= ;; esac \
 && if [ -n "$sec" ]; then \
      printf 'deb http://archive.debian.org/debian %s main\ndeb http://archive.debian.org/debian-security %s main\n' \
        "$VERSION_CODENAME" "$sec" > /etc/apt/sources.list && rm -f /etc/apt/sources.list.d/*; fi

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo_mysql

COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

COPY app/app/ /var/www/html

COPY app/app/wwwconf/ports.conf /etc/apache2/ports.conf
COPY app/app/wwwconf/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN groupadd -g 1000 appuser && \
    useradd -u 1000 -g appuser -m appuser

RUN chown -R appuser:appuser /var/www/html

USER appuser

RUN composer install 

USER root
RUN chown -R www-data:www-data /var/www/html/vendor

ARG FLAG=FLAG{c6c0f372989698df72a5025e39dc31cb5bd52dfc062e76782b713a02f3b5ac32}
RUN echo $FLAG > /flag.txt

EXPOSE 8080

CMD ["apache2-foreground"]
