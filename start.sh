#!/bin/bash
# - Install  MajorDoMo if not already installed
# - Run apache in foreground

### GENERAL CONF ###############################################################

APACHE_DIR="/var/www/html"
MJD_DIR="${APACHE_DIR}/mjd"
MJD_SOURCE_URL=${MJD_SOURCE_URL:-"http://smartliving.ru/download/_majordomo_linux_090b.tar.gz"}


### INSTALL MajorDoMo IF NOT INSTALLED ALREADY ######################################

if [ "$(ls -A $MJD_DIR)" ]; then
  echo "MJD is already installed at ${MJD_DIR}"
else
  echo '-----------> Install  MajorDoMo'
  echo "Using ${MJD_SOURCE_URL}"
  wget -O /tmp/_majordomo_linux_090b.tar.gz $MJD_SOURCE_URL 
  #--no-check-certificate
  tar -C $APACHE_DIR -xzf /tmp/_majordomo_linux_090b.tar.gz
  chown -R www-data $MJD_DIR
fi

### REMOVE THE DEFAULT INDEX.HTML TO LET HTACCESS REDIRECTION ##################

# rm ${APACHE_DIR}/index.html

VHOST=/etc/apache2/sites-enabled/000-default.conf

# Use /var/www/html/MJD as DocumentRoot
sed -i -- 's/\/var\/www\/html/\/var\/www\/html\/mjd/g' $VHOST
# Remove ServerSignature (secutiry)
awk '/<\/VirtualHost>/{print "ServerSignature Off" RS $0;next}1' $VHOST > tmp && mv tmp $VHOST

# HTACCESS="/var/www/html/.htaccess"
# /bin/cat <<EOM >$HTACCESS
# RewriteEngine On
# RewriteRule ^$ /MJD [L]
# EOM
# chown www-data /var/www/html/.htaccess
chown www-data .

### RUN APACHE IN FOREGROUND ###################################################

# stop apache service
# service apache2 stop
service apache2 restart

# start apache in foreground
# source /etc/apache2/envvars
# /usr/sbin/apache2 -D FOREGROUND
tail -f /var/log/apache2/error.log -f /var/log/apache2/access.log
