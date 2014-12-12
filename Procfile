#
# Usage Notes
# -----------
#
# Install Go
# sudo apt-get install golang
#
# Set GOPATH and PATH
# mkdir $HOME/go
# export GOPATH=$HOME/go
# export PATH=$PATH:$GOPATH/bin
#
# Download the Go implementation of Foreman
# go get github.com/mattn/goreman
#
# Start Logstash with a linked Elasticsearch container
# goreman start
#
# Get your log on
# http://<your_kibana_ip>:9292/index.html#/dashboard/file/logstash.json

# Build the Elasticsearch container you are linking to
elasticsearch: docker run -d -p 9200:9200 --name elasticsearch barnybug/elasticsearch

# Build the Logstash server and link to the new Elasticsearch container
logstash: docker run -d --link elasticsearch:es -p 9292:9292 --expose 9200 --name logstash pblittle/docker-logstash

# Build the Logstash server using the embedded Elasticsearch server
logstash-embedded: docker run -d --name logstash-embedded -p 9292:9292 -p 9200:9200 pblittle/docker-logstash
