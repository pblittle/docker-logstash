#!/bin/bash

# Fail fast, including pipelines
set -e -o pipefail

function forwarder_create_ssl_dir() {
    local ssl_dir="$LF_SSL_DIR"

    if ! mkdir -p "${ssl_dir}" ; then
        echo "Unable to create ${ssl_dir}" >&2
    fi
}

function forwarder_download_cert() {
    if [ ! -s "$LF_SSL_CERT_FILE" ]; then
        wget "$LF_SSL_CERT_URL" -O "$LF_SSL_CERT_FILE"
    fi
}

function forwarder_download_key() {
    if [ ! -s "$LF_SSL_CERT_KEY_FILE" ]; then
        wget "$LF_SSL_CERT_KEY_URL" -O "$LF_SSL_CERT_KEY_FILE"
    fi
}
