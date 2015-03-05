NAME = pblittle/docker-logstash-test
VERSION = 0.13.0-dev

BUILD_SRC = ${CURDIR}/../base

default: test

.PHONY: build
build:
	docker build --rm -t pblittle/docker-logstash:$(VERSION) $(BUILD_SRC)

.PHONY: test
test: test-elasticsearch-embedded test-elasticsearch-linked

.PHONY: test-elasticsearch-embedded
test-elasticsearch-embedded: build

	cd ${CURDIR}/elasticsearch-embedded && \
	fig stop && \
	fig rm && \
	fig build && \
	fig up

.PHONY: test-elasticsearch-linked
test-elasticsearch-linked: build

	cd ${CURDIR}/elasticsearch-linked && \
	fig stop && \
	fig rm && \
	fig build && \
	fig up

.PHONY: test-logstash-configtest
test-logstash-configtest: build

	cd ${CURDIR}/logstash-configtest && \
	fig stop && \
	fig rm && \
	fig build && \
	fig up
