#!/bin/bash

# Fail fast, including pipelines
set -e -o pipefail

ES_CONFIG_FILE="${SCRIPT_ROOT}/elasticsearch.yml"

# If there is a linked Elasticsearch container, use it's host.
# If there isn't a link, use ES_HOST if it is defined.
# Otherwise fall back to 127.0.0.1.
#
function es_service_host() {
    local default_host=${ES_HOST:-127.0.0.1}
    local host=${ES_PORT_9200_TCP_ADDR:-$default_host}

    echo "$host"
}

# If there is a linked Elasticsearch container, use it's port.
# If there isn't a link, use ES_PORT if it is defined.
# Otherwise fall back to 9200.
#
function es_service_port() {
    local default_port=${ES_PORT:-9200}
    local port=${ES_PORT_9200_TCP_PORT:-$default_port}

    echo "$port"
}

function es_service_embedded() {
    local embedded=false

    if [ "$(es_service_host)" = "127.0.0.1" ] ; then
        embedded=true
    fi

    echo "$embedded"
}

function elasticsearch_disable_dynamic() {
    local config_file="$ES_CONFIG_FILE"

    if [ ! -f "$config_file" ]; then
        cat > "$config_file" << EOF
---
script.disable_dynamic: true
EOF
    fi
}

if [[ -z "$(es_service_host)" ]]; then
    echo "An Elasticsearch service host string is required." >&2
    exit 1
fi

if [[ -z "$(es_service_port)" ]]; then
    echo "An Elasticsearch service port string is required." >&2
    exit 1
fi

if [[ -z "$(es_service_embedded)" ]]; then
    echo "An Elasticsearch embedded boolean value is required." >&2
    exit 1
fi
