NAME = pblittle/docker-logstash
VERSION = 0.5.0

# Set the LOGSTASH_CONFIG_URL env var to your logstash.conf file.
# We will use our basic config if the value is empty.
LOGSTASH_CONFIG_URL ?= https://gist.github.com/pblittle/8778567/raw/logstash.conf

# This default host and port are for using the embedded elasticsearch
# in LogStash. Set the ES_HOST and ES_PORT to use a node outside of
# this container
#
ES_HOST ?= 127.0.0.1
ES_PORT ?= 9200

# The default logstash-forwarder keys are insecure. Please do not use in production.
# Set the LF_SSL_CERT_KEY_URL and LF_SSL_CERT_URL env vars to use your secure keys.
#
LF_SSL_CERT_KEY_URL ?= https://gist.github.com/pblittle/8994708/raw/insecure-logstash-forwarder.key
LF_SSL_CERT_URL ?= https://gist.github.com/pblittle/8994726/raw/insecure-logstash-forwarder.crt

build:
	docker build --rm -t $(NAME):$(VERSION) .

run:
	docker run -d \
		-e LOGSTASH_CONFIG_URL=${LOGSTASH_CONFIG_URL} \
		-e ES_HOST=${ES_HOST} \
		-e ES_PORT=${ES_PORT} \
		-e LF_SSL_CERT_URL=${LF_SSL_CERT_URL} \
		-e LF_SSL_CERT_KEY_URL=${LF_SSL_CERT_KEY_URL} \
		-p ${ES_PORT}:${ES_PORT} \
		-p 514:514 \
		-p 9292:9292 \
		--name logstash \
		$(NAME):$(VERSION)

tag:
	docker tag $(NAME):$(VERSION) $(NAME):latest

release:
	docker push $(NAME)

shell:
	docker run -t -i --rm $(NAME):$(VERSION) bash
