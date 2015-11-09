FROM ubuntu
MAINTAINER T-REX-XP@ya.ru
RUN apt-get update
RUN apt-get install -y ssh
RUN apt-get install -y apache2
RUN apt-get install -y \
  wget \
  php5 \
  php5-mysql \
  php5-ldap \
  php5-xmlrpc \
  curl \
  php5-cgi \
  php5-cli \
  php-pear \
  php-pear \
  php5-xcache \
  php5-curl \
  php5-gd   
RUN apt-get install libapache2-mod-php5
RUN apt-get install -y curl libcurl3 libcurl3-dev php5-curl
RUN apt-get install -y mysql-server mysql-client
RUN apt-get install -y phpmyadmin
RUN a2enmod rewrite && service apache2 stop
WORKDIR /var/www/html
COPY start.sh /opt/
RUN chmod +x /opt/start.sh
RUN usermod -u 1000 www-data
CMD /opt/start.sh
EXPOSE 80
