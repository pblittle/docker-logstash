#!/bin/bash

# Fail fast, including pipelines
set -e -o pipefail

# Logstash source directory
LOGSTASH_SRC_DIR=${LOGSTASH_SRC_DIR:-'/opt/logstash'}

# Logstash binary path
LOGSTASH_BINARY="${LOGSTASH_SRC_DIR}/bin/logstash"

# Logstash config file used if `LOGSTASH_CONFIG_URL` isn't defined
LOGSTASH_DEFAULT_CONFIG_URL='https://gist.githubusercontent.com/pblittle/8778567/raw/logstash.conf'

# Logstash config download URL (monolithic file or tarball)
LOGSTASH_CONFIG_URL=${LOGSTASH_CONFIG_URL:-${LOGSTASH_DEFAULT_CONFIG_URL}}

# Logstash config directory
LOGSTASH_CONFIG_DIR="${LOGSTASH_SRC_DIR}/conf.d"

# Logstash config search path
LOGSTASH_CONFIG_PATH="${LOGSTASH_CONFIG_DIR}/**/*.conf"

# Logstash log directory
LOGSTASH_LOG_DIR='/var/log/logstash'

# Logstash log file path
LOGSTASH_LOG_FILE="${LOGSTASH_LOG_DIR}/logstash.log"

# Elasticsearch config file path
ES_CONFIG_FILE="${LOGSTASH_SRC_DIR}/elasticsearch.yml"

# Kibana config file path
KIBANA_CONFIG_FILE="${LOGSTASH_SRC_DIR}/vendor/kibana/config.js"

# Kibana proxy regular expression
readonly PROXY_PROTOCOL_REGEX='\(http[s]\?\)'
