# create stream
CREATE STREAM driverLocations (driverId VARCHAR KEY, countrycode VARCHAR, city VARCHAR, driverName VARCHAR)
  WITH (kafka_topic='driverlocations', value_format='json', partitions=1);

INSERT INTO driverLocations (driverId, countrycode, city, driverName) VALUES ('1', 'AU', 'Sydney', 'Alice');
INSERT INTO driverLocations (driverId, countrycode, city, driverName) VALUES ('2', 'AU', 'Melbourne', 'Bob');
INSERT INTO driverLocations (driverId, countrycode, city, driverName) VALUES ('3', 'GB', 'London', 'Carole');
INSERT INTO driverLocations (driverId, countrycode, city, driverName) VALUES ('4', 'US', 'New York', 'Derek');


select * from driverLocations emit changes;
+--------------------------------+--------------------------------+--------------------------------+--------------------------------+
|DRIVERID                        |COUNTRYCODE                     |CITY                            |DRIVERNAME                      |
+--------------------------------+--------------------------------+--------------------------------+--------------------------------+
|1                               |AU                              |Sydney                          |Alice                           |
|2                               |AU                              |Melbourne                       |Bob                             |
|3                               |GB                              |London                          |Carole                          |
|4                               |US                              |New York                        |Derek                           |
^CQuery terminated

# create a table based on stream 
# aggregate - pull query
# count(*) ... group by ...;
create table countryDrivers as select countrycode, count(*) as numDrivers from driverLocations group by countrycode;
 Message                                      
----------------------------------------------
 Created query with ID CTAS_COUNTRYDRIVERS_21 
----------------------------------------------

# pull query
# query against rowkey 
# where countrycode='AU'
ksql> select countrycode, numdrivers from countryDrivers where countrycode='AU';
+-------------------------------------------------------------------+-------------------------------------------------------------------+
|COUNTRYCODE                                                        |NUMDRIVERS                                                         |
+-------------------------------------------------------------------+-------------------------------------------------------------------+
|AU                                                                 |2                                                                  |
Query terminated


INSERT INTO driverLocations (driverId, countrycode, city, driverName) VALUES ('5', 'AU', 'Sydney', 'Emma');
INSERT INTO driverLocations (driverId, countrycode, city, driverName) VALUES ('5', 'AU', 'Sydney', 'Emma');

select countrycode, numdrivers from countryDrivers where countrycode='AU';
+-------------------------------------------------------------------+-------------------------------------------------------------------+
|COUNTRYCODE                                                        |NUMDRIVERS                                                         |
+-------------------------------------------------------------------+-------------------------------------------------------------------+
|AU                                                                 |4                                                                  |
Query terminated