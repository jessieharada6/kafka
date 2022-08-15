zookeeper-server-start.sh ~/kafka_2.13-3.2.1/config/zookeeper.properties

kafka-server-start.sh ~/kafka_2.13-3.2.1/config/server.properties

kafka-topics.sh --bootstrap-server localhost:9092 --topic <TOPIC-NAME> --create --partitions 3 --replication-factor 1