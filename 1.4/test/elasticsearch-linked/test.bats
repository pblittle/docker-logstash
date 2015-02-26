#!/usr/bin/env bats

@test "Logstash is running" {
    run pgrep -f logstash

    [ "$status" -eq 0 ]
}

@test "Logstash.config contains '{ elasticsearch { embedded => false }'" {
    run grep 'embedded => false' /opt/logstash/conf.d/logstash.conf

    [ "$status" -eq 0 ]
}

@test "Elasticsearch.yml contains 'script.disable_dynamic: true'" {
    run grep 'script.disable_dynamic: true' /app/elasticsearch.yml

    [ "$status" -eq 0 ]
}

@test "Elasticsearch is not listening on port '9200'" {
    skip 'The linked elasticsearch IP should be used here.'

    netstat -an | grep ':9200'

    [ "$status" -eq 1 ]
}

@test "Elasticsearch is not listening on port '9300'" {
    skip 'The linked elasticsearch IP should be used here.'

    netstat -an | grep ':9300'

    [ "$status" -eq 1 ]
}

@test "Elasticsearch is reachable at '/_status'" {
    skip 'The linked elasticsearch IP should be used here.'

    run curl -i http://127.0.0.1:9200/_status

    [ "$status" -eq 0 ]
    [[ "$output" =~ "HTTP/1.1 200 OK" ]]
}

@test "Kibana's elasticsearch server is 'http://"+window.location.hostname+":9200'" {
    run grep 'http://"+window.location.hostname+":9200' /opt/logstash/vendor/kibana/config.js

    [ "$status" -eq 0 ]
}

@test "Kibana is listening on port '9292'" {
    netstat -plant | grep ':9292'
}

@test "Kibana dashboard reachable at '/index.html'" {
    run curl -i http://127.0.0.1:9292/index.html

    [ "$status" -eq 0 ]
    [[ "$output" =~ "HTTP/1.1 200 OK" ]]
}
