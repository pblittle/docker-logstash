NAME = pblittle/docker-logstash
VERSION = 0.1.0

ES_HOST ?= 127.0.0.1
ES_PORT ?= 9200

build:
	docker build -rm -t $(NAME):$(VERSION) .

run:
	docker run -d \
		-e JAVA_OPTS=-Xmx128M \
		-e ES_HOST=${ES_HOST} \
		-e ES_PORT=${ES_PORT} \
		-p 514:514 \
		-p ${ES_PORT}:${ES_PORT} \
		-p 9292:9292 \
		-name logstash \
		$(NAME):$(VERSION)

tag:
	docker tag $(NAME):$(VERSION) $(NAME):latest

release:
	docker push $(NAME)

shell:
	docker run -t -i -rm $(NAME):$(VERSION) bash

stop:
	docker stop $(NAME):$(VERSION)

clean:
	docker rmi $(NAME):$(VERSION)
