# Replace "kafka-console-producer.sh" 
# by "kafka-console-producer" or "kafka-console-producer.bat" based on your system # (or bin/kafka-console-producer.sh or bin\windows\kafka-console-producer.bat if you didn't setup PATH / Environment variables)

kafka-console-producer.sh 

# KEYLESS
# EXISTING TOPIC
# create a topic and producing messages to an existing topic
kafka-topics.sh --bootstrap-server localhost:9092 --topic first_topic --partitions 3 --create
kafka-console-producer.sh --bootstrap-server localhost:9092 --topic first_topic 
# sending values - keyless
> Hello World
> My name is Miso
>^C  (<- Ctrl + C is used to exit the producer)
# producing with properties
kafka-console-producer.sh --bootstrap-server localhost:9092 --topic first_topic --producer-property acks=all
> some message that is acked

# NON-EXISTING TOPIC: it will create it automatically but may have error of trying to find a leader broker
# producing to a non existing topic
kafka-console-producer.sh --bootstrap-server localhost:9092 --topic new_topic
> hello world!
# our new topic only has 1 partition, 1 replication factor by default
kafka-topics.sh --bootstrap-server localhost:9092 --list
kafka-topics.sh --bootstrap-server localhost:9092 --topic new_topic --describe

# edit config/server.properties or config/kraft/server.properties
# num.partitions=3
# produce against a non existing topic again
kafka-console-producer.sh --bootstrap-server localhost:9092 --topic new_topic_2
hello again!
# this time our topic has 3 partitions
kafka-topics.sh --bootstrap-server localhost:9092 --list
kafka-topics.sh --bootstrap-server localhost:9092 --topic new_topic_2 --describe

# overall, please create topics before producing to them!

# with KEY
# produce with keys, key.separator=: is separated with :
kafka-console-producer --bootstrap-server localhost:9092 --topic first_topic --property parse.key=true --property key.separator=:
# key:value
>example key:example value
>name:Stephane