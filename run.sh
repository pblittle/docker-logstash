#!/bin/bash

LOGSTASH_CONFIG_FILE="/opt/logstash.conf"
LOGSTASH_CONFIG_URL=${LOGSTASH_CONFIG_URL:-}

if [ -z "${LOGSTASH_CONFIG_URL}" ]; then
    LOGSTASH_CONFIG_URL="https://gist.github.com/pblittle/8778567/raw/logstash.conf"
fi

wget $LOGSTASH_CONFIG_URL -O $LOGSTASH_CONFIG_FILE

sed -e "s/ES_HOST/${ES_PORT_9200_TCP_ADDR}/g" \
    -e "s/ES_PORT/${ES_PORT_9200_TCP_PORT}/g" \
    -i $LOGSTASH_CONFIG_FILE

exec java \
     ${JAVA_OPTS} \
     -jar /opt/logstash.jar \
     agent \
     --config $LOGSTASH_CONFIG_FILE \
     -- \
     web
