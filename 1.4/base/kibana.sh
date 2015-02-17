#!/bin/bash

# Fail fast, including pipelines
set -e -o pipefail

# Set LOGSTASH_TRACE to enable debugging
[[ $LOGSTASH_TRACE ]] && set -x

KIBANA_CONFIG_FILE="${LOGSTASH_SRC_DIR}/vendor/kibana/config.js"

function kibana_es_host() {
    local host=${ES_HOST:='"+window.location.hostname+"'}

    echo "$host"
}

function kibana_es_port() {
    local port=${ES_PORT:-9200}

    echo "$port"
}

function kibana_es_protocol() {
    local protocol=${ES_PROTOCOL:-'http'}

    echo "$protocol"
}

function kibana_sanitize_config() {
    local host="$(kibana_es_host)"
    local port="$(kibana_es_port)"
    local protocol="$(kibana_es_protocol)"

    sed -e "s|http|${protocol}|g" \
        -e "s|\"+window.location.hostname+\"|${host}|g" \
        -e "s|9200|${port}|g" \
        -i "$KIBANA_CONFIG_FILE"
}

if [[ -z "$(kibana_es_host)" ]]; then
    echo "An elasticsearch host is required." >&2
    exit 1
fi

if [[ -z "$(kibana_es_port)" ]]; then
    echo "An elasticsearch port is required." >&2
    exit 1
fi

if [[ -z "$(kibana_es_protocol)" ]]; then
    echo "An elasticsearch protocol is required." >&2
    exit 1
fi
