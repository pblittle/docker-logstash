# docker-logstash

This is a logstash (1.4.2) image that can be configured to run using either the embedded elasticsearch server, a linked container, or an external server.

## Optional step, build image from source

If you prefer to build from source rather than use the [pblittle/docker-logstash][1] trusted build published to the public Docker Registry, execute:

    $ make build

## Run Logstash

### Use the embedded Elasticsearch server

To fetch and start a container running logstash (1.4.2), elasticsearch (1.1.1) and Kibana 3 (3.0.1), simply:

    $ make run

### Use a linked Elasticsearch container

If you want to link to another container running elasticsearch rather than the embedded server, set the `ES_CONTAINER` environment variable to your existing elasticsearch container name.

    $ ES_CONTAINER=<your_es_container>
    $ make run

In addition to the link, if you want your elasticsearch node's `bind_host` and `port` automatically detected, you will need to set the `ES_HOST` and `ES_PORT` placeholders in your `elasticsearch` definition in your logstash config file. For example:

    output {
      elasticsearch {
        bind_host => "ES_HOST"
        port => "ES_PORT"
      }
    }

### Use an external Elasticsearch server

If you are using an external elasticsearch server rather than an embedded or linked server, simply set the `ES_HOST` and `ES_PORT` environment variables.

    $ ES_HOST=<your_es_host>
    $ ES_PORT=<your_es_port>
    $ make run

## Logstash configuration

Without any environment changes, an [example configuration file][2] will be created for you. You can override the example config by setting the `LOGSTASH_CONFIG_URL` environment variable to a file accessible via `wget`.

## Test locally using Vagrant

To build the image locally using Vagrant, perform the following steps from the project root:

    $ vagrant up
    $ vagrant ssh
    $ cd /vagrant

From there, build and run a container using the newly created virtual machine:

    $ make build
    $ make run

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
