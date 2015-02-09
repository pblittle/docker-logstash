NAME = pblittle/docker-logstash
VERSION = 0.11.0

# Set the LOGSTASH_CONFIG_URL env var to your logstash.conf file.
# We will use our basic config if the value is empty.
#
LOGSTASH_CONFIG_URL ?= https://gist.githubusercontent.com/pblittle/1b7a2f02cd16fa1c58e9/raw/logstash_nxt.conf

# Set the default Elasticsearch protocol, host, and port. This will
# replace the values in kibana config.js.
#
ES_HOST ?= 127.0.0.1
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
-p ${ES_PORT}:${ES_PORT} \
-p 9292:9292
endef

ifdef ES_CONTAINER
	docker_run_flags += --link $(ES_CONTAINER):es
endif

.PHONY: build
build:
	docker build --rm -t $(NAME):$(VERSION) ./base

.PHONY: run
run:
	docker run -d $(docker_run_flags) --name logstash $(NAME):$(VERSION)

.PHONY: shell
shell:
	docker exec -ti logstash /bin/bash

.PHONY: test
test:
	docker build --rm -t $(NAME):$(VERSION) ./test
	docker run -d $(docker_run_flags) --name logstash-test $(NAME):$(VERSION)

.PHONY: tag
tag:
	docker tag $(NAME):$(VERSION) $(NAME):latest

.PHONY: release
release:
	docker push $(NAME)
