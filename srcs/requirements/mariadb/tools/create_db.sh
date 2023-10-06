#!/bin/bash
set -x
set -e

if [ ! -f "/var/lib/mysql/mysql/setup" ]; then

    # Transfer ownership of database dir to mysql user. 
    chown -R mysql:mysql /var/lib/mysql

    mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /var/log/mysql_install.log
    mysql_safe > /var/log/mysqld_safe.log

    # Create setup file, indicating mariadb has initialized
    touch /var/lib/mysql/mysql/setup || { echo "Error creating setup file"; exit 1; }

    # Bootstrap server and initialize data with the sql file created
    mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

DELETE FROM mysql.user WHERE User='';
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN {'localhost', '127.0.0.1', '::1'};

ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';

CREATE DATABASE ${DB_DATABASE} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '${DB_USER}'@'%' IDENTIFIED by '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_DATABASE}.* TO '${DB_USER}'@'%';

FLUSH PRIVILEGES;
EOF

echo "Database setup completed successfully"
fi

# Starting and stopping mariadb automatically
mysqld_safe