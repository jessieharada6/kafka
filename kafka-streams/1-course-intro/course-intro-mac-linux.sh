#!/bin/bash

# download kafka at  https://www.apache.org/dyn/closer.cgi?path=/kafka/0.11.0.1/kafka_2.11-0.11.0.1.tgz
# extract kafka in a folder

### LINUX / MAC OS X ONLY

# open a shell - zookeeper is at localhost:2181
# bin/zookeeper-server-start.sh config/zookeeper.properties
zookeeper-server-start.sh config/zookeeper.properties
# open another shell - kafka is at localhost:9092
# bin/kafka-server-start.sh config/server.properties
kafka-server-start.sh config/server.properties

# create input topic
# bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic streams-plaintext-input
kafka-topics.sh --bootstrap-server localhost:9092 --topic streams-plaintext-input --partitions 1 --create
# create output topic
# bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic streams-wordcount-output
kafka-topics.sh --bootstrap-server localhost:9092 --topic streams-wordcount-output --partitions 1 --create
# list topics
kafka-topics.sh --bootstrap-server localhost:9092

# start a kafka producer, and add texts
# bin/kafka-console-producer.sh --broker-list localhost:9092 --topic streams-plaintext-input
kafka-console-producer.sh --bootstrap-server localhost:9092 --topic streams-plaintext-input
# enter
kafka streams udemy
kafka data processing
kafka streams course
# exit

# verify the data has been written
# bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic streams-plaintext-input --from-beginning
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic streams-plaintext-input --from-beginning

# start a consumer on the output topic
# bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 \
#     --topic streams-wordcount-output \
#     --from-beginning \
#     --formatter kafka.tools.DefaultMessageFormatter \
#     --property print.key=true \
#     --property print.value=true \
#     --property key.deserializer=org.apache.kafka.common.serialization.StringDeserializer \
#     --property value.deserializer=org.apache.kafka.common.serialization.LongDeserializer
kafka-console-consumer.sh --bootstrap-server localhost:9092 \
    --topic streams-wordcount-output \
    --from-beginning \
    --formatter kafka.tools.DefaultMessageFormatter \
    --property print.key=true \
    --property print.value=true \
    --property key.deserializer=org.apache.kafka.common.serialization.StringDeserializer \
    --property value.deserializer=org.apache.kafka.common.serialization.LongDeserializer

# start the streams application
bin/kafka-run-class.sh org.apache.kafka.streams.examples.wordcount.WordCountDemo
# output:
kafka   1
streams 1
udemy   1
kafka   2
data    1
processing      1
kafka   3
streams 2
course  1
exit    1
# it comes one by one, no batching, real time

# verify the data has been written to the output topic!
