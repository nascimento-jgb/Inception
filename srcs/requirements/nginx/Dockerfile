#Precise with what our image will be built
FROM debian:bullseye

WORKDIR /

#Install nginx with RUN
RUN apt-get update && apt-get -y install nginx openssl \
&& rm -rf /var/lib/apt/lists/*

#Generate a self certificate
RUN mkdir -m 775 /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/ssl/jonascim.42.fr.pem -keyout /etc/ssl/jonascim.42.fr.key -subj "/C=FI/ST=Helsinki/L=Helsinki/O=42 School/OU=jonascim/CN=jonascim.42.fr"

#Copy the configuration to inside of nginx dir
COPY ./tools/default /etc/nginx/sites-available/default
COPY ./conf/nginx.conf /etc/nginx/

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]