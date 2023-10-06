FROM debian:bullseye

WORKDIR /

# Install necessary packages
RUN apt-get update && apt-get -y upgrade && apt-get -y install mariadb-server \
&& rm -rf /var/lib/apt/lists/*

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-serverer.cnf
RUN chmod 644 /etc/mysql/mariadb.conf.d/50-server.cnf

WORKDIR /

COPY ./tools/create_db.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/create_db.sh

EXPOSE 3306

CMD ["create_db.sh"]
