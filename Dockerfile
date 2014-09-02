FROM ubuntu:14.04
MAINTAINER P. Barrett Little <barrett@barrettlittle.com>

# Download latest package lists
RUN apt-get update

# Install dependencies
RUN apt-get install -yq \
    openjdk-7-jre-headless \
    wget

# Download version 1.4.2 of logstash
RUN cd /tmp && \
    wget https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz && \
    tar -xzvf ./logstash-1.4.2.tar.gz && \
    mv ./logstash-1.4.2 /opt/logstash && \
    rm ./logstash-1.4.2.tar.gz

# Install contrib plugins
RUN /opt/logstash/bin/plugin install contrib
# Copy build files to container root
RUN mkdir /app
ADD . /app

# Elasticsearch
EXPOSE 9200

# Kibana
EXPOSE 9292

# Syslog
EXPOSE 514

# Start logstash
ENTRYPOINT ["/app/bin/boot"]