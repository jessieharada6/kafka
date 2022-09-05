
############################# Topic #############################
# create a topic
kafka-topics.sh --create --bootstrap-server localhost:9092 --topic USERPROFILE --replication-factor 1 --partitions 1

# write data
jessieharada@Jessies-MacBook-Pro ~ % 
# kafka-console-producer.sh --broker-list localhost:9092 --topic USERPROFILE << EOF                                   
heredoc> {"userid": 1000, "firstname": "Alison", "lastname": "Smith", "countrycode": "GB", "rating": 4.7}
heredoc> EOF

############################# KSQL #############################
# list topics
list topics;

 Kafka Topic                 | Partitions | Partition Replicas 
---------------------------------------------------------------
 USERPROFILE                 | 1          | 1                  
 USERS                       | 1          | 1                  
 default_ksql_processing_log | 1          | 1                  
---------------------------------------------------------------

# create streams, json format 
CREATE STREAM userprofile (userid INT, firstname VARCHAR, lastname VARCHAR, countrycode VARCHAR, rating DOUBLE) \
>WITH (VALUE_FORMAT = 'JSON', KAFKA_TOPIC = 'USERPROFILE')
>;

# output
 Message        
----------------
 Stream created 
----------------

# list streams
list streams;

 Stream Name         | Kafka Topic                 | Key Format | Value Format | Windowed 
------------------------------------------------------------------------------------------
 KSQL_PROCESSING_LOG | default_ksql_processing_log | KAFKA      | JSON         | false    
 USERPROFILE         | USERPROFILE                 | KAFKA      | JSON         | false    
------------------------------------------------------------------------------------------

# desribe the stream
describe userprofile;

Name                 : USERPROFILE
 Field       | Type            
-------------------------------
 USERID      | INTEGER         
 FIRSTNAME   | VARCHAR(STRING) 
 LASTNAME    | VARCHAR(STRING) 
 COUNTRYCODE | VARCHAR(STRING) 
 RATING      | DOUBLE          
-------------------------------

# query
select firstname, lastname, countrycode, rating from userprofile;
+--------------------------------+--------------------------------+--------------------------------+--------------------------------+
|FIRSTNAME                       |LASTNAME                        |COUNTRYCODE                     |RATING                          |
+--------------------------------+--------------------------------+--------------------------------+--------------------------------+
|Alison                          |Smith                           |GB                              |4.7                             |
Query Completed
Query terminated

# to not terminate
select firstname, lastname, countrycode, rating from userprofile emit changes;
+--------------------------------+--------------------------------+--------------------------------+--------------------------------+
|FIRSTNAME                       |LASTNAME                        |COUNTRYCODE                     |RATING                          |
+--------------------------------+--------------------------------+--------------------------------+--------------------------------+
|Alison                          |Smith                           |GB                              |4.7                             |

Press CTRL-C to interrupt

# can use kafka-console-producer.sh to continue producing data with emit changes