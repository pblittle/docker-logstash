#!/bin/bash

[[ $LOGSTASH_TRACE ]] && set -x

function print_pass()
{
    echo "Pass: ${1}"
}

function print_fail()
{
    echo "Fail: ${1}"
}

function logstash_process_check() {
    local check=$(pgrep -f logstash)
    local status=$?

    if [[ $status != 0 || $check = '' ]]; then
        print_fail $?
    else
        print_pass $?
    fi
}

function es_embedded_check() {
    local check=$(grep 'embedded => true' /opt/logstash/conf.d/logstash.conf)
    local status=$?

    if [[ $status != 0 || $check = '' ]]; then
        print_fail $?
    else
        print_pass $?
    fi
}

function es_curl_check() {
    local check=$(curl -s -S localhost:9200/_nodes?pretty=true)
    local status=$?

    if [[ $status != 0 || $check = '' ]]; then
        print_fail $?
    else
        print_pass $?
    fi
}

function es_disable_dynamic_check() {
    local check=$(grep 'script.disable_dynamic: true' /app/elasticsearch.yml)
    local status=$?

    if [[ $status != 0 || $check = '' ]]; then
        print_fail $?
    else
        print_pass $?
    fi
}

function es_port_check() {
    local check=$(netstat -an | grep '\:9200')
    local status=$?

    if [[ $status != 0 || $check = '' ]]; then
        print_fail $?
    else
        print_pass $?
    fi
}

function kibana_port_check() {
    local check=$(netstat -an | grep '\:9292')
    local status=$?

    if [[ $status != 0 || $check = '' ]]; then
        print_fail $?
    else
        print_pass $?
    fi
}

function kibana_es_server_check() {
    local server='http://"+window.location.hostname+":9200'
    local check=$(grep ${server} /opt/logstash/vendor/kibana/config.js)
    local status=$?

    if [[ $status != 0 || $check = '' ]]; then
        print_fail $?
    else
        print_pass $?
    fi
}

function main() {
    logstash_process_check

    es_curl_check

    es_embedded_check

    es_disable_dynamic_check

    es_port_check

    kibana_port_check

    kibana_es_server_check
}

main "$@"
