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

COPY nginx /etc/nginx/
RUN rm -f /etc/nginx/sites-enabled/default

VOLUME ["/etc/nginx/sites-enabled", "/var/lib/git", "/var/lib/git-http"]

CMD \
  [ ! -f /etc/nginx/sites-enabled/git-http ] && \
    cp /etc/nginx/sites-available/git-http /etc/nginx/sites-enabled/; \
  echo "FCGI_GROUP=${GIT_GROUP}" > /etc/default/fcgiwrap && \
  service fcgiwrap start && \
  service nginx start

EXPOSE 80 443
