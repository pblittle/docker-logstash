FROM pblittle/base:0.2.1
MAINTAINER P. Barrett Little <barrett@barrettlittle.com>

# Download latest package lists
RUN apt-get update

# Install dependencies
RUN apt-get install -yq openjdk-7-jre-headless wget

# Download version 1.3.3 of LogStash
WORKDIR /opt
RUN wget https://download.elasticsearch.org/logstash/logstash/logstash-1.3.3-flatjar.jar
RUN mv ./logstash-1.3.3-flatjar.jar ./logstash.jar

# Copy build files to container root
RUN mkdir /app
ADD . /app

# Elasticsearch
EXPOSE 9200

# Kibana
EXPOSE 9292

# Syslog
EXPOSE 514

#set some environment variables
ENV JAVA_OPTS -Xmx128M

# Start LogStash
ENTRYPOINT ["/app/bin/boot"]