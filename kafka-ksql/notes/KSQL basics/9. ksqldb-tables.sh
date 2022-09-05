
############################# Topic #############################
# create a topic
kafka-topics.sh --create --bootstrap-server localhost:9092 --topic COUNTRY-CSV --replication-factor 1 --partitions 1

# write data, with specified key
kafka-console-producer.sh --broker-list localhost:9092 --topic COUNTRY-CSV --property "parse.key=true" --property "key.separator=:"                               
>AU:Australia


############################# KSQL #############################
# create table
CREATE TABLE COUNTRYTABLE (countrycode VARCHAR PRIMARY KEY, countryname VARCHAR) WITH (KAFKA_TOPIC = 'COUNTRY-CSV', VALUE_FORMAT = 'DELIMITED');

# show table
show tables;

 Table Name   | Kafka Topic | Key Format | Value Format | Windowed 
-------------------------------------------------------------------
 COUNTRYTABLE | COUNTRY-CSV | KAFKA      | DELIMITED    | false    
-------------------------------------------------------------------

# describe a table
describe COUNTRYTABLE;

# show data
PRINT 'COUNTRY-CSV';

Name                 : COUNTRYTABLE
 Field       | Type                           
----------------------------------------------
 COUNTRYCODE | VARCHAR(STRING)  (primary key) 
 COUNTRYNAME | VARCHAR(STRING)                
----------------------------------------------
For runtime statistics and query details run: DESCRIBE <Stream,Table> EXTENDED;

# running records
SET 'auto.offset.reset'='earliest';
select countrycode, countryname from countrytable emit changes;
+-------------------------------------------------------------------+-------------------------------------------------------------------+
|COUNTRYCODE                                                        |COUNTRYNAME                                                        |
+-------------------------------------------------------------------+-------------------------------------------------------------------+
|AU                                                                 |Australia                   
Press CTRL-C to interrupt               

# limit 
select countrycode, countryname from countrytable where countrycode='GB' emit changes limit 1;
+-------------------------------------------------------------------+-------------------------------------------------------------------+
|COUNTRYCODE                                                        |COUNTRYNAME                                                        |
+-------------------------------------------------------------------+-------------------------------------------------------------------+
|GB                                                                 |England                                                            |
Limit Reached
Query terminated
ksql> select countrycode, countryname from countrytable where countrycode='GB' emit changes;
+-------------------------------------------------------------------+-------------------------------------------------------------------+
|COUNTRYCODE                                                        |COUNTRYNAME                                                        |
+-------------------------------------------------------------------+-------------------------------------------------------------------+
|GB                                                                 |England                                                            |

Press CTRL-C to interrupt

select countrycode, countryname from countrytable where countrycode='FR' emit changes;
+-------------------------------------------------------------------+-------------------------------------------------------------------+
|COUNTRYCODE                                                        |COUNTRYNAME                                                        |
+-------------------------------------------------------------------+-------------------------------------------------------------------+

Press CTRL-C to interrupt