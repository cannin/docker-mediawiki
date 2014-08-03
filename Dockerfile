FROM ubuntu
MAINTAINER Cass Johnston <cassjohnston@gmail.com>

RUN apt-get update
RUN apt-get upgrade -y
RUN export DEBIAN_FRONTEND=noninteractive && apt-get -q -y install vim wget apache2 php5  libapache2-mod-php5 php5-cli php-apc php5-intl imagemagick supervisor

# https://github.com/docker/docker/issues/6345
RUN cp /usr/bin/chfn /usr/bin/chfn_bk && ln -s -f /bin/true /usr/bin/chfn
RUN export DEBIAN_FRONTEND=noninteractive && apt-get -q -y install mysql-server php5-mysql 
RUN mv /usr/bin/chfn_bk /usr/bin/chfn

# ssmtp for mail
RUN apt-get -q -y install ssmtp mailutils
ADD ssmtpinit /usr/local/bin/ssmtpinit
RUN chmod +x /usr/local/bin/ssmtpinit

RUN wget http://releases.wikimedia.org/mediawiki/1.23/mediawiki-1.23.2.tar.gz
RUN tar -xvzf mediawiki-1.23.2.tar.gz
RUN rm -rf /var/www/html
RUN mv mediawiki-1.23.2 /var/www/html

ADD php.ini /etc/php5/apache2/php.ini

# create a mount point for a volume and a symlink so you can have the LocalSettings file on the host.
RUN mkdir /mediawiki_data
RUN ln -s /mediawiki_data/LocalSettings.php /var/www/html/LocalSettings.php

# Add a cron job for backup
ADD backup /etc/cron.daily/mediawiki_backup
RUN chmod +x /etc/cron.daily/mediawiki_backup

# Enable cgi
RUN a2enmod cgi

EXPOSE 80
EXPOSE 443

# We can't use apachectl as an entrypoint because it starts apache and then exits, taking your container with it. 
# Instead, use supervisor to monitor the apache process
RUN mkdir -p /var/log/supervisor

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf 

CMD ["/usr/bin/supervisord"]






