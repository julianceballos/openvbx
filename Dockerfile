FROM centurylink/apache-php:latest
MAINTAINER Julian Ceballos

# Install packages
RUN apt-get update && \
 DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
 DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor pwgen unzip wget && \
 apt-get -y install mysql-client php5-curl php5-memcache

# Download OpenVBX into /app
RUN rm -fr /app && mkdir /app && \
 wget https://api.github.com/repos/twilio/OpenVBX/tarball/1.2.14 && \
 tar -zxvf 1.2.14 -C /tmp  && \
 cp -a /tmp/twilio*/. /app && \
 rm -rf /tmp/twilio*

# OpenVBX folder permissions
RUN chmod -R 777 /app/OpenVBX/config
RUN chmod -R 777 /app/audio-uploads

# Add script to create 'openvbx' DB
ADD run.sh run.sh
RUN chmod 755 /*.sh
#RUN chmod -R 777 /var/www/html/config/ /var/www/html/files/ /var/www/html/packages/

EXPOSE 80
CMD ["/run.sh"]
