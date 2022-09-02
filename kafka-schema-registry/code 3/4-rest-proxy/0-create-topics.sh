# kafka-topics --create --zookeeper localhost:2181 --topic rest-binary --replication-factor 1 --partitions 1
# kafka-topics --create --zookeeper localhost:2181 --topic rest-json --replication-factor 1 --partitions 1
# kafka-topics --create --zookeeper localhost:2181 --topic rest-avro --replication-factor 1 --partitions 1

# i created it with 3 partitions, but editted the query into 1 later on
kafka-topics.sh --create --bootstrap-server localhost:9092 --topic rest-binary --replication-factor 1 --partitions 1
kafka-topics.sh --create --bootstrap-server localhost:9092 --topic rest-json --replication-factor 1 --partitions 1
kafka-topics.sh --create --bootstrap-server localhost:9092 --topic rest-avro --replication-factor 1 --partitions 1

#run
docker-compose up 
# at /Users/jessieharada/Desktop/kafka/kafka-schema-registry/code 3/2-start-kafka

# user this consumer we can also consume the data sent in avro format
docker run -it --rm --net=host confluentinc/cp-schema-registry:3.3.1 bash

kafka-avro-console-consumer --topic rest-avro \
    --bootstrap-server 127.0.0.1:9092 \
    --property schema.registry.url=http://127.0.0.1:8081 \
    --from-beginning