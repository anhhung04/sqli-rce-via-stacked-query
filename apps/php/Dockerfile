FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    default-mysql-server \
    libpq-dev \
    libzip-dev \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo pdo_mysql zip

RUN a2enmod rewrite

RUN mkdir -p /var/lib/mysql /var/run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

WORKDIR /var/www/html
COPY config.php /var/www/html/
COPY index.php /var/www/html/

COPY init.sql /docker-entrypoint-initdb.d/

COPY start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 777 /var/www/html

EXPOSE 80 3306

CMD ["/usr/local/bin/start.sh"]
