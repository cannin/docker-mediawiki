## Build Image

```
docker build -t cannin/mediawiki .
```

### Notes
No ssl yet and you still have to do manual configuration once it's up and running. MySQL server should really be a separate container and we should probably have a container for any non-static mediawiki data too.

## Run Image
```
docker run -d  -p 80:80\ 
-e "MYSQL_ROOT_PASSWORD=<Your MYSQL Password>" \ 
-e "SMTP_SERVER=smtp.gmail.com:587"\ 
-e "SMTP_USERNAME=<me@gmail.com>"\ 
-e "SMTP_PASSWORD=<mypass>"\
-v /directory/on/host:/mediawikiData  cannin/mediawiki 
```

## Access Mediawiki
Once your container is running, give it a couple of seconds to start up and then point your browser at http://dockerhost/mediawiki

## Install Mediawiki
Run through the installation and when it gives you a LocalSettings.php file, stick it in the directory you're using as a volume. 

### NOTE: LocalSettings permissions seem to need change after installation
```
chmod 644 works for LocalSettings.php
```

## Import old content 
```
for file in /mediawikiData/export/*.xml
do
  php /var/www/html/maintenance/importDump.php < $file
done

php /var/www/html/maintenance/rebuildrecentchanges.php 

php /var/www/html/maintenance/importImages.php /mediawikiData/imageExport svg png jpg jpeg gif bmp SVG PNG JPG JPEG GIF BMP
```