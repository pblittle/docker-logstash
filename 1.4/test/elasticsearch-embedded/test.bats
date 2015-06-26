#!/usr/bin/env bats

@test "Logstash is running" {
    run pgrep -f logstash

    [ "$status" -eq 0 ]
}

@test "Logstash.config contains '{ elasticsearch { embedded => true }'" {
    run grep -r 'embedded => true' /opt/logstash/conf.d

    [ "$status" -eq 0 ]
}

@test "Elasticsearch.yml contains 'http.cors.enabled: true'" {
    run grep 'http.cors.enabled: true' /app/elasticsearch.yml

    [ "$status" -eq 0 ]
}

@test "Elasticsearch.yml contains 'http.cors.allow-origin: "/.*/"'" {
    run grep 'http.cors.allow-origin: "/.*/"' /app/elasticsearch.yml

    [ "$status" -eq 0 ]
}

@test "Kibana's elasticsearch server is 'http://"+window.location.hostname+":9200'" {
    run grep 'http://"+window.location.hostname+":9200' /opt/logstash/vendor/kibana/config.js

    [ "$status" -eq 0 ]
}

@test "Elasticsearch is listening on port '9200'" {
    netstat -an | grep ':9200'
}

@test "Elasticsearch is listening on port '9300'" {
    netstat -an | grep ':9300'
}

@test "Kibana is listening on port '9292'" {
    netstat -plant | grep ':9292'
}

@test "Elasticsearch is reachable at '/_status'" {
    run curl -i http://127.0.0.1:9200/_status

    [ "$status" -eq 0 ]
    [[ "$output" =~ "HTTP/1.1 200 OK" ]]
}

@test "Kibana dashboard reachable at '/index.html'" {
    run curl -i http://127.0.0.1:9292/index.html

    [ "$status" -eq 0 ]
    [[ "$output" =~ "HTTP/1.1 200 OK" ]]
}
