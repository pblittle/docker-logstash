NAME = pblittle/docker-logstash
VERSION = 0.12.0

# Set the LOGSTASH_CONFIG_URL env var to your logstash.conf file.
# We will use our basic config if the value is empty.
#
LOGSTASH_CONFIG_URL ?= https://gist.githubusercontent.com/pblittle/8778567/raw/logstash.conf

# Set the default Elasticsearch protocol, host, and port. This will
# replace the ES_HOST and ES_PORT values in the logstash config.
# It will also replace ES_HOST, ES_PORT, and ES_PROTOCOL in kibana config.js.
#
ES_HOST ?=
ES_PORT ?= 9200
ES_PROTOCOL ?= http

# The default logstash-forwarder keys are insecure. Please do not use in production.
# Set the LF_SSL_CERT_KEY_URL and LF_SSL_CERT_URL env vars to use your secure keys.
#
LF_SSL_CERT_KEY_URL ?= https://gist.githubusercontent.com/pblittle/8994708/raw/insecure-logstash-forwarder.key
LF_SSL_CERT_URL ?= https://gist.githubusercontent.com/pblittle/8994726/raw/insecure-logstash-forwarder.crt

define docker_run_flags
-e LOGSTASH_CONFIG_URL=${LOGSTASH_CONFIG_URL} \
-e ES_HOST=${ES_HOST} \
-e ES_PORT=${ES_PORT} \
-e ES_PROTOCOL=${ES_PROTOCOL} \
-e LF_SSL_CERT_URL=${LF_SSL_CERT_URL} \
-e LF_SSL_CERT_KEY_URL=${LF_SSL_CERT_KEY_URL} \
-p 9292:9292
endef

ifdef ES_CONTAINER
	docker_run_flags += --link $(ES_CONTAINER):es
endif

ifdef ES_PORT
	docker_run_flags += -p $(ES_PORT):$(ES_PORT)
endif

.PHONY: default
default: build run

.PHONY: build
build:
	docker build --rm -t $(NAME):$(VERSION) ./base

.PHONY: run
run:
	docker run -d --name logstash $(docker_run_flags) $(NAME):$(VERSION)

.PHONY: shell
shell:
	docker exec -ti logstash /bin/bash

.PHONY: test-prepare
test-prepare: build
	docker build --rm -t $(NAME)-test:$(VERSION) ./test
	docker run -d --name logstash-test -p 9292:9292 -p 9200:9200 $(NAME)-test:$(VERSION)

.PHONY: test
test:
	docker exec -ti logstash-test /usr/local/bin/bats /app/test/embedded.bats

.PHONY: test-shell
test-shell:
	docker exec -ti logstash-test /bin/bash

.PHONY: tag
tag:
	docker tag $(NAME):$(VERSION) $(NAME):latest

.PHONY: release
release:
	docker push $(NAME)
