#!/bin/bash

# create input topic with one partition to get full ordering
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic bank-transactions

# create output log compacted topic
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic bank-balance-exactly-once --config cleanup.policy=compact

# launch a Kafka consumer
# to test on producer - create the input topic
kafka-console-consumer.sh --bootstrap-server localhost:9092 \
    --topic bank-balance-input \
    --from-beginning \
    --formatter kafka.tools.DefaultMessageFormatter \
    --property print.key=true \
    --property print.value=true \
    --property key.deserializer=org.apache.kafka.common.serialization.StringDeserializer \
    --property value.deserializer=org.apache.kafka.common.serialization.StringDeserializer

# JoJo    {"name":"JoJo","amount":34,"time":"2022-08-26T03:56:32.360Z"}
# Sasha   {"name":"Sasha","amount":94,"time":"2022-08-26T03:56:32.465Z"}
# Steph   {"name":"Steph","amount":68,"time":"2022-08-26T03:56:32.570Z"}
# JoJo    {"name":"JoJo","amount":90,"time":"2022-08-26T03:56:32.672Z"}
# Sasha   {"name":"Sasha","amount":34,"time":"2022-08-26T03:56:32.778Z"}
# Steph   {"name":"Steph","amount":81,"time":"2022-08-26T03:56:32.882Z"}
# JoJo    {"name":"JoJo","amount":83,"time":"2022-08-26T03:56:32.984Z"}
# Sasha   {"name":"Sasha","amount":39,"time":"2022-08-26T03:56:33.090Z"}

# to test on the stream
kafka-console-consumer.sh --bootstrap-server localhost:9092 \
    --topic bank-balance-output \
    --from-beginning \
    --formatter kafka.tools.DefaultMessageFormatter \
    --property print.key=true \
    --property print.value=true \
    --property key.deserializer=org.apache.kafka.common.serialization.StringDeserializer \
    --property value.deserializer=org.apache.kafka.common.serialization.StringDeserializer
# Sasha   {"count":306,"balance":15648,"time":"2022-08-26T03:52:10.153Z"}
# Steph   {"count":347,"balance":17411,"time":"2022-08-26T03:52:10.259Z"}
# JoJo    {"count":347,"balance":17172,"time":"2022-08-26T03:52:10.364Z"}
# Steph   {"count":577,"balance":28657,"time":"2022-08-26T03:56:32.882Z"}
# JoJo    {"count":577,"balance":28895,"time":"2022-08-26T03:56:32.984Z"}
# Sasha   {"count":536,"balance":27435,"time":"2022-08-26T03:56:33.090Z"}