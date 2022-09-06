
#################### UNIX system - ksql #############################
# create a new stream weatherraw from the existing json stream weather
# in the format of avro

create stream weatherraw with (value_format='AVRO') as SELECT city->name AS city_name, city->country AS city_country, city->latitude as latitude, city->longitude as longitude, description, rain from weather ;  

list streams;
 Stream Name         | Kafka Topic                 | Key Format | Value Format | Windowed 
------------------------------------------------------------------------------------------
 WEATHER             | WEATHERNESTED               | KAFKA      | JSON         | false    
 WEATHERRAW          | WEATHERRAW                  | KAFKA      | AVRO         | false    
------------------------------------------------------------------------------------------

# check key on the new stream
# i.e. rowkey
select rowkey, city_name from weatherraw;
describe extended weatherraw;

# Name                 : WEATHERRAW
# Type                 : STREAM
# Key field            :                <- *** NOTE BLANK ***
# Key format           : STRING
# Timestamp field      : Not set - using <ROWTIME>
# Value format         : AVRO
# Kafka topic          : WEATHERRAW (partitions: 4, replication: 1)

# create another stream based on the weatherraw stream, 
# ADD KEY: and partition based on city_name as key
create stream weatherrekeyed as select * from weatherraw partition by city_name;  

describe weatherrekeyed extended;

# Name                 : WEATHERREKEYED
# Type                 : STREAM
# Key field            : CITY_NAME    <- ***  Keyed on city ***
# Key format           : STRING
# Timestamp field      : Not set - using <ROWTIME>
# Value format         : AVRO
# Kafka topic          : WEATHERREKEYED (partitions: 4, replication: 1)

# create a table
create table weathernow (city_name varchar primary key, city_country varchar, latitude double, longitude double, description varchar, rain double) with (kafka_topic='WEATHERREKEYED', value_format='AVRO');

# update data
cat /Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/demo-weather-changes.json | kafka-console-producer --broker-list localhost:9092 --topic WEATHERNESTED

select * from weathernow where city_name='San Diego' emit changes;