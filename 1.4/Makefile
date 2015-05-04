NAME = pblittle/docker-logstash
VERSION = 0.15.1

# Set the LOGSTASH_CONFIG_URL env var to your logstash.conf file.
# We will use our basic config if the value is empty.
#
LOGSTASH_CONFIG_URL ?= https://gist.githubusercontent.com/pblittle/8778567/raw/logstash.conf

# Set the default Elasticsearch host and port. This will replace the ES_HOST
# and ES_PORT values in your logstash config.
#
ES_SERVICE_HOST ?=
ES_SERVICE_PORT ?= 9200

# Set the default Elasticsearch proxy host, port, and protocol. This will
# replace the ES_PROXY_HOST, ES_PROXY_PORT, and ES_PROXY_PROTOCOL values in
# the embedded kibana config.
#
ES_PROXY_HOST ?=
ES_PROXY_PORT ?= 9292
ES_PROXY_PROTOCOL ?=

# The default logstash-forwarder keys are insecure. Please do not use in production.
# Set the LF_SSL_CERT_KEY_URL and LF_SSL_CERT_URL env vars to use your secure keys.
#
LF_SSL_CERT_KEY_URL ?= https://gist.githubusercontent.com/pblittle/8994708/raw/insecure-logstash-forwarder.key
LF_SSL_CERT_URL ?= https://gist.githubusercontent.com/pblittle/8994726/raw/insecure-logstash-forwarder.crt

define docker_run_flags
-e LOGSTASH_CONFIG_URL=${LOGSTASH_CONFIG_URL} \
-e ES_SERVICE_HOST=${ES_SERVICE_HOST} \
-e ES_PROXY_HOST=${ES_PROXY_HOST} \
-e ES_PROXY_PROTOCOL=${ES_PROXY_PROTOCOL} \
-e LF_SSL_CERT_URL=${LF_SSL_CERT_URL} \
-e LF_SSL_CERT_KEY_URL=${LF_SSL_CERT_KEY_URL}
endef

# This is not implemented yet. It will enable a custom link name when building
# from this Makefile. Bug me if you want it. :)
#
ifdef ES_CONTAINER
	docker_run_flags += --link $(ES_CONTAINER):es
endif

ifdef ES_SERVICE_PORT
	docker_run_flags += -e $(ES_SERVICE_PORT)=$(ES_SERVICE_PORT)
	docker_run_flags += -p $(ES_SERVICE_PORT):$(ES_SERVICE_PORT)
endif

ifdef ES_PROXY_PORT
	docker_run_flags += -e $(ES_PROXY_PORT)=$(ES_PROXY_PORT)
	docker_run_flags += -p $(ES_PROXY_PORT):$(ES_PROXY_PORT)
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

.PHONY: tag
tag:
	docker tag $(NAME):$(VERSION) $(NAME):latest

.PHONY: release
release:
	docker push $(NAME)
