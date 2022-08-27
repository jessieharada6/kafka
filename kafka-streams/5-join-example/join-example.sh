#!/bin/bash

# create input topic for user purchases for kstream
kafka-topics.sh --bootstrap-server localhost:9092 --topic user-purchases --replication-factor 1 --partitions 3 --create 

# create table of user information - log compacted for optimisation for globalktable
# bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 2 --topic user-table --config cleanup.policy=compact
kafka-topics.sh --bootstrap-server localhost:9092 --topic user-table --replication-factor 1 --partitions 2 --create --config cleanup.policy=compact

# create out topic for user purchases enriched with user data (left join)
kafka-topics.sh --bootstrap-server localhost:9092 --topic user-purchases-enriched-left-join --replication-factor 1 --partitions 3 --create

# create out topic for user purchases enriched with user data (inner join)
kafka-topics.sh --bootstrap-server localhost:9092 --topic user-purchases-enriched-inner-join --replication-factor 1 --partitions 3 --create

# start a consumer on the output topic (left join)
kafka-console-consumer.sh --bootstrap-server localhost:9092 \
    --topic user-purchases-enriched-left-join \
    --from-beginning \
    --formatter kafka.tools.DefaultMessageFormatter \
    --property print.key=true \
    --property print.value=true \
    --property key.deserializer=org.apache.kafka.common.serialization.StringDeserializer \
    --property value.deserializer=org.apache.kafka.common.serialization.StringDeserializer


# start a consumer on the output topic (inner join)
kafka-console-consumer.sh --bootstrap-server localhost:9092 \
    --topic user-purchases-enriched-inner-join \
    --from-beginning \
    --formatter kafka.tools.DefaultMessageFormatter \
    --property print.key=true \
    --property print.value=true \
    --property key.deserializer=org.apache.kafka.common.serialization.StringDeserializer \
    --property value.deserializer=org.apache.kafka.common.serialization.StringDeserializer
