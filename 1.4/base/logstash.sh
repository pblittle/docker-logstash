#!/bin/bash

# Fail fast, including pipelines
set -euo pipefail

# Set LOGSTASH_TRACE to enable debugging
[[ $LOGSTASH_TRACE ]] && set -x

# If you don't provide a value for the LOGSTASH_CONFIG_URL env
# var, your install will default to our very basic logstash.conf file.
#
LOGSTASH_DEFAULT_CONFIG_URL='https://gist.githubusercontent.com/pblittle/8778567/raw/logstash.conf'
LOGSTASH_CONFIG_URL=${LOGSTASH_CONFIG_URL:-${LOGSTASH_DEFAULT_CONFIG_URL}}

LOGSTASH_SRC_DIR='/opt/logstash'

LOGSTASH_CONFIG_DIR="${LOGSTASH_SRC_DIR}/conf.d"
LOGSTASH_CONFIG_FILE="${LOGSTASH_CONFIG_DIR}/logstash.conf"

LOGSTASH_BINARY="${LOGSTASH_SRC_DIR}/bin/logstash"

LOGSTASH_LOG_DIR='/var/log/logstash'
LOGSTASH_LOG_FILE="${LOGSTASH_LOG_DIR}/logstash.log"

function __download_config() {
    local url="$1"
    local dir="$2"

    cd "${dir}" \
        && curl -Os "${url}"
}

function __download_tar() {
    : # no-op
}

function __download_zip() {
    : # no-op
}

function __download_git() {
    : # no-op
}

# Replaces ES_EMBEDDED, ES_HOST, and ES_PORT in your logstash.conf
# file if they exist with the IP and port dynamically generated
# by docker. If the host is 127.0.0.1, ES_EMBEDDED will be true.
#
# Note: Don't use this on a file mounting using a docker
# volume, as the inode switch will cause `device or resource busy`
# Instead download your file as normal
#
function __sanitize_config() {
    local config="$LOGSTASH_CONFIG_FILE"
    local -r embedded="$(es_service_embedded)"
    local -r host="$(es_service_host)"
    local -r port="$(es_service_port)"

    if [ -f "$config" ]; then
        sed -e "s|ES_EMBEDDED|${embedded}|g" \
            -e "s|ES_HOST|${host}|g" \
            -e "s|ES_PORT|${port}|g" \
            -i "${config}"
    else
        echo "${config} does not exist"
    fi
}

# Create the logstash conf dir if it doesn't already exist
#
function logstash_create_config_dir() {
    local config_dir="$LOGSTASH_CONFIG_DIR"

    if ! mkdir -p "${config_dir}" ; then
        echo "Unable to create ${config_dir}" >&2
    fi
}

# Download the logstash configs if the config directory is empty
#
function logstash_download_config() {
    local url="$LOGSTASH_CONFIG_URL"
    local dir="$LOGSTASH_CONFIG_DIR"

    if [ ! "$(ls -A $dir)" ]; then
        case "$url" in
            *.conf|*.json)
                __download_config "$url" "$dir"
                ;;
            *.tar|*.tar.gz|*.tgz)
                __download_tar "$url" "$dir"
                ;;
            *.war|*.zip)
                __download_zip "$url" "$dir"
                ;;
            *.git)
                __download_git "$url" "$dir"
                ;;
        esac

        __sanitize_config
    fi
}

function logstash_create_log_dir() {
    local log_dir="$LOGSTASH_LOG_DIR"

    if ! mkdir -p "${log_dir}" ; then
        echo "Unable to create ${log_dir}" >&2
    fi
}

function logstash_start_agent() {
    local binary="$LOGSTASH_BINARY"
    local config_dir="$LOGSTASH_CONFIG_DIR"
    local log_file="$LOGSTASH_LOG_FILE"

    case "$1" in
    # run just the agent
    'agent')
        exec "$binary" \
             agent \
             --config "$config_dir" \
             --log "$log_file" \
             --
        ;;
    # test the logstash configuration
    'configtest')
        exec "$binary" \
             agent \
             --config "$config_dir" \
             --log "$log_file" \
             --configtest \
             --
        ;;
    # run just the web
    'web')
        exec "$binary" \
             web
        ;;
    # run agent+web (default operation)
    *)
        exec "$binary" \
             agent \
             --config "$config_dir" \
             --log "$log_file" \
             -- \
             web
        ;;
    esac
}
