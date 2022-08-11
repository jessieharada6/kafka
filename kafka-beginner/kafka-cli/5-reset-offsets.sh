# Replace "kafka-consumer-groups" 
# by "kafka-consumer-groups.sh" or "kafka-consumer-groups.bat" based on your system # (or bin/kafka-consumer-groups.sh or bin\windows\kafka-consumer-groups.bat if you didn't setup PATH / Environment variables)

kafka-consumer-groups

# list all consumer groups
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --list
# describe a consumer group
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe -group my-first-consumer-group
# reset offsets, alternatively --topic first_topic => --all-topics
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group my-first-consumer-group --reset-offsets --to-earliest --execute --topic first_topic
GROUP                          TOPIC                          PARTITION  NEW-OFFSET    # reset 
my-first-consumer-group        first_topic                    0          0              
my-first-consumer-group        first_topic                    1          0              
my-first-consumer-group        first_topic                    2          0  
# consume from where the offsets have been reset 
# will read from the beginning
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic first_topic --group my-first-consumer-group
# describe the group again
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe --group my-first-consumer-group

# documentation for more options
kafka-consumer-groups.sh
# shift offsets by 2 (forward) as another strategy
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group my-first-consumer-group --reset-offsets --shift-by 2 --execute --topic first_topic
# shift offsets by 2 (backward) as another strategy
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group my-first-consumer-group --reset-offsets --shift-by -2 --execute --topic first_topic
# consume again when shift backwards by 2, with 3 partitions, i should see 6 messages being read 
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic first_topic --group my-first-application