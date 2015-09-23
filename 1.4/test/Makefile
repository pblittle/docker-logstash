NAME = pblittle/docker-logstash-test
VERSION = 0.21.0-SNAPSHOT

BUILD_SRC = ${CURDIR}/../base

.PHONY: build
build:
	docker build --rm -t pblittle/docker-logstash:$(VERSION) $(BUILD_SRC)

.PHONY: test
test:
	cd ${TESTDIR} && \
	docker-compose stop && \
	docker-compose rm --force && \
	docker-compose build && \
	docker-compose up --no-recreate

.PHONY: test-elasticsearch-embedded
test-elasticsearch-embedded: build
	$(MAKE) -e TESTDIR=${CURDIR}/elasticsearch-embedded test

.PHONY: test-elasticsearch-linked
test-elasticsearch-linked: build
	$(MAKE) -e TESTDIR=${CURDIR}/elasticsearch-linked test

.PHONY: test-kibana-embedded
test-kibana-embedded: build
	$(MAKE) -e TESTDIR=${CURDIR}/kibana-embedded test

.PHONY: test-logstash-configtest
test-logstash-configtest: build
	$(MAKE) -e TESTDIR=${CURDIR}/logstash-configtest test

.PHONY: test-logstash-tarball-config
test-logstash-tarball-config: build
	$(MAKE) -e TESTDIR=${CURDIR}/logstash-tarball-config test

.PHONY: test-logstash-forwarder
test-logstash-forwarder: build
	$(MAKE) -e TESTDIR=${CURDIR}/logstash-forwarder test
