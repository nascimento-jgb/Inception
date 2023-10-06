#!/bin/bash

# Transfer ownership of database dir to mysql user. 
# This is a common step in setting up a MySQL server because MySQL 
# typically runs as the mysql user, and it requires appropriate permissions to access and modify its data directory.
chown -R mysql:mysql /var/lib/mysql

#create the sql file with the commands to change root pass, create db and user and give privileges to db to user
cat << EOF > createdb.sql
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';

CREATE DATABASE ${MYSQL_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED by '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_NAME}.* TO '${MYSQL_USER}'@'%';


FLUSH PRIVILEGES;
EOF

#bootstrap server and initialize data with the sql file created
mysqld --bootstrap --datadir=/var/lib/mysql --user=mysql < createdb.sql

#remove the file
rm createdb.sql

#starting and stopping mariadb automatically
mysqld_safe
