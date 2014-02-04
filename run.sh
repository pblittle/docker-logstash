#!/bin/bash

set -e

exec java \
     -jar /opt/logstash.jar \
     agent \
     --config /opt/logstash.conf \
     -- \
     web
