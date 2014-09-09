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

port_check=`netstat -an | grep ':9292\|:9200'`
port_status=$?

if [[ $port_status != 0 || $port_check = '' ]]; then
    print_fail port_check
else
    print_pass port_check
fi

process_check=`ps -ef | grep 'logstash' | grep -v grep`
process_status=$?

if [[ $process_status != 0 || $process_check = '' ]]; then
    print_fail process_check
else
    print_pass process_check
fi

curl_check=`curl -s -S localhost:9200/_nodes?pretty=true`
curl_status=$?

if [[ $curl_status != 0 || $curl_check = '' ]]; then
    print_fail curl_check
else
    print_pass curl_check
fi
