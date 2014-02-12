FROM ubuntu:precise
MAINTAINER P. Barrett Little <barrett@barrettlittle.com>

# Update OS apt sources
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe multiverse" \
    > /etc/apt/sources.list

# Perform base image updates
RUN apt-get update
RUN apt-get -yq upgrade

# Install build-essential
RUN apt-get install -yq build-essential

# Install Wget and OpenJDK 7
RUN apt-get install -yq wget && \
    apt-get install -yq openjdk-7-jre-headless

# Download version 1.3.3 of LogStash
RUN cd /opt && \
    wget https://download.elasticsearch.org/logstash/logstash/logstash-1.3.3-flatjar.jar && \
    mv ./logstash-1.3.3-flatjar.jar ./logstash.jar

# Copy build files to container root
ADD . /logstash

# Kibana
EXPOSE 9292

# Syslog
EXPOSE 514

# Start LogStash
CMD "/logstash/run.sh"