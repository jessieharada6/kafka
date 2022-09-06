# When you use KSQL to join streaming data, 
# you must ensure that your streams and tables are co-partitioned, 
# which means that input records on both sides of the join have the same configuration settings for partitions

#################### UNIX system - confluent cli #############################
kafka-topics.sh --bootstrap-server localhost:9092 --create --partitions 2 --replication-factor 1 --topic DRIVER_PROFILE

kafka-console-producer --broker-list localhost:9092 --topic DRIVER_PROFILE 
{"driver_name":"Mr. Speedy", "countrycode":"AU", "rating":2.4}

kafka-topics.sh --bootstrap-server localhost:9092 --create --partitions 1 --replication-factor 1 --topic COUNTRY_CSV_v1
CREATE TABLE COUNTRYTABLE_v1  (countrycode VARCHAR PRIMARY KEY, countryname VARCHAR) WITH (KAFKA_TOPIC='COUNTRY_CSV_v1', VALUE_FORMAT='DELIMITED');

#################### UNIX system - ksql #############################
CREATE STREAM DRIVER_PROFILE (driver_name VARCHAR, countrycode VARCHAR, rating DOUBLE) 
  WITH (VALUE_FORMAT = 'JSON', KAFKA_TOPIC = 'DRIVER_PROFILE');

select dp.driver_name, ct.countryname, dp.rating 
from DRIVER_PROFILE dp 
left join COUNTRYTABLE_v1 ct on ct.countrycode=dp.countrycode emit changes; 
# Can't join `DP` with `CT` since the number of partitions don't match. `DP` partitions = 2; `CT` partitions = 1. Please repartition either one so that the number of partitions match.

# TO SOLVE: partition by
create stream driverprofile_rekeyed with (partitions=1) as select * from DRIVER_PROFILE partition by driver_name; 

# check number of partition
describe driverprofile_rekeyed extended;


select dp2.driver_name, ct.countryname, dp2.rating 
from DRIVERPROFILE_REKEYED dp2 
left join COUNTRYTABLE_v1 ct on ct.countrycode=dp2.countrycode emit changes;  
