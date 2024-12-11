#!/bin/bash

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysqld --initialize-insecure --user=mysql
fi

mysqld --user=mysql &

until mysqladmin ping -h"localhost" --silent; do
    sleep 1
done

mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS search_app;
USE search_app;
CREATE USER IF NOT EXISTS 'app'@'localhost' IDENTIFIED BY 'dummy';
GRANT ALL PRIVILEGES ON search_app.* TO 'app'@'localhost';
GRANT FILE ON *.* TO 'app'@'localhost';
FLUSH PRIVILEGES;
EOF

mysql -u root search_app < /docker-entrypoint-initdb.d/init.sql

apache2-foreground
