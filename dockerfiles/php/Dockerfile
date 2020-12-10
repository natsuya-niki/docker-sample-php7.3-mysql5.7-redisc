FROM php:7.3-fpm

RUN apt-get update && apt-get -y install libpq-dev zlib1g-dev libzip-dev

# php.ini
RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini
RUN	sed -i -e "s|;session.save_path = "/tmp"|session.save_path = "/tmp" |" /usr/local/etc/php/php.ini
RUN	sed -i -e "s|;extension=php_openssl.dll|extension=php_openssl.dll |" /usr/local/etc/php/php.ini

# phpライブラリ
RUN	docker-php-ext-install pdo_mysql mysqli mbstring zip
RUN	pecl install xdebug
RUN	docker-php-ext-enable xdebug

COPY ./xdebug.ini $PHP_INI_DIR/conf.d/

# composer インストール
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# php composerの設定
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer
ENV PATH $PATH:/composer/vendor/bin