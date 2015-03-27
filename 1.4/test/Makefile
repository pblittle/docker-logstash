NAME = pblittle/docker-logstash-test
VERSION = 0.13.1

BUILD_SRC = ${CURDIR}/../base

.PHONY: build
build:
	docker build --rm -t pblittle/docker-logstash:$(VERSION) $(BUILD_SRC)

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

.PHONY: test-kibana-embedded
test-kibana-embedded: build

	cd ${CURDIR}/kibana-embedded && \
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
