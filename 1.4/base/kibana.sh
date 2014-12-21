#!/bin/bash

# Fail fast, including pipelines
set -e -o pipefail

# Set LOGSTASH_TRACE to enable debugging
[[ $LOGSTASH_TRACE ]] && set -x

kibana_port() {
    local default_port=${KIBANA_PORT_9292_TCP_PORT:-9292}
    local port=${KIBANA_PORT:-$default_port}

    echo "$port"
}

if [[ -z "$(kibana_port)" ]]; then
    echo "A kibana port is required." >&2
    exit 1
fi
