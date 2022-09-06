#################### UNIX system - confluent cli #############################
ksql-datagen schema=/Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/datagen/riderequest-europe.avro  format=avro topic=riderequest-europe key=rideid msgRate=1 iterations=1000

ksql-datagen schema=/Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/datagen/riderequest-america.avro format=avro topic=riderequest-america key=rideid msgRate=1 iterations=1000

#################### UNIX system - ksql #############################
# count(*) group by
select data_source, city_name, count(*) 
from rr_world 
window tumbling (size 60 seconds) 
group by data_source, city_name emit changes;  

+-------------------------------------------------------------------------+-------------------------------------------------------------------------+-------------------------------------------------------------------------+
|DATA_SOURCE                                                              |CITY_NAME                                                                |KSQL_COL_0                                                               |
+-------------------------------------------------------------------------+-------------------------------------------------------------------------+-------------------------------------------------------------------------+
|Americas                                                                 |Los Angeles                                                              |1                                                                        |
|Europe                                                                   |Liverpool                                                                |1                                                                        |
|Americas                                                                 |San Francisco                                                            |1                                                                        |
|Europe                                                                   |London                                                                   |1                                                                        |
|Europe                                                                   |Birmingham                                                               |1                                                                        |
|Americas                                                                 |San Diego                                                                |1                                                                        |
|Europe                                                                   |Newcastle                                                                |1                                                                        |
|Americas                                                                 |San Francisco                                                            |3                                                                        |
|Europe                                                                   |Liverpool                                                                |2                                                                        |
|Europe                                                                   |Birmingham                                                               |2                                                                        |

# COLLECT_LIST
select data_source, city_name, COLLECT_LIST(user)
from rr_world 
window tumbling (size 60 seconds) 
group by data_source, city_name emit changes; 

+-------------------------------------------------------------------------+-------------------------------------------------------------------------+-------------------------------------------------------------------------+
|DATA_SOURCE                                                              |CITY_NAME                                                                |KSQL_COL_0                                                               |
+-------------------------------------------------------------------------+-------------------------------------------------------------------------+-------------------------------------------------------------------------+
|Europe                                                                   |London                                                                   |[Alice]                                                                  |
|Americas                                                                 |San Francisco                                                            |[Sybil]                                                                  |
|Europe                                                                   |London                                                                   |[Alice, Bob, Carol]                                                      |
|Americas                                                                 |San Francisco                                                            |[Sybil, Ted, Trudy]                                                      |

# topk, count(*), groupby, WindowStart, WindowEnd
select TIMESTAMPTOSTRING(WindowStart, 'HH:mm:ss')
, TIMESTAMPTOSTRING(WindowEnd, 'HH:mm:ss')
, data_source
, TOPK(city_name, 3)
, count(*)
FROM rr_world
WINDOW TUMBLING (SIZE 1 minute)
group by data_source
emit changes;

+-------------------------------------------+-------------------------------------------+-------------------------------------------+-------------------------------------------+-------------------------------------------+
|KSQL_COL_0                                 |KSQL_COL_1                                 |DATA_SOURCE                                |KSQL_COL_2                                 |KSQL_COL_3                                 |
+-------------------------------------------+-------------------------------------------+-------------------------------------------+-------------------------------------------+-------------------------------------------+
|08:37:00                                   |08:38:00                                   |Americas                                   |[San Francisco]                            |1                                          |
|08:37:00                                   |08:38:00                                   |Europe                                     |[London, Birmingham]                       |2                                          |
|08:37:00                                   |08:38:00                                   |Europe                                     |[Newcastle, London, London]                |4                                          |
|08:37:00                                   |08:38:00                                   |Americas                                   |[San Jose, San Francisco, San Diego]       |4                                          |
|08:37:00                                   |08:38:00                                   |Europe                                     |[Newcastle, London, London]                |6                                          |
|08:37:00                                   |08:38:00                                   |Americas                                   |[San Jose, San Francisco, San Francisco]   |6                                          |
|08:37:00                                   |08:38:00                                   |Europe                                     |[Newcastle, Newcastle, London]             |8                                          |
|08:37:00                                   |08:38:00                                   |Americas                                   |[Seattle, San Jose, San Francisco]         |8                                          |
|08:37:00                                   |08:38:00                                   |Europe                                     |[Newcastle, Newcastle, Newcastle]          |10                                         |
|08:37:00                                   |08:38:00                                   |Americas                                   |[Seattle, Seattle, San Jose]               |10                                         |