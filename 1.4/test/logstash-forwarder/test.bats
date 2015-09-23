#!/usr/bin/env bats

ssl_cert_path() {
    echo '/opt/ssl/logstash-forwarder.crt'
}

ssl_key_path() {
    echo '/opt/ssl/logstash-forwarder.key'
}

@test 'logstash-forwarder.sh should create an SSL cert' {
    run ls -L "$(ssl_cert_path)"

    [ "$status" -eq 0 ]
}

@test 'logstash-forwarder.sh should create an SSL key' {
    run ls -L "$(ssl_key_path)"

    [ "$status" -eq 0 ]
}
