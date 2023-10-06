#! /bin/bash
set -x
set -e
 
# Establish connection to mariadb before proceeding
while ! mariadb -h${MYSQL_HOSTNAME} -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE}; do
		echo "hi"
		echo "Establishing connection to database.."
		echo "MySQL Hostname: ${MYSQL_HOSTNAME}"
		echo "MySQL User: ${MYSQL_USER}"
		echo "MySQL Password: ${MYSQL_PASSWORD}"
		echo "MySQL Database: ${MYSQL_DATABASE}"
		echo "hello"
    sleep 5
done


if [ -f "wp-config.php" ]; then
	echo "WordPress: already installed"
else
	wp core download --allow-root

	wp config create --allow-root \
		--dbhost=${MYSQL_HOSTNAME} \
		--dbname=${MYSQL_DATABASE} \
		--dbuser=${MYSQL_USER} \
		--dbpass=${MYSQL_PASSWORD}

	wp core install --allow-root \
		--url=jonascim.42.fr \
		--title="My awesome webpage!" \
		--admin_user=${WP_ADMIN_USER} \
		--admin_password=${WP_ADMIN_PASSWORD} \
		--admin_email=${WP_ADMIN_EMAIL}

	wp user create --allow-root \
		${WP_USER} ${WP_USER_EMAIL} \
		--role=${WP_ROLE} \
		--user_pass=${WP_USER_PASSWORD}
	
	chown -R www-data:www-data /var/www/html
	chmod -R 775 /var/www/html

	echo "Finished installation and setup!"
fi

/usr/sbin/php-fpm7.3 -R -F