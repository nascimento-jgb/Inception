FROM debian:bullseye

WORKDIR /

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install php \
wget \
mariadb-client \
apache2 \
sendmail \
php-fpm \
wordpress

#Create the folder to enable php start
RUN mkdir -p /run/php && mkdir -p /var/www/html
COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

# Install wp-cli
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

#Copy the necessary tools to wordpress dir
COPY ./tools/wordpress_config.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wordpress_config.sh

EXPOSE 9000

CMD ["wordpress_config.sh"]