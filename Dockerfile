FROM php:8.3-fpm

ARG user
ARG uid

RUN apt-get update && apt-get install -y curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libjpeg-dev \
    libfreetype-dev \
    git \
    zip \
    unzip

RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath calendar mysqli gd

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && chown -R $user:$user /home/$user
RUN chown $user:www-data . /var/www

COPY --chown=$user:www-data . /var/www

WORKDIR /var/www

USER $user

EXPOSE 9000
