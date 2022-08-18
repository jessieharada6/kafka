#!/bin/bash

# Make sure you change the ADV_HOST variable in docker-compose.yml
# if you are using docker Toolbox

# 1) Source connectors
# use below to build the image
git clone https://github.com/faberchri/fast-data-dev.git
cd fast-data-dev
docker build -t faberchri/fast-data-dev .
# docker run --rm -p 3030:3030 faberchri/fast-data-dev
# update the kafka-cluster image to faberchri/fast-data-dev at docker-compose
# start our kafka cluster
docker-compose up kafka-cluster

###############
# A) FileStreamSourceConnector in standalone mode
# At source/connect-source-standalone

# We start a hosted tools, mapped on our code
# mount all the files to /tutorials folder
# Linux / Mac: RUN AT the ROOT of the project
docker run --rm -it -v "$(pwd)":/tutorial --net=host faberchri/fast-data-dev bash
ls /tutorial 
# should see 3 files listed, including worker.properties, file-stream-demo-standalone.properties and demo-file.txt
# Windows Command Line:
# docker run --rm -it -v %cd%:/tutorial --net=host landoop/fast-data-dev:cp3.3.0 bash
# Windows Powershell:
# docker run --rm -it -v ${PWD}:/tutorial --net=host landoop/fast-data-dev:cp3.3.0 bash

# create the topic we write to with 3 partitions
kafka-topics --create --topic demo-1-standalone --partitions 3 --replication-factor 1 --zookeeper 127.0.0.1:2181
# we launch the kafka connector in standalone mode:
# create a standalone connector under this file
cd /tutorial/source/connect-source-standalone
# Usage is connect-standalone worker.properties connector1.properties [connector2.properties connector3.properties]
# worker.properties must be named as such
connect-standalone worker.properties file-stream-demo-standalone.properties
# write some data to the demo-file.txt
# go to http://localhost:3030/kafka-topics-ui/#/cluster/fast-data-dev/topic/n/demo-1-standalone/data
# at demo-file.txt, leave a line at the end, so can see the data
# shut down the terminal when you're done
# then start, the topic knows where to read from
# STANDALONE: CONFIG BUNDLED WITH WORKER
connect-standalone worker.properties file-stream-demo-standalone.properties
# the old data is saved and can still see, write more data, data is loaded
###############

###############
# B) FileStreamSourceConnector in distributed mode:
# cd /tutorial/source/connect-source-distributed
# create the topic we're going to write to
docker run --rm -it --net=host faberchri/fast-data-dev bash
kafka-topics --create --topic demo-2-distributed --partitions 3 --replication-factor 1 --zookeeper 127.0.0.1:2181
# you can now close the new shell

# head over to 127.0.0.1:3030 -> Connect UI
# Create a new connector -> File Source
# DISTRIBUTED: CONFIG SUBMITTED BY REST API
# Paste the configuration at source/demo-2/file-stream-demo-distributed.properties

# Now that the configuration is launched, we need to create the file demo-file.txt
# exit the root@fast-data-dev
# as we run the connector in distributed mode, it needs to be inside the cluster
docker ps
docker exec -it <containerId> bash
# these two command lines above bring us to the same container as docker-compose up kafka-cluster
# write data to the file
touch demo-file.txt
echo "hi" >> demo-file.txt
echo "hello" >> demo-file.txt
echo "from the other side" >> demo-file.txt
# refresh http://127.0.0.1:3030/kafka-topics-ui/#/cluster/fast-data-dev/topic/n/demo-2-distributed/

# Exit and run below
# Read the topic data, to see the schema in json
docker run --rm -it --net=host faberchri/fast-data-dev bash
kafka-console-consumer --topic demo-2-distributed --from-beginning --bootstrap-server 127.0.0.1:9092
# observe we now have json as an output, even though the input was text!
###############

###############
# C) TwitterSourceConnector in distributed mode:
# create the topic we're going to write to
docker run --rm -it --net=host faberchri/fast-data-dev bash
kafka-topics --create --topic demo-3-twitter --partitions 3 --replication-factor 1 --zookeeper 127.0.0.1:2181
# Start a console consumer on that topic
kafka-console-consumer --topic demo-3-twitter --bootstrap-server 127.0.0.1:9092

# Follow the instructions at: https://github.com/Eneco/kafka-connect-twitter#creating-a-twitter-application
# To obtain the required keys, visit https://apps.twitter.com/ and Create a New App. Fill in an application name & description & web site and accept the developer aggreement. Click on Create my access token and populate a file twitter-source.properties with consumer key & secret and the access token & token secret using the example file to begin with.

# Setup instructions for the connector are at: https://github.com/Eneco/kafka-connect-twitter#setup
# fill in the required information at demo-3/source-twitter-distributed.properties
# Launch the connector and start seeing the data flowing in!
