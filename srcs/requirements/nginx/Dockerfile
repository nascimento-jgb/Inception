FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl

RUN mkdir -m 775 /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/jonascim.key \
	-out /etc/nginx/ssl/jonascim.crt \
	-subj "/C=FI/ST=Helsinki/L=Helsiniki/O=Hive/OU=jonascim/CN=jonascim/"

COPY tools/default /etc/nginx/sites-available/default
COPY conf/nginx.conf /etc/nginx/nginx

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
