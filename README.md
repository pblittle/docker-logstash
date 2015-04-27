> Note: This release stores logstash config files in `/opt/logstash/conf.d/`. Please update any references to `/opt/logstash.conf` in your existing deployment configs. `/opt/logstash/conf.d/` will be used from this release, `0.11.0`, forward.

# Logstash Dockerfile

This is a highly configurable [logstash][7] (1.4.2) image running [Elasticsearch][8] (1.1.1) and [Kibana][9] (3.0.1).

## How to use this image

To run the image, you have to first decide on one of three Elasticsearch configurations:

 * Use the embedded Elasticsearch server
 * Use a linked container running Elasticsearch
 * Use an external Elasticsearch server

### Embedded Elasticsearch server

By default, an example [logstash.conf][2] will be downloaded using `wget` and used in your container.

    $ docker run -d \
      -p 9292:9292 \
      -p 9200:9200 \
      pblittle/docker-logstash

To use your own config file, set the `LOGSTASH_CONFIG_URL` environment variable using the `-e` flag as follows:

    $ docker run -d \
      -e LOGSTASH_CONFIG_URL=<your_logstash_config_url> \
      -p 9292:9292 \
      -p 9200:9200 \
      pblittle/docker-logstash

To use config files from the local file system, mount the directory as a volume using the `-v` flag. Any file in `/opt/logstash/conf.d` in the container will get loaded by logstash.

    $ docker run -d \
      -v <your_logstash_config_dir>:/opt/logstash/conf.d \
      -p 9292:9292 \
      -p 9200:9200 \
      pblittle/docker-logstash

### Linked container running Elasticsearch

If you want to link to a container running Elasticsearch rather than use the embedded Elasticsearch server:

    $ docker run -d \
      --link <your_es_container_name>:es \
      -p 9292:9292 \
      pblittle/docker-logstash

To have the linked Elasticsearch container's `bind_host` and `port` automatically detected, you will need to set the `bind_host` and `port` to `ES_HOST` and `ES_PORT` respectively in your logstash config file. For example:

    output {
      elasticsearch {
        bind_host => "ES_HOST"
        port => "ES_PORT"
      }
    }

### External Elasticsearch server

If you are using an external Elasticsearch server, simply set the `ES_HOST` and `ES_PORT` environment variables in your `run` command:

    $ docker run -d \
      -e ES_HOST=<your_es_service_host> \
      -e ES_PORT=<your_es_service_port> \
      -p 9292:9292 \
      pblittle/docker-logstash

## Optional, build and run the image from source

If you prefer to build from source rather than use the [pblittle/docker-logstash][1] trusted build published to the public Docker Registry, execute the following:

    $ git clone https://github.com/pblittle/docker-logstash.git
    $ cd docker-logstash

> If you are using [Vagrant][3], you can build and run the container in a VM by executing:
>
>     $ vagrant up
>     $ vagrant ssh
>     $ cd /vagrant/1.4

From there, build and run a container using the newly created virtual machine:

    $ make

### Finally, verify the installation

You can now verify the logstash installation by visiting the Kibana dashboard:

    http://<your_container_ip>:9292/index.html#/dashboard/file/logstash.json

## Acknowledgements

Special shoutout to @ehazlett's excellent post, [logstash and Kibana via Docker][4].

## Contributing

1. Fork it
2. Checkout the develop branch (`git checkout -b develop`)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

## License

This application is distributed under the [Apache License, Version 2.0][5].

[1]: https://registry.hub.docker.com/u/pblittle/docker-logstash
[2]: https://gist.githubusercontent.com/pblittle/8778567/raw/logstash.conf
[3]: https://www.vagrantup.com
[4]: http://ehazlett.github.io/applications/2013/08/28/logstash-kibana/
[5]: http://www.apache.org/licenses/LICENSE-2.0
[7]: http://logstash.net
[8]: http://www.elasticsearch.org/overview/elasticsearch
[9]: http://www.elasticsearch.org/overview/kibana
