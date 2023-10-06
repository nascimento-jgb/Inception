#!/bin/bash

# create directory to use in nginx container later and also to setup the wordpress conf
mkdir /var/www/
mkdir /var/www/html

cd /var/www/html

rm -rf *

#execute only if wordpress is not installed
if [ ! -f /var/www/html/wp-config.php ]; then

	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 

	chmod +x wp-cli.phar 

	mv wp-cli.phar /usr/local/bin/wp

	wp core download --allow-root

	#setup wp-config.php file with the proper values
	sed -i -r "s/database_name_here/$MYSQL_NAME/1"   /var/www/html/wp-config-sample.php
	sed -i -r "s/username_here/$MYSQL_USER/1"  /var/www/html/wp-config-sample.php
	sed -i -r "s/password_here/$MYSQL_PASSWORD/1"    /var/www/html/wp-config-sample.php
	sed -i -r "s/localhost/$MYSQL_HOST/1"    /var/www/html/wp-config-sample.php

	cp wp-config-sample.php wp-config.php

	#install and configure wordpress and create a new user
	wp core install --url=${DOMAIN_NAME} \
					--title=${WP_TITLE} \
					--admin_user=$WP_ADMIN_USER \
					--admin_password=$WP_ADMIN_PASSWORD \
					--admin_email=$WP_ADMIN_EMAIL \
					--skip-email \
					--allow-root

	wp user create  $WP_USER \
					$WP_USER_EMAIL \
					--role=$WP_ROLE \
					--user_pass=$WP_USER_PASSWORD \
					--allow-root

	#Install a theme
	wp theme install inspiro --activate --allow-root

fi

#start the PHP-FPM (FastCGI Process Manager) service for PHP version 7.3 in foreground mode
/usr/sbin/php-fpm7.4 -F