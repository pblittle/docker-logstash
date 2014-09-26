# docker-logstash

This is a highly configurable logstash (1.4.2) image running elasticsearch (1.1.1) and Kibana 3 (3.0.1).

## Optional, build and run the image from source

If you prefer to build from source rather than use the [pblittle/docker-logstash][1] trusted build published to the public Docker Registry, execute the following:

    $ git clone https://github.com/pblittle/docker-logstash.git
    $ cd docker-logstash
    $ make build
    $ make <options> run

See below for a complate example using `Vagrant`.

## Running Logstash

### First, prepare your Logstash configuration file

The logstash configuration file used in this container is downloaded from the internet using `wget`. The configuration file location is determined by the value of the `LOGSTASH_CONFIG_FILE` environment variable, which is set using the `-e` flag when executing `docker run`.

Unless `LOGSTASH_CONFIG_FILE` is overridden, an [example configuration file][2] for an embedded Elasticsearch will be downloaded, moved to `/opt/logstash.conf`, and used in your container.

I have created two reference config files that can be used for testing:

 * [Embedded Elasticsearch server](https://gist.githubusercontent.com/pblittle/8778567/raw/logstash.conf) (default)
 * [Linked Elasticsearch container](https://gist.githubusercontent.com/pblittle/0b937485fa4a322ea9eb/raw/logstash_linked.conf)

You will find example usage using `-e LOGSTASH_CONFIG_URL=<your_logstash_config_url>` below.

### Second, choose an Elasticsearch install type

To run this logstash image, you have to first choose one of three Elasticsearch configurations.

 * Use the embedded Elasticsearch server
 * Use a linked container running Elasticsearch
 * Use an external Elasticsearch server

### Use the embedded Elasticsearch server

To fetch and start a container running logstash and the embedded Elasticsearch server, simply execute:

    $ docker run -d \
      -p 9292:9292 \
      -p 9200:9200 \
      pblittle/docker-logstash

If you want to use your own config file rather than the default, don't forget the `LOGSTASH_CONFIG_URL` environment variable as noted above:

    $ docker run -d \
      -e LOGSTASH_CONFIG_URL=<your_logstash_config_url> \
      -p 9292:9292 \
      -p 9200:9200 \
      pblittle/docker-logstash

### Use a linked container running Elasticsearch

If you want to link to another container running elasticsearch rather than use the embedded server:

    $ docker run -d \
      -e LOGSTASH_CONFIG_URL=<your_logstash_config_url> \
      --link <your_es_container_name>:es
      -p 9292:9292
      -p 9200:9200
      pblittle/docker-logstash

To have you the linked elasticsearch container's `bind_host` and `port` automatically detected, you will need to create an `ES_HOST` and `ES_PORT` placeholder in the `elasticsearch` definition in your logstash config file. For example:

    output {
      elasticsearch {
        bind_host => "ES_HOST"
        port => "ES_PORT"
      }
    }

I have created an [example linked config file](https://gist.githubusercontent.com/pblittle/0b937485fa4a322ea9eb/raw/logstash_linked.conf) which includes the `ES_HOST` and `ES_PORT` placeholders described above.

### Use an external Elasticsearch server

If you are using an external elasticsearch server rather than the embedded server or a linked container, simply provide a configuration file with the Elasticsearch endpoints already configured:

    $ docker run -d \
      -e LOGSTASH_CONFIG_URL=<your_logstash_config_url> \
      -p 9292:9292
      -p 9200:9200
      pblittle/docker-logstash

### Finally, verify the installation

You can now verify the logstash installation by visiting the prebuilt logstash dashboard:

    http://<your_container_ip>:9292/index.html#/dashboard/file/logstash.json

## Test locally using Vagrant

To build the image locally using Vagrant, you will first need to clone the repository:

    $ git clone https://github.com/pblittle/docker-logstash.git
    $ cd docker-logstash

Start and provision a virtual machine using the provided Vagrantfile:

    $ vagrant up
    $ vagrant ssh
    $ cd /vagrant

From there, build and run a container using the newly created virtual machine:

    $ make build
    $ make <options> run

You can now verify the logstash installation by visiting the [prebuilt logstash dashboard][3] running in the newly created container.

## Acknowledgements

Special shoutout to @ehazlett's excellent post, [Logstash and Kibana3 via Docker][4].

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

This application is distributed under the [Apache License, Version 2.0][5].

[1]: https://registry.hub.docker.com/u/pblittle/docker-logstash
[2]: https://gist.github.com/pblittle/8778567/raw/logstash.conf
[3]: http://192.168.33.10:9292/index.html#/dashboard/file/logstash.json
[4]: http://ehazlett.github.io/applications/2013/08/28/logstash-kibana/
[5]: http://www.apache.org/licenses/LICENSE-2.0
