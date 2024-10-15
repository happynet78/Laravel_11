FROM php:8.3-fpm

ARG user
ARG uid

RUN apt-get update && apt-get install -y curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libfreetype-dev \
	libjpeg62-turbo-dev \
    git \
    zip \
    unzip && pecl install xdebug-3.3.2 && docker-php-ext-enable xdebug


ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN install-php-extensions bz2 gd xdebug redis ldap pdo_pgsql pgsql mongodb gmagick sockets


RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath calendar mysqli gd -j$(nproc)


# Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && chown -R $user:$user /home/$user
RUN chown $user:www-data . /var/www

COPY --chown=$user:www-data . /var/www

WORKDIR /var/www

USER $user

EXPOSE 9000
