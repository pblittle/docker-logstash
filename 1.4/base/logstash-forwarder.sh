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
    local ssl_cert_file="$LF_SSL_CERT_FILE"
    local ssl_cert_url="$LF_SSL_CERT_URL"

    if [ ! -s "${ssl_cert_file}" ]; then
        wget "${ssl_cert_url}" -O "${ssl_cert_file}"
    fi
}

function forwarder_download_key() {
    local ssl_cert_key_file="$LF_SSL_CERT_KEY_FILE"
    local ssl_cert_key_url="$LF_SSL_CERT_KEY_URL"

    if [ ! -s "${ssl_cert_key_file}" ]; then
        wget "${ssl_cert_key_url}" -O "${ssl_cert_key_file}"
    fi
}
