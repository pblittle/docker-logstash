#!/bin/bash

# Fail fast, including pipelines
set -e -o pipefail

# Set LOGSTASH_TRACE to enable debugging
[[ $LOGSTASH_TRACE ]] && set -x

KIBANA_CONFIG_FILE="${LOGSTASH_SRC_DIR}/vendor/kibana/config.js"

function es_proxy_host() {
    local host=${ES_PROXY_HOST:-'"+window.location.hostname+"'}

    echo "$host"
}

function es_proxy_port() {
    local port=${ES_PROXY_PORT:-9200}

    echo "$port"
}

function kibana_es_protocol() {
    local protocol=${ES_PROTOCOL:-'http'}

    echo "$protocol"
}

function kibana_sanitize_config() {
    local protocol="$(kibana_es_protocol)"
    local host="$(es_proxy_host)"
    local port="$(es_proxy_port)"

    sed -e "s|http|${protocol}|g" \
        -e "s|\"+window.location.hostname+\"|${host}|g" \
        -e "s|9200|${port}|g" \
        -i "$KIBANA_CONFIG_FILE"
}

if [[ -z "$(es_proxy_host)" ]]; then
    echo "An Elasticsearch proxy host is required." >&2
    exit 1
fi

if [[ -z "$(es_proxy_port)" ]]; then
    echo "An Elasticsearch proxy port is required." >&2
    exit 1
fi

if [[ -z "$(kibana_es_protocol)" ]]; then
    echo "An elasticsearch protocol is required." >&2
    exit 1
fi
