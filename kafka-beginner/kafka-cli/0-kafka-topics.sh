# Replace "kafka-topics.sh" 
# by "kafka-topics" or "kafka-topics.bat" based on your system # (or bin/kafka-topics.sh or bin\windows\kafka-topics.bat if you didn't setup PATH / Environment variables)

## START BOTH ZOOKEEPER AND KAFKA
kafka-topics.sh 

# CONNECT TO SERVER
# connect to bootstrap server (kafka broker) and list all the topics
kafka-topics.sh --bootstrap-server localhost:9092 --list
kafka-topics.sh --bootstrap-server 127.0.0.1:9092 --list 

# CREATE A TOPIC
# create a topic, first_topic will give a warning due to _, 
# but can't use first.topic and first_topic at the same time
# this command creates a topic with partition of 1 by default 
kafka-topics.sh --bootstrap-server localhost:9092 --topic first_topic --create

# create topic with 3 partitions
kafka-topics.sh --bootstrap-server localhost:9092 --topic first_topic --create --partitions 3

# create topic with 3 partitions and replication factor of 2
# will error, as factor is more than broker (1)
kafka-topics.sh --bootstrap-server localhost:9092 --topic first_topic --create --partitions 3 --replication-factor 2
# Create a topic (working)
kafka-topics.sh --bootstrap-server localhost:9092 --topic first_topic --create --partitions 3 --replication-factor 1

# LIST TOPIC
# List topics
kafka-topics.sh --bootstrap-server localhost:9092 --list 

#  DESCRIBE TOPIC
# Describe a topic
kafka-topics.sh --bootstrap-server localhost:9092 --topic first_topic --describe
# returns:
Topic: first_topic      TopicId: NlzxIrm4Tb-MhzJgBJWwug PartitionCount: 1       ReplicationFactor: 1    Configs: segment.bytes=1073741824
        Topic: first_topic      Partition: 0    Leader: 0       Replicas: 0     Isr: 0
# partition count is 1, leader broker is 0 for partition 0

kafka-topics.sh --bootstrap-server localhost:9092 --topic first_topic --describe
# returns:
Topic: second_topic     TopicId: DlDIAjh7Rye4fZ66t94pUQ PartitionCount: 3       ReplicationFactor: 1    Configs: segment.bytes=1073741824
        Topic: second_topic     Partition: 0    Leader: 0       Replicas: 0     Isr: 0
        Topic: second_topic     Partition: 1    Leader: 0       Replicas: 0     Isr: 0
        Topic: second_topic     Partition: 2    Leader: 0       Replicas: 0     Isr: 0
# note: only 1 leader broker

# describe all topics
kafka-topics.sh --bootstrap-server localhost:9092 --describe

# DELETE TOPIC
# Delete a topic 
kafka-topics.sh --bootstrap-server localhost:9092 --topic first_topic --delete
# (only works if delete.topic.enable=true)