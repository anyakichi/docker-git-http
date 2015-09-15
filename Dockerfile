FROM debian:jessie
MAINTAINER anyakichi@sopht.jp

ENV \
  GIT_GROUP="${GIT_GROUP:-www-data}"

RUN \
  apt-get update && \
  apt-get install -y fcgiwrap git gitweb nginx && \
  rm -rf /var/lib/apt/lists/* && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx

COPY configs/nginx/git-http /etc/nginx/sites-enabled/
RUN rm -f /etc/nginx/sites-enabled/default

VOLUME ["/etc/nginx/extras", "/var/lib/git"]

CMD \
  touch -a /etc/nginx/extras/git-http.conf && \
  echo "FCGI_GROUP=${GIT_GROUP}" > /etc/default/fcgiwrap && \
  service fcgiwrap start && \
  service nginx start

EXPOSE 80 443
