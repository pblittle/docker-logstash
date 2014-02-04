FROM ubuntu:12.04
MAINTAINER P. Barrett Little <barrett@barrettlittle.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe multiverse" > /etc/apt/sources.list

RUN apt-get update
RUN apt-get -yq upgrade
RUN apt-get install -yq wget openjdk-7-jre-headless

RUN cd /opt && \
  wget https://download.elasticsearch.org/logstash/logstash/logstash-1.3.3-flatjar.jar && \
  mv ./logstash-1.3.3-flatjar.jar ./logstash.jar

ADD https://gist.github.com/pblittle/8778567/raw/1170e2f41f67470807c1cbf3fb5d4d3ce3222d60/logstash.conf \
  /opt/logstash.conf

ADD . /logstash

VOLUME ["/data/logstash"]

# Kibana
EXPOSE 9292

# Syslog
EXPOSE 514

CMD "/logstash/run.sh"