FROM pblittle/docker-logstash:0.20.0
MAINTAINER P. Barrett Little <barrett@barrettlittle.com> (@pblittle)

# Download packages required to run the test suite
#
RUN apt-get update \
    && apt-get install -yq \
        apt-utils \
        git \
        net-tools \
        --no-install-recommends \
    && rm -rf /var/cache/apt/* \
    && rm -rf /var/lib/apt/lists/*

# Download and install BATS test framework
#
RUN git clone https://github.com/sstephenson/bats.git /tmp/bats \
    && /tmp/bats/install.sh /usr/local \
    && rm -rf /tmp/bats

# $TERM needs to be set for bats
#
ENV TERM xterm-256color

ADD test.bats /app/test.bats

EXPOSE 9200 9300

CMD [ '/usr/local/bin/bats', '/app/test.bats' ]
