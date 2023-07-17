ARG PHP_VERSION="8.2.7-fpm-bullseye"
ARG PHP_EXT_INSTALLER_VERSION=2.1.10
ARG COMPOSER_VERSION=latest

# --------------------------------------------
# base stage
# --------------------------------------------
FROM mlocati/php-extension-installer:${PHP_EXT_INSTALLER_VERSION} AS php-extension-installer
FROM php:${PHP_VERSION} AS base

COPY --from=php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN apt-get update && apt-get install -y \
    bash \
    curl \
    libfcgi-bin \
    parallel \
    && rm -rf /var/lib/apt/lists/*


RUN install-php-extensions \
    amqp \
    bcmath \
    gmp \
    intl \
    pdo_mysql \
    redis \
    zip

RUN curl -sS https://get.symfony.com/cli/installer | bash && mv /root/.symfony5/bin/symfony /usr/local/bin/symfony
RUN curl -L https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/v0.5.0/php-fpm-healthcheck -o /usr/local/bin/php-fpm-healthcheck \
    && chmod +x /usr/local/bin/php-fpm-healthcheck

COPY deployments/docker/php/php.ini $PHP_INI_DIR/conf.d/php.ini
COPY deployments/docker/php/opcache-runtime.ini $PHP_INI_DIR/conf.d/opcache.ini
COPY deployments/docker/php/fpm.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY deployments/docker/php/apcu.ini $PHP_INI_DIR/conf.d/apcu.ini

ARG UNAME=www-data
ARG UGROUP=www-data
ARG UID=1000
ARG GID=1001

RUN groupmod -g ${GID} ${UGROUP} && \
    usermod -u ${UID} -g ${GID} ${UNAME}



# --------------------------------------------
# builder stage
# --------------------------------------------
FROM composer:${COMPOSER_VERSION} AS composer
FROM base AS builder

COPY --from=composer /usr/bin/composer /usr/local/bin

# --------------------------------------------
# dev stage
# --------------------------------------------
FROM builder AS development

ARG USER_ID=1000

COPY deployments/docker/php/opcache-development.ini $PHP_INI_DIR/conf.d/opcache.ini
RUN install-php-extensions \
    xdebug

COPY deployments/docker/php/xdebug.ini $PHP_INI_DIR/conf.d
COPY deployments/docker/php/disable_xdebug.sh /usr/local/bin/disable_xdebug
COPY deployments/docker/php/enable_xdebug.sh /usr/local/bin/enable_xdebug

RUN chmod u+x /usr/local/bin/disable_xdebug /usr/local/bin/enable_xdebug

# --------------------------------------------
# installer stage
# --------------------------------------------
FROM builder AS installer

COPY composer.json .
COPY composer.lock .

RUN composer install \
    --no-interaction \
    --no-progress \
    --no-ansi \
    # --no-dev \
    --ignore-platform-reqs \
    && chown -R www-data: .

# --------------------------------------------
# shared stage
# --------------------------------------------
FROM base AS shared-ecosystem

COPY . /var/www/html
COPY --from=installer /var/www/html /var/www/html

RUN mkdir -p /var/www/html/var/cache/test && chown www-data:www-data /var/www/html/var/cache/test
RUN mkdir -p /var/www/html/var/log && chown www-data:www-data /var/www/html/var/log
RUN chown -R www-data:www-data /var/www/html/var


# --------------------------------------------
# all-in-one stage
# --------------------------------------------
FROM shared-ecosystem AS all-in-one

# --------------------------------------------
# private api stage
# --------------------------------------------
FROM shared-ecosystem AS private-api-backend
RUN ln -s /var/www/html/apps/private-api /var/www/html/apps/current-app
RUN mkdir -p /var/www/html/apps/private-api/backend/var/cache/prod && chown www-data:www-data /var/www/html/apps/private-api/backend/var/cache/prod
RUN mkdir -p /var/www/html/apps/private-api/backend/var/cache/test && chown www-data:www-data /var/www/html/apps/private-api/backend/var/cache/test
RUN mkdir -p /var/www/html/apps/private-api/backend/var/cache/dev && chown www-data:www-data /var/www/html/apps/private-api/backend/var/cache/dev
RUN mkdir -p /var/www/html/apps/private-api/backend/var/log && chown www-data:www-data /var/www/html/apps/private-api/backend/var/log