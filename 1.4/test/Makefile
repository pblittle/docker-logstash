NAME = pblittle/docker-logstash-test
VERSION = 0.12.1-dev

BUILD_SRC = ${CURDIR}/../base

default: test

.PHONY: build
build:
	docker build --rm -t $(NAME):$(VERSION) $(BUILD_SRC)

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
