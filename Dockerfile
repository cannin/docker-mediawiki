FROM ubuntu
MAINTAINER Cass Johnston <cassjohnston@gmail.com>

RUN apt-get update
RUN export DEBIAN_FRONTEND=noninteractive && apt-get -q -y install vim wget mysql-server apache2 php5 php5-mysql libapache2-mod-php5 php5-cli php-apc php5-intl imagemagick supervisor 
RUN wget http://releases.wikimedia.org/mediawiki/1.23/mediawiki-1.23.2.tar.gz
RUN tar -xvzf mediawiki-1.23.2.tar.gz
RUN mv mediawiki-1.23.2 /var/www/html/mediawiki

ADD mediawiki_config.sh /usr/bin/mediawiki_config.sh
ADD php.ini /etc/php5/apache2/php.ini

# create a mount point for a volume and a symlink so you can have the LocalSettings file on the host.
RUN mkdir /mediawiki_data
RUN ln -s /mediawiki_data/LocalSettings.php /var/www/html/mediawiki/LocalSettings.php

# Enable cgi
RUN a2enmod cgi

EXPOSE 80
EXPOSE 443

# We can't use apachectl as an entrypoint because it starts apache and then exits, taking your container with it. 
# Instead, use supervisor to monitor the apache process
RUN mkdir -p /var/log/supervisor

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf 

CMD ["/usr/bin/supervisord"]






