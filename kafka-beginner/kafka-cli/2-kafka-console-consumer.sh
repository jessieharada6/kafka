# Replace "kafka-console-consumer.sh" 
# by "kafka-console-consumer" or "kafka-console-consumer.bat" based on your system # (or bin/kafka-console-consumer.sh or bin\windows\kafka-console-consumer.bat if you didn't setup PATH / Environment variables)

# kafka-console-consumer.sh uses random group id

# BY DEFAULT, READS FROM END
# consuming, reads from the end (offset) by default
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic first_topic
# in other terminal, connect to producer and send a message, then consumer shall see it
kafka-console-producer.sh --bootstrap-server localhost:9092 --topic first_topic

# CONSUMING ALL THE HISTORY
# consuming from beginning
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic first_topic --from-beginning
# note that the order among partitions are not guaranteed, 
# as some of the messages sent from producer as keyless, so evenly distributed to all partitions - round robin

# display key, values and timestamp in consumer
kafka-console-consumer --bootstrap-server localhost:9092 --topic first_topic --formatter kafka.tools.DefaultMessageFormatter --property print.timestamp=true --property print.key=true --property print.value=true --from-beginning

