#!/bin/bash

set -eo pipefail

function print_pass()
{
    echo "Pass: ${1}"
}

function print_fail()
{
    echo "Fail: ${1}"
}

port_check=$(netstat -an | grep '\:9292\|\:9200')

if [[ $? != 0 || $? = '' ]]; then
    print_fail $?
else
    print_pass $?
fi

process_check=$(pgrep -f logstash)

if [[ $? != 0 || $? = '' ]]; then
    print_fail $?
else
    print_pass $?
fi

curl_check=$(curl -s -S localhost:9200/_nodes?pretty=true)

if [[ $? != 0 || $? = '' ]]; then
    print_fail $?
else
    print_pass $?
fi

test_kibana_es_protocol=$(grep 'http' /opt/logstash/vendor/kibana/config.js)

if [[ $? != 0 || $? = '' ]]; then
    print_fail $?
else
    print_pass $?
fi

test_kibana_es_host=$(grep '127.0.0.1' /opt/logstash/vendor/kibana/config.js)

if [[ $? != 0 || $? = '' ]]; then
    print_fail $?
else
    print_pass $?
fi

test_kibana_es_port=$(grep '9200' /opt/logstash/vendor/kibana/config.js)

if [[ $? != 0 || $? = '' ]]; then
    print_fail $?
else
    print_pass $?
fi

test_elasticsearch_config=$(grep 'script.disable_dynamic: true' /app/elasticsearch.yml)

if [[ $? != 0 || $? = '' ]]; then
    print_fail $?
else
    print_pass $?
fi
