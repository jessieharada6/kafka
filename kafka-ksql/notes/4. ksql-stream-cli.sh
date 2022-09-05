################################## KSQL Stream ####################################
# make sure ksql is up and running, topic is ready 
ksql
list topics;

# Messages in a stream


# Create stream, specify the data format, topic is 'USERS', and how the value is delimited, it is comma in this case
# Dan, US
create stream users_stream (name VARCHAR, countrycode VARCHAR) WITH (KAFKA_TOPIC='USERS', VALUE_FORMAT='DELIMITED');

list streams;
# in the course, it says it doesn't show the list, but i saw the list being printed
select name, countrycode from users_stream;
+-------------------------------------------------------------------+-------------------------------------------------------------------+
|NAME                                                               |COUNTRYCODE                                                        |
+-------------------------------------------------------------------+-------------------------------------------------------------------+
|Alice                                                              | US                                                                |
|Bob                                                                | GB                                                                |
|Carole                                                             | AU                                                                |
|Dan                                                                | US                                                                |
|Grant                                                              | JP                                                                |
Query Completed
Query terminated

# take effect for the current session, this seems unnecessary for me, as it printed the values from earliest as above alr
Set 'auto.offset.reset'='earliest';

# wait for new data
select name, countrycode from users_stream emit changes;
+-------------------------------------------------------------------+-------------------------------------------------------------------+
|NAME                                                               |COUNTRYCODE                                                        |
+-------------------------------------------------------------------+-------------------------------------------------------------------+
|Alice                                                              | US                                                                |
|Bob                                                                | GB                                                                |
|Carole                                                             | AU                                                                |
|Dan                                                                | US                                                                |
|Grant                                                              | JP                                                                |
|Gigi                                                               | KR                                                                |

Press CTRL-C to interrupt

# limit 4
select name, countrycode from users_stream limit 4;
+-------------------------------------------------------------------+-------------------------------------------------------------------+
|NAME                                                               |COUNTRYCODE                                                        |
+-------------------------------------------------------------------+-------------------------------------------------------------------+
|Alice                                                              | US                                                                |
|Bob                                                                | GB                                                                |
|Carole                                                             | AU                                                                |
|Dan                                                                | US                                                                |
Limit Reached
Query terminated


# group by - emit changes (indicates push query for ksql 5.3 and above, before 5.3 push is default )
# can update live
select countrycode, count(*) from users_stream group by countrycode emit changes;
+-------------------------------------------------------------------+-------------------------------------------------------------------+
|COUNTRYCODE                                                        |KSQL_COL_0                                                         |
+-------------------------------------------------------------------+-------------------------------------------------------------------+
| GB                                                                |1                                                                  |
| JP                                                                |1                                                                  |
| KR                                                                |1                                                                  |
| US                                                                |3                                                                  |
| AU                                                                |2                                                                  |

Press CTRL-C to interrupt

select countrycode, count(*) from users_stream group by countrycode;
# error: Pull queries don't support GROUP BY clauses

# delete stream and topic
drop stream if exists users_stream delete topic;

 Message                                           
---------------------------------------------------
 Source `USERS_STREAM` (topic: USERS) was dropped. 
---------------------------------------------------

show streams;

 Stream Name         | Kafka Topic                 | Key Format | Value Format | Windowed 
------------------------------------------------------------------------------------------
 KSQL_PROCESSING_LOG | default_ksql_processing_log | KAFKA      | JSON         | false    
------------------------------------------------------------------------------------------

show topics;

 Kafka Topic                 | Partitions | Partition Replicas 
---------------------------------------------------------------
 default_ksql_processing_log | 1          | 1                  
---------------------------------------------------------------


