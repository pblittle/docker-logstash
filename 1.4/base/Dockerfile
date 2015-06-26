FROM java:7-jre
MAINTAINER P. Barrett Little <barrett@barrettlittle.com> (@pblittle)

# Set default Logstash version
ENV LOGSTASH_VERSION 1.4.3

# Download and install Logstash
RUN cd /tmp && \
    wget https://download.elastic.co/logstash/logstash/logstash-${LOGSTASH_VERSION}.tar.gz && \
    tar -xzvf ./logstash-${LOGSTASH_VERSION}.tar.gz && \
    mv ./logstash-${LOGSTASH_VERSION} /opt/logstash && \
    rm ./logstash-${LOGSTASH_VERSION}.tar.gz

# Install contrib plugins
RUN /opt/logstash/bin/plugin install contrib

# Copy build files to container root
RUN mkdir /app
ADD . /app

# Set default data directory
ENV DATA_DIR /data

# Define mountable directory
VOLUME ${DATA_DIR}

# Kibana
EXPOSE 9292

# Start logstash
ENTRYPOINT ["/app/bin/boot"]

# Valid commands: `agent`, `web`, `configtest`
# Default (empty command) runs the ELK stack
CMD []
