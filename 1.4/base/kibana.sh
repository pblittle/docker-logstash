#!/bin/bash

# Fail fast, including pipelines
set -e -o pipefail

# Set LOGSTASH_TRACE to enable debugging
[[ $LOGSTASH_TRACE ]] && set -x

KIBANA_CONFIG_FILE="${LOGSTASH_SRC_DIR}/vendor/kibana/config.js"

readonly PROXY_PROTOCOL_REGEX='\(http[s]\?\)'

function es_proxy_host() {
    local host=${ES_PROXY_HOST:-'"+window.location.hostname+"'}

    echo "$host"
}

function es_proxy_port() {
    local port=${ES_PROXY_PORT:-9200}

    echo "$port"
}

function es_proxy_protocol() {
    local protocol=${ES_PROXY_PROTOCOL:-'http'}

    echo "$protocol"
}

function kibana_sanitize_config() {
    local host="$(es_proxy_host)"
    local port="$(es_proxy_port)"
    local protocol="$(es_proxy_protocol)"

    sed -e "s|${PROXY_PROTOCOL_REGEX}|${protocol}|gI" \
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

if [[ -z "$(es_proxy_protocol)" ]]; then
    echo "An Elasticsearch proxy protocol is required." >&2
    exit 1
fi
