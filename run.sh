#!/bin/bash

sed -i "s/ES_HOST:${ES_PORT_9200_TCP_ADDR}/g" \
    -i "s/ES_PORT:${ES_PORT_9200_TCP_PORT}/g" \
    > /opt/logstash.conf

exec java \
     -jar /opt/logstash.jar \
     agent \
     --config /opt/logstash.conf \
     -- \
     web
