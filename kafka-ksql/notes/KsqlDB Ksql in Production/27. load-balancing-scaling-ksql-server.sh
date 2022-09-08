# in this experiment, we only have 1 kafka broker, in reality, we should have more than 1 kafka broker for availability
# 2 ksql instances

#################### UNIX system #############################
# Multi Server with docker

docker-compose  -f docker-compose-prod.yml up -d 
ksql-datagen schema=/Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/datagen/userprofile.avro format=json topic=USERPROFILE key=userid msgRate=1 maxInterval=1000 iterations=100000


#################### UNIX system - ksql #############################
CREATE STREAM userprofile (userid INT, firstname VARCHAR, lastname VARCHAR, countrycode VARCHAR, rating DOUBLE) 
  WITH (VALUE_FORMAT = 'JSON', KAFKA_TOPIC = 'USERPROFILE');  

# a very simple app - another stream
create stream up_lastseen as 
SELECT TIMESTAMPTOSTRING(rowtime, 'dd/MMM HH:mm:ss') as createtime, firstname
from userprofile;  

#################### UNIX system #############################
# make sure datagen is running, and the streams are created below
kafka-console-consumer --bootstrap-server localhost:9092  --topic UP_LASTSEEN 

# show which servers are running
docker-compose -f docker-compose-prod.yml ps

            Name                         Command            State                     Ports                   
--------------------------------------------------------------------------------------------------------------
ksql-course_kafka_1             /etc/confluent/docker/run   Up      0.0.0.0:9092->9092/tcp                    
ksql-course_ksql-server-1_1     /etc/confluent/docker/run   Up      0.0.0.0:8088->8088/tcp                    
ksql-course_ksql-server-2_1     /etc/confluent/docker/run   Up      0.0.0.0:28088->8088/tcp                   
ksql-course_schema-registry_1   /etc/confluent/docker/run   Up      0.0.0.0:8081->8081/tcp                    
ksql-course_zookeeper_1         /etc/confluent/docker/run   Up      0.0.0.0:2181->2181/tcp, 2888/tcp, 3888/tcp

# no effects on app
# stop 1
docker-compose -f docker-compose-prod.yml stop ksql-server-1

# re-start 1
docker-compose -f docker-compose-prod.yml start ksql-server-1

# stop 2
docker-compose -f docker-compose-prod.yml stop ksql-server-2

# stop 1
docker-compose -f docker-compose-prod.yml stop ksql-server-1
# now app pauses

# all new messages processed
# start 2
docker-compose -f docker-compose-prod.yml start ksql-server-2

# start 1
docker-compose -f docker-compose-prod.yml start ksql-server-1