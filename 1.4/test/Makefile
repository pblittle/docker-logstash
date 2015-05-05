NAME = pblittle/docker-logstash-test
VERSION = 0.16.0-SNAPSHOT

BUILD_SRC = ${CURDIR}/../base

.PHONY: build
build:
	docker build --rm -t pblittle/docker-logstash:$(VERSION) $(BUILD_SRC)

.PHONY: test-elasticsearch-embedded
test-elasticsearch-embedded: build

	cd ${CURDIR}/elasticsearch-embedded && \
	docker-compose stop && \
	docker-compose rm && \
	docker-compose build && \
	docker-compose up

.PHONY: test-elasticsearch-linked
test-elasticsearch-linked: build

	cd ${CURDIR}/elasticsearch-linked && \
	docker-compose stop && \
	docker-compose rm && \
	docker-compose build && \
	docker-compose up

.PHONY: test-kibana-embedded
test-kibana-embedded: build

	cd ${CURDIR}/kibana-embedded && \
	docker-compose stop && \
	docker-compose rm && \
	docker-compose build && \
	docker-compose up

.PHONY: test-logstash-configtest
test-logstash-configtest: build

	cd ${CURDIR}/logstash-configtest && \
	docker-compose stop && \
	docker-compose rm && \
	docker-compose build && \
	docker-compose up

.PHONY: test-logstash-tarball-config
test-logstash-tarball-config: build

	cd ${CURDIR}/logstash-tarball-config && \
	docker-compose stop && \
		docker-compose rm && \
	docker-compose build && \
	docker-compose up
