First attempt at a mediawiki container. No ssl yet and you still have to do manual configuration once it's up and running. Mysql server should really be a separate container and we should probably have a container for any non-static mediawiki data too, but I need to get something up and running so this'll have to do for now. 

docker run -d  -p80:80\ 
-e "MYSQL_ROOT_PASSWORD=<Your MYSQL Password>" \ 
-e "SMTP_SERVER=smtp.gmail.com:587"\ 
-e "SMTP_USERNAME=<me@gmail.com>"\ 
-e "SMTP_PASSWORD=<mypass>"\
-v /directory/on/host:/mediawiki_data  cassj/mediawiki 

Once your container is running, give it a couple of seconds to start up and then point your browser at http://<dockerhost>/mediawiki

Run through the installation and when it gives you a LocalSettings.php file, stick it in the directory you're using as a volume. 

There are some permissions issues running postfix on recent versions of docker. 
Details at https://github.com/docker/docker/pull/6970.
Apparently is fixed in git but change doesn't seem to have filtered down to the packaged versions of docker yet.
Run with --privileged=true and see if it works, if it does then you're hitting this issue. Maybe grab the latest docker from github?
