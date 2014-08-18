This is a logstash (1.4.2) image that is configurable to run using either the embedded elasticsearch or an elasticsearch node running in a separate container.

To fetch and start a container running logstash (1.4.2), elasticsearch (1.1.1) and Kibana 3 (3.0.1), simply:

	docker run -d \
	  --name logstash \
	  -p 514:514 \
	  -p 9200:9200 \
	  -p 9292:9292 \
	  pblittle/docker-logstash

If you want to link to an external elasticsearch container rather than the embedded server, add a link flag with your existing elasticsearch container's name. For example, to link to a container named `elasticsearch`:

	docker run -d \
	  --name logstash \
	  -link elasticsearch:es \
	  -p 514:514 \
	  -p 9292:9292 \
	  pblittle/docker-logstash

In addition to the link, if you want your elasticsearch node's `bind_host` and `port` automatically detected, you will need to set `ES_HOST` and `ES_PORT` placeholders in your `elasticsearch` definition in your logstash config file.

	output {
	  stdout {
	    codec => rubydebug
	    debug => true
	    debug_format => "json"
	  }

	  elasticsearch {
	    bind_host => "ES_HOST"
	    port => "ES_PORT"
	  }
	}

Alternatively, you can replace the placeholder values with the real elasticsearch `bind_host` and `port` values.

Without any configuration changes, an example `logstash.conf` will be created for you. You can override the example config by passing a `LOGSTASH_CONFIG_URL` env var in your `docker run` command using a `-e` flag pointing to your config file.

    docker run -d \
      --name logstash \
	  -p 514:514 \
	  -p 9292:9292 \
	  -e LOGSTASH_CONFIG_URL=https://gist.github.com/pblittle/8778567/raw/logstash.conf \
	  pblittle/docker-logstash

To build the image locally using Vagrant, perform the following steps from the project root:

    vagrant up
    vagrant ssh
    cd /vagrant

From there, to build and create a running container from the newly created image:

    make build
    make run

Special shoutout to ehazlett's excellent post, [Logstash and Kibana3 via Docker][1], explaining the big picture.

  [1]: http://ehazlett.github.io/applications/2013/08/28/logstash-kibana/

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

This application is distributed under the
[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
