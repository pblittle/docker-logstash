FROM pblittle/docker-logstash:0.11.0
MAINTAINER P. Barrett Little <barrett@barrettlittle.com> (@pblittle)

# Download packages required to run the test suite
#
RUN apt-get update \
    && apt-get install -yq \
        apt-utils \
        net-tools \
        --no-install-recommends \
    && rm -rf /var/cache/apt/* \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
ADD test.sh /app/
