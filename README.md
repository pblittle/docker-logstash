# Logstash Dockerfile

This is a highly configurable [logstash][7] (1.4.5) image running [Elasticsearch][8] (1.7.0) and [Kibana][9] (3.1.2).

## How to use this image

To run the image, you have to first decide which services you want to run in your container:

#### Full ELK stack (default)

````
$ docker run -d \
  -p 9292:9292 \
  -p 9200:9200 \
  pblittle/docker-logstash
````

#### Logstash agent only

````
$ docker run \
  pblittle/docker-logstash \
  agent
````

#### Logstash config test only

````
$ docker run \
  pblittle/docker-logstash \
  configtest
````

#### Embedded Kibana web interface only

````
$ docker run \
  pblittle/docker-logstash \
  web
````

## Logstash configuration

There are currently two supported ways of including your Logstash config files in your container:

  * Download your config files from the Internet
  * Mount a volume on the host machine containing your config files

> Any files in `/opt/logstash/conf.d` with the `.conf` extension will get loaded by logstash.

#### Download your config files from the Internet

To use your own hosted config files, your config files must be one of the following two file types:

  * A monolithic config file (`*.conf`)
  * A tarball containing your config files (`*.tar`, `*.tar.gz`, or `*.tgz`)

With your config files ready and in the correct format, set `LOGSTASH_CONFIG_URL` to your logstash config URL using the `-e` flag as follows:

    $ docker run -d \
      -e LOGSTASH_CONFIG_URL=<your_logstash_config_url> \
      -p 9292:9292 \
      -p 9200:9200 \
      pblittle/docker-logstash

By default, if `LOGSTASH_CONFIG_URL` isn't defined, an example [logstash.conf][2] will be downloaded and used in your container.

> The default `logstash.conf` only listens on `stdin` and `file` inputs. If you wish to configure `tcp` and/or `udp` input, use your own logstash configuration files and expose the ports yourself. See [logstash documentation][10] for config syntax and more information.

#### Mount a volume containing your config files

To use config files from the local file system, mount the config directory as a volume using the `-v` flag. For example:

    $ docker run -d \
      -v <your_logstash_config_dir>:/opt/logstash/conf.d \
      -p 9292:9292 \
      -p 9200:9200 \
      pblittle/docker-logstash

## Elasticsearch server integration

If you plan on using Elasticsearch, the following three integration methods are supported:

 * A linked container running Elasticsearch
 * An external Elasticsearch server
 * The embedded Elasticsearch server

#### Linked container running Elasticsearch

If you want to link to a container running Elasticsearch, simply use the `--link` flag to connect to the container:

    $ docker run -d \
      --link <your_es_container_name>:es \
      -p 9292:9292 \
      pblittle/docker-logstash

To have the linked Elasticsearch container's `bind_host` and `port` automatically detected, you will need to set the `bind_host` and `port` to `ES_HOST` and `ES_PORT` respectively in your elasticsearch output config. For example:

    output {
      elasticsearch {
        bind_host => "ES_HOST"
        port => "ES_PORT"
        protocol => "http"
      }
    }

If you are linking to an Elasticsearch container running on `172.0.4.20:9200`, the config above will be transformed into:

    output {
      elasticsearch {
        host => "172.0.4.20"
        port => "9200"
        protocol => "http"
      }
    }

#### External Elasticsearch server

If you are using an external Elasticsearch server, simply set the `ES_HOST` and `ES_PORT` environment variables in your `run` command:

    $ docker run -d \
      -e ES_HOST=<your_es_service_host> \
      -e ES_PORT=<your_es_service_port> \
      -p <your_es_service_port>=<your_es_service_port> \
      -p 9292:9292 \
      pblittle/docker-logstash

#### Embedded Elasticsearch server

The embedded Elasticsearch server will be used by default if you don't provide either of the configuration options above.

> Please note, the embedded Elasticsearch server was not designed for use in Production.

To make the data directory persistent, you can bind mount it with the following argument for `docker run`:

    -v $PWD/data:/opt/logstash/data

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

## Finally, verify the installation

You can now verify the logstash installation by visiting the sample Kibana dashboard:

    http://<your_container_ip>:9292/index.html#/dashboard/file/default.json

## Thank you

A huge thank you to the project [Contributors][4] and users. I really appreciate the support.

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
[4]: https://github.com/pblittle/docker-logstash/graphs/contributors
[5]: http://www.apache.org/licenses/LICENSE-2.0
[7]: https://www.elastic.co/products/logstash
[8]: https://www.elastic.co/products/elasticsearch
[9]: https://www.elastic.co/products/kibana
[10]: https://www.elastic.co/guide/en/logstash/current/configuration.html
