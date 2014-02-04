build:
	docker build -t pblittle/logstash .

run:
	docker run -d \
		-e JAVA_OPTS=-Xmx128M \
		-p 514:514 \
		-p 9292:9292 \
		-v /mnt/logstash:/logstash \
		pblittle/logstash

shell:
	docker run -t -i -rm pblittle/logstash /bin/bash

stop:
	docker stop pblittle/logstash

clean:
	docker rmi pblittle/logstash
