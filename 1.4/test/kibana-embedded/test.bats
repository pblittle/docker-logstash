#!/usr/bin/env bats

@test "Kibana's elasticsearch server is 'https://"+window.location.hostname+":9200'" {
    run grep 'https://"+window.location.hostname+":9200' \
        /opt/logstash/vendor/kibana/config.js

    [ "$status" -eq 0 ]
}
