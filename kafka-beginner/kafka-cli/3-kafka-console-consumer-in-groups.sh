# Replace "kafka-console-consumer.sh" 
# by "kafka-console-consumer" or "kafka-console-consumer.bat" based on your system # (or bin/kafka-console-consumer.sh or bin\windows\kafka-console-consumer.bat if you didn't setup PATH / Environment variables)

# consumer 1 in the consumer group of my-first-consumer-group
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic first_topic --group my-first-consumer-group
# consumer 2 in the consumer group of my-first-consumer-group
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic first_topic --group my-first-consumer-group
# start one producer and start producing messages
kafka-console-producer.sh --bootstrap-server localhost:9092 --topic first_topic
# see messages being spread - rebalance - to 2 consumers, 1 consumer receives 1 message at a time depending on the partition being assigned
# 2 different consumers won't get the same messages
# consumers <= partitions, otherwise the extra consumer will idle 

# 1. NOTE: as first_topic has set acks, with --from-beginning flag, it won't read from beginning
# due to consumer offsets alr being commited 
# it only reads from where the offset was left last time
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic first_topic --group my-first-consumer-group --from-beginning
# start another consumer part of a different group from beginning, 
# this time, we will have all history as it has never been read
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic first_topic --group my-third-consumer-group --from-beginning

# 2. NOTE: when consumer group only has 1 consumer, it consumes from all partitions
# now create another group, and send messages from producer, this consumer should receive all messages 
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic first_topic --group my-second-consumer-group