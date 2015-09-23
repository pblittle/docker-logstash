NAME = pblittle/docker-logstash-test
VERSION = 0.21.0-SNAPSHOT

BUILD_SRC = ${CURDIR}/../base

.PHONY: build
build:
	docker build --rm -t pblittle/docker-logstash:$(VERSION) $(BUILD_SRC)

.PHONY: test-elasticsearch-embedded
test-elasticsearch-embedded: build

	cd ${CURDIR}/elasticsearch-embedded && \
.PHONY: test
test:
	cd ${TESTDIR} && \
	docker-compose stop && \
	docker-compose rm --force && \
	docker-compose build && \
	docker-compose up --no-recreate

.PHONY: test-elasticsearch-linked
test-elasticsearch-linked: build

	cd ${CURDIR}/elasticsearch-linked && \
	docker-compose stop && \
	docker-compose rm --force && \
	docker-compose build && \
	docker-compose up --no-recreate

.PHONY: test-kibana-embedded
test-kibana-embedded: build

	cd ${CURDIR}/kibana-embedded && \
	docker-compose stop && \
	docker-compose rm --force && \
	docker-compose build && \
	docker-compose up --no-recreate

.PHONY: test-logstash-configtest
test-logstash-configtest: build

	cd ${CURDIR}/logstash-configtest && \
	docker-compose stop && \
	docker-compose rm --force && \
	docker-compose build && \
	docker-compose up --no-recreate

.PHONY: test-logstash-tarball-config
test-logstash-tarball-config: build

	cd ${CURDIR}/logstash-tarball-config && \
	docker-compose stop && \
	docker-compose rm --force && \
	docker-compose build && \
	docker-compose up --no-recreate
.PHONY: test-logstash-forwarder
test-logstash-forwarder: build
	$(MAKE) -e TESTDIR=${CURDIR}/logstash-forwarder test
