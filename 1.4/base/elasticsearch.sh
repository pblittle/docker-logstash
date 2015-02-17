#!/bin/bash

# Fail fast, including pipelines
set -e -o pipefail

# Set LOGSTASH_TRACE to enable debugging
[[ $LOGSTASH_TRACE ]] && set -x

ES_CONFIG_FILE="${SCRIPT_ROOT}/elasticsearch.yml"

function es_host() {
    local default_host=${ES_PORT_9200_TCP_ADDR:-127.0.0.1}
    local host=${ES_HOST:-$default_host}

    echo "$host"
}

function es_port() {
    local default_port=${ES_PORT_9200_TCP_PORT:-9200}
    local port=${ES_PORT:-$default_port}

    echo "$port"
}

function es_embedded() {
    local embedded=false

    if [ "$(es_host)" = "127.0.0.1" ] ; then
        embedded=true
    fi

    echo "$embedded"
}

function es_script_disable_dynamic() {
    local config_file="$ES_CONFIG_FILE"

    if [ ! -f "$config_file" ]; then
        cat > "$config_file" << EOF
---
script.disable_dynamic: true
EOF
    fi
}

if [[ -z "$(es_host)" ]]; then
    echo "An elasticsearch host string is required." >&2
    exit 1
fi

if [[ -z "$(es_port)" ]]; then
    echo "An elasticsearch port string is required." >&2
    exit 1
fi

if [[ -z "$(es_embedded)" ]]; then
    echo "An elasticsearch embedded boolean is required." >&2
    exit 1
fi
