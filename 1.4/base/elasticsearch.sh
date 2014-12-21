#!/bin/bash

# Fail fast, including pipelines
set -e -o pipefail

# Set LOGSTASH_TRACE to enable debugging
[[ $LOGSTASH_TRACE ]] && set -x

es_host() {
    local default_host=${ES_PORT_9200_TCP_ADDR:-127.0.0.1}
    local host=${ES_HOST:-$default_host}

    echo "$host"
}

es_port() {
    local default_port=${ES_PORT_9200_TCP_PORT:-9200}
    local port=${ES_PORT:-$default_port}

    echo "$port"
}

es_protocol() {
    local default_protocol='http'
    local protocol=${ES_PROTOCOL:-$default_protocol}

    echo "$protocol"
}

es_embedded() {
    local embedded=false

    if [ "$(es_host)" = "127.0.0.1" ] ; then
        embedded=true
    fi

    echo "$embedded"
}

if [[ -z "$(es_host)" ]]; then
    echo "An elasticsearch host is required." >&2
    exit 1
fi

if [[ -z "$(es_port)" ]]; then
    echo "An elasticsearch port is required." >&2
    exit 1
fi

if [[ -z "$(es_protocol)" ]]; then
    echo "An elasticsearch protocol is required." >&2
    exit 1
fi
