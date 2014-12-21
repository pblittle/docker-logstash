FROM java:7-jre
MAINTAINER P. Barrett Little <barrett@barrettlittle.com>

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

# Kibana
EXPOSE 9292

# Start logstash
ENTRYPOINT ["/app/bin/boot"]
