First attempt at a mediawiki container. No ssl yet and you still have to do manual configuration once it's up and running.

docker run -d  -p80:80 -e "MYSQL_ROOT_PASSWORD=<Your MYSQL Password>" -v /directory/on/host:/mediawiki_data  cassj/mediawiki 

Once your container is running, give it a couple of seconds to start up and then point your browser at http://<dockerhost>/mediawiki

Run through the installation and when it gives you a LocalSettings.php file, stick it in the directory you're using as a volume. 


