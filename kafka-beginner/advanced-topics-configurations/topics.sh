# create a topic
kafka-topics.sh --create --bootstrap-server localhost:9092 --topic configured-topic --replication-factor 1 --partitions 3

# alter default value of min.insync.replicas
kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name configured-topic --alter --add-config min.insync.replicas=2

# describe the topic
kafka-topics.sh --bootstrap-server localhost:9092 --topic configured-topic --describe 
Topic: configured-topic TopicId: cdSRwg-QRyW5I4LYz5Bcow PartitionCount: 3       ReplicationFactor: 1    Configs: min.insync.replicas=2,segment.bytes=1073741824
        Topic: configured-topic Partition: 0    Leader: 0       Replicas: 0     Isr: 0
        Topic: configured-topic Partition: 1    Leader: 0       Replicas: 0     Isr: 0
        Topic: configured-topic Partition: 2    Leader: 0       Replicas: 0     Isr: 0

# describe the configs of the specified topic
kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name configured-topic --describe
Dynamic configs for topic configured-topic are:
  min.insync.replicas=2 sensitive=false synonyms={DYNAMIC_TOPIC_CONFIG:min.insync.replicas=2, DEFAULT_CONFIG:min.insync.replicas=1}

# delete altered value of min.insync.replicas
kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name configured-topic --alter --delete-config min.insync.replicas
# if now we describe the topic or the topic configs again, it will be empty 

# kafka internal topic __consumer_offsets has a different cleanup.policy from other user topics
kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic __consumer_offsets
# Configs: compression.type=producer,cleanup.policy=compact,segment.bytes=104857600

# log compaction
kafka-topics.sh --bootstrap-server localhost:9092 --create --topic employee-salary \
    --partitions 1 --replication-factor 1 \
    --config cleanup.policy=compact \
    --config min.cleanable.dirty.ratio=0.001 \
    --config segment.ms=5000

kafka-topics.sh --bootstrap-server localhost:9092 --describe \
                --topic employee-salary

# launch/create a consumer
kafka-console-consumer.sh --bootstrap-server localhost:9092 \
    --topic employee-salary \
    --from-beginning \
    --property print.key=true \
    --property key.separator=,

# create a producer
kafka-console-producer.sh --bootstrap-server localhost:9092 \
    --topic employee-salary \
    --property parse.key=true \
    --property key.separator=,

# enter below at producer side one by one
Patrick,salary: 10000
Lucy,salary: 20000
Bob,salary: 20000
Patrick,salary: 25000
Lucy,salary: 30000
Patrick,salary: 30000
Stephane,salary: 0
# the consumer will receive every record 
# (as log does not prevent from pushing/reading duplicate records)

# stop the consumer, and start a new one
# only the most recent with unique key show
Bob,salary: 20000
Lucy,salary: 30000
Patrick,salary: 30000
Stephane,salary: 0