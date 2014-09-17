# Install Go
# sudo apt-get install golang
#
# Set GOPATH and PATH
# mkdir $HOME/go
# export GOPATH=$HOME/go
#
# Download the Go implementation of Foreman
# go get github.com/mattn/goreman
#
# Start Logstash with a linked Elasticsearch container
# goreman start

elasticsearch: docker run -d --name elasticsearch barnybug/elasticsearch:1.1.1
logstash: docker run -d --link elasticsearch:es -p 9292:9292 -p 9200:9200 pblittle/docker-logstash
