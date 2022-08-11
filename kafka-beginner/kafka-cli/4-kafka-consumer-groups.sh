 # Replace "kafka-consumer-groups.sh" 
# by "kafka-consumer-groups" or "kafka-consumer-groups.bat" based on your system # (or bin/kafka-consumer-groups.sh or bin\windows\kafka-consumer-groups.bat if you didn't setup PATH / Environment variables)

# documentation for the command 
kafka-consumer-groups.sh 

# list consumer groups
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --list
 
# describe one specific group
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe --group my-second-consumer-group
# describe another group
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe --group my-first-consumer-group
# returns
# note CONSUMER-ID is different, as we have 2 consumers running atm
GROUP                   TOPIC           PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID                                          HOST            CLIENT-ID
my-first-consumer-group first_topic     0          8               8               0               console-consumer-508958a0-c98f-498a-b38d-83e4dddea9d0 /127.0.0.1      console-consumer
my-first-consumer-group first_topic     1          10              10              0               console-consumer-508958a0-c98f-498a-b38d-83e4dddea9d0 /127.0.0.1      console-consumer
my-first-consumer-group first_topic     2          6               6               0               console-consumer-6c3bcd9c-1d05-4873-82e7-61b002a44c51 /127.0.0.1      console-consumer
# if CURRENT-OFFSET == LOG-END-OFFSET, LAG is 0, else, LAG > 0 (LOG-END-OFFSET - CURRENT-OFFSET)
# if we write messages via kafka-console-producer.sh --bootstrap-server localhost:9092 --topic first_topic
# and stop the current consumer group, and describe it again, it returns with LAG
# note CONSUMER-ID is null, as consumers have all been disconnected
GROUP                   TOPIC           PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID     HOST            CLIENT-ID
my-first-consumer-group first_topic     0          11              11              0               -               -               -
my-first-consumer-group first_topic     1          12              14              2               -               -               -
my-first-consumer-group first_topic     2          6               9               3               -               -               -
# now start a consumer, we will receive all the 5 lagged messages
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic first_topic --group my-first-application
# describe the group now, lag is 0
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe --group my-first-application
# returns
# note CONSUMER-ID is the same, as we only have one consumer running
GROUP                   TOPIC           PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID                                           HOST            CLIENT-ID
my-first-consumer-group first_topic     0          11              11              0               console-consumer-60506e10-f783-418c-9470-b2a02e2e01a7 /127.0.0.1      console-consumer
my-first-consumer-group first_topic     1          14              14              0               console-consumer-60506e10-f783-418c-9470-b2a02e2e01a7 /127.0.0.1      console-consumer
my-first-consumer-group first_topic     2          9               9               0               console-consumer-60506e10-f783-418c-9470-b2a02e2e01a7 /127.0.0.1      console-consumer

# read from the beginning on the first topic, all messages show
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic first_topic --from-beginning
# list the consumer groups
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --list
# returns a temp consumer group, it will be deleted once i stop kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic first_topic --from-beginning
my-first-consumer-group
my-third-consumer-group
console-consumer-68095
my-second-consumer-group
# describe a console consumer group (change the end number)
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe --group console-consumer-68095
# returns no current-offset and lag
GROUP                  TOPIC           PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID                                           HOST            CLIENT-ID
console-consumer-68095 first_topic     0          -               11              -               console-consumer-8292a303-b6a4-49a3-b486-151c9388340c /127.0.0.1      console-consumer
console-consumer-68095 first_topic     1          -               14              -               console-consumer-8292a303-b6a4-49a3-b486-151c9388340c /127.0.0.1      console-consumer
console-consumer-68095 first_topic     2          -               9               -               console-consumer-8292a303-b6a4-49a3-b486-151c9388340c /127.0.0.1      console-consumer
