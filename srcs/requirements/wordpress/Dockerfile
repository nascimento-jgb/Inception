FROM debian:bullseye

RUN apt update -y 
RUN apt install php-fpm php-mysql mariadb-client -y
RUN apt install curl -y

COPY ./tools/wordpress.sh /
RUN chmod +x /wordpress.sh
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/

RUN mkdir /run/php

CMD [ "/wordpress.sh" ]