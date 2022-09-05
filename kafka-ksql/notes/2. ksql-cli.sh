# connect ksql cli to ksqldb server
ksql
# CLI v7.2.1, Server v7.2.1 located at http://localhost:8088
# Server Status: RUNNING

######################################### KSQl ######################################################
list topics; # list all the topics in kafka broker
# if it doesnt show USERS
kafka-topics.sh --create --bootstrap-server localhost:9092 --topic USERS --replication-factor 1 --partitions 1
# to producer data
kafka-console-producer.sh --broker-list localhost:9092 --topic USERS 


# only show new arriving data from producer for example, 
# the first record of Alice, US won't show, until we enter the second one
# this command sitting there and listening 
print 'USERS'; 
Key format: ¯\_(ツ)_/¯ - no data processed
Value format: KAFKA_STRING
rowtime: 2022/09/03 00:54:11.917 Z, key: <null>, value: Bob, GB, partition: 0
rowtime: 2022/09/03 00:54:30.205 Z, key: <null>, value: Carole, AU, partition: 0
rowtime: 2022/09/03 00:54:41.939 Z, key: <null>, value: Dan, US, partition: 0
^CTopic printing ceased
# press ctrl + c to exit 

# show all records 
print 'USERS' from beginning;
Key format: ¯\_(ツ)_/¯ - no data processed
Value format: KAFKA_STRING
rowtime: 2022/09/03 00:53:29.884 Z, key: <null>, value: Alice, US, partition: 0
rowtime: 2022/09/03 00:54:11.917 Z, key: <null>, value: Bob, GB, partition: 0
rowtime: 2022/09/03 00:54:30.205 Z, key: <null>, value: Carole, AU, partition: 0
rowtime: 2022/09/03 00:54:41.939 Z, key: <null>, value: Dan, US, partition: 0
# when i enter one more record from producer, it is also showing below, as by default, it is listening 
rowtime: 2022/09/03 00:58:51.144 Z, key: <null>, value: Ella, JP, partition: 0
Press CTRL-C to interrupt

# show the first 2 records
print 'USERS' from beginning limit 2;
Key format: ¯\_(ツ)_/¯ - no data processed
Value format: KAFKA_STRING
rowtime: 2022/09/03 00:53:29.884 Z, key: <null>, value: Alice, US, partition: 0
rowtime: 2022/09/03 00:54:11.917 Z, key: <null>, value: Bob, GB, partition: 0
Topic printing ceased

# for i in range(0, 2, len(users)) 
# starting from index 0, show every other record
print 'USERS' from beginning interval 2 limit 2;
Key format: ¯\_(ツ)_/¯ - no data processed
Value format: KAFKA_STRING
rowtime: 2022/09/03 00:53:29.884 Z, key: <null>, value: Alice, US, partition: 0
rowtime: 2022/09/03 00:54:30.205 Z, key: <null>, value: Carole, AU, partition: 0
Topic printing ceased