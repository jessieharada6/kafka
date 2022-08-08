## install confluent kafka command line
curl -sL --http1.1 https://cnfl.io/cli | sh -s -- latest \
export PATH=$(pwd)/bin:$PATH

## login
onfluent login --save

## get environment
confluent environment list       
confluent environment use [envname]   

## get cluster
confluent kafka cluster list \
confluent kafka cluster use [clustername]

## get topic
confluent kafka topic list \
confluent kafka topic use [topicname]

## create api key
confluent api-key create --resource [clustername]

## link api key to cluster
confluent api-key use [apikey] --resource [clustername]

## to get bootstrap.servers at config.ini
confluent kafka cluster describe 

## virtualenv
mkdir my_project && cd my_project
virtualenv env
source env/bin/activate
## run script
chmod u+x consumer.py \
./consumer.py config.ini


## tut link
https://developer.confluent.io/learn-kafka/apache-kafka/consumers-hands-on/?utm_source=youtube&utm_medium=video&utm_campaign=tm.devx_ch.cd-apache-kafka-101_content.apache-kafka