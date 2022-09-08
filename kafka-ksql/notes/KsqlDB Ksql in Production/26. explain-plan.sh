#################### UNIX system - ksql #############################

CREATE STREAM userprofile (userid INT, firstname VARCHAR, lastname VARCHAR, countrycode VARCHAR, rating DOUBLE) \
WITH (VALUE_FORMAT = 'JSON', KAFKA_TOPIC = 'USERPROFILE');

create stream my_stream 
as select firstname 
from userprofile; 

show queries;
Query ID                      | Query Type | Status    | Sink Name             | Sink Kafka Topic      | Query String                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 CSAS_WEATHERREKEYED_13        | PERSISTENT | RUNNING:1 | WEATHERREKEYED        | WEATHERREKEYED        | CREATE STREAM WEATHERREKEYED WITH (KAFKA_TOPIC='WEATHERREKEYED', PARTITIONS=1, REPLICAS=1) AS SELECT * FROM WEATHERRAW WEATHERRAW PARTITION BY WEATHERRAW.CITY_NAME EMIT CHANGES;                                                                                                                                                                                                                                                                                                                                                  
 CSAS_RR_WORLD_29              | PERSISTENT | RUNNING:1 | RR_WORLD              | RR_WORLD              | CREATE STREAM RR_WORLD WITH (KAFKA_TOPIC='RR_WORLD', PARTITIONS=1, REPLICAS=1) AS SELECT   'Europe' DATA_SOURCE,   * FROM RR_EUROPE_RAW RR_EUROPE_RAW EMIT CHANGES;                                                                                                                                                                                                                                                                                                                                                                
 INSERTQUERY_31                | PERSISTENT | RUNNING:1 | RR_WORLD              | RR_WORLD              | insert into rr_world      select 'Americas' as data_source, * from rr_america_raw;                                                                                                                                                                                                                                                                                                                                                                                                                                                 
 CSAS_WEATHERRAW_11            | PERSISTENT | RUNNING:1 | WEATHERRAW            | WEATHERRAW            | CREATE STREAM WEATHERRAW WITH (KAFKA_TOPIC='WEATHERRAW', PARTITIONS=1, REPLICAS=1, VALUE_FORMAT='AVRO') AS SELECT   WEATHER.CITY->NAME CITY_NAME,   WEATHER.CITY->COUNTRY CITY_COUNTRY,   WEATHER.CITY->LATITUDE LATITUDE,   WEATHER.CITY->LONGITUDE LONGITUDE,   WEATHER.DESCRIPTION DESCRIPTION,   WEATHER.RAIN RAIN FROM WEATHER WEATHER EMIT CHANGES;                                                                                                                                                                          
 CSAS_DRIVERPROFILE_REKEYED_23 | PERSISTENT | RUNNING:1 | DRIVERPROFILE_REKEYED | DRIVERPROFILE_REKEYED | CREATE STREAM DRIVERPROFILE_REKEYED WITH (KAFKA_TOPIC='DRIVERPROFILE_REKEYED', PARTITIONS=1, REPLICAS=1) AS SELECT * FROM DRIVER_PROFILE DRIVER_PROFILE PARTITION BY DRIVER_PROFILE.DRIVER_NAME EMIT CHANGES;                                                                                                                                                                                                                                                                                                                      
 CSAS_MY_STREAM_39             | PERSISTENT | RUNNING:1 | MY_STREAM             | MY_STREAM             | CREATE STREAM MY_STREAM WITH (KAFKA_TOPIC='MY_STREAM', PARTITIONS=1, REPLICAS=1) AS SELECT USERPROFILE.FIRSTNAME FIRSTNAME FROM USERPROFILE USERPROFILE EMIT CHANGES;                                                                                                                                                                                                                                                                                                                                                              
 CSAS_RIDETODEST_35            | PERSISTENT | RUNNING:1 | RIDETODEST            | RIDETODEST            | CREATE STREAM RIDETODEST WITH (KAFKA_TOPIC='RIDETODEST', PARTITIONS=1, REPLICAS=1) AS SELECT   REQUESTED_JOURNEY.USER USER,   REQUESTED_JOURNEY.CITY_NAME CITY_NAME,   REQUESTED_JOURNEY.CITY_COUNTRY CITY_COUNTRY,   REQUESTED_JOURNEY.WEATHER_DESCRIPTION WEATHER_DESCRIPTION,   REQUESTED_JOURNEY.RAIN RAIN,   GEO_DISTANCE(REQUESTED_JOURNEY.FROM_LATITUDE, REQUESTED_JOURNEY.FROM_LONGITUDE, REQUESTED_JOURNEY.TO_LATITUDE, REQUESTED_JOURNEY.TO_LONGITUDE, 'km') DIST FROM REQUESTED_JOURNEY REQUESTED_JOURNEY EMIT CHANGES; 
 CSAS_REQUESTED_JOURNEY_33     | PERSISTENT | RUNNING:1 | REQUESTED_JOURNEY     | REQUESTED_JOURNEY     | CREATE STREAM REQUESTED_JOURNEY WITH (KAFKA_TOPIC='REQUESTED_JOURNEY', PARTITIONS=1, REPLICAS=1) AS SELECT   RR.LATITUDE FROM_LATITUDE,   RR.LONGITUDE FROM_LONGITUDE,   RR.USER USER,   RR.CITY_NAME CITY_NAME,   W.CITY_COUNTRY CITY_COUNTRY,   W.LATITUDE TO_LATITUDE,   W.LONGITUDE TO_LONGITUDE,   W.DESCRIPTION WEATHER_DESCRIPTION,   W.RAIN RAIN FROM RR_WORLD RR LEFT OUTER JOIN WEATHERNOW W ON ((RR.CITY_NAME = W.CITY_NAME)) EMIT CHANGES;                                                                             
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# show topology
explain CSAS_MY_STREAM_1;

https://zz85.github.io/kafka-streams-viz/



create table my_table 
as select firstname, count(*) as cnt 
from userprofile 
group by firstname;

show queries;

explain CTAS_MY_TABLE_0;