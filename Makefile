build:
	docker build -rm=true -t pblittle/docker-logstash .

run:
	docker run -d \
		-e JAVA_OPTS=-Xmx128M \
		-p 514:514 \
		-p 9292:9292 \
		-v /mnt/logstash:/logstash \
		pblittle/docker-logstash

shell:
	docker run -t -i -rm pblittle/docker-logstash /bin/bash

stop:
	docker stop pblittle/docker-logstash

clean:
	docker rmi pblittle/docker-logstash
