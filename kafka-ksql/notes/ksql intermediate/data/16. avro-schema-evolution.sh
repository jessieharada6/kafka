
#################### UNIX system - confluent cli #############################
confluent local services status
confluent local services start

kafka-avro-console-producer  --broker-list localhost:9092 --topic COMPLAINTS_AVRO \
--property value.schema='
{
  "type": "record",
  "name": "myrecord",
  "fields": [
      {"name": "customer_name",  "type": "string" }
    , {"name": "complaint_type", "type": "string" }
    , {"name": "trip_cost", "type": "float" }
    , {"name": "new_customer", "type": "boolean"}
    , {"name": "number_of_rides", "type": "int", "default" : 1}
  ]
}'
{"customer_name":"Ed", "complaint_type":"Dirty car", "trip_cost": 29.10, "new_customer": false, "number_of_rides": 22}


#################### UNIX system - ksql #############################
select * from COMPLAINTS_AVRO emit changes;
# reading version 1
+------------------------------------------------------+------------------------------------------------------+------------------------------------------------------+------------------------------------------------------+
|CUSTOMER_NAME                                         |COMPLAINT_TYPE                                        |TRIP_COST                                             |NEW_CUSTOMER                                          |
+------------------------------------------------------+------------------------------------------------------+------------------------------------------------------+------------------------------------------------------+
|Ed                                                    |Dirty car                                             |29.100000381469727                                    |false                                                 |


create stream complaints_avro_v2 with (kafka_topic='COMPLAINTS_AVRO', value_format='AVRO');

select * from COMPLAINTS_AVRO_v2;
+-------------------------------------------+-------------------------------------------+-------------------------------------------+-------------------------------------------+-------------------------------------------+
|CUSTOMER_NAME                              |COMPLAINT_TYPE                             |TRIP_COST                                  |NEW_CUSTOMER                               |NUMBER_OF_RIDES                            |
+-------------------------------------------+-------------------------------------------+-------------------------------------------+-------------------------------------------+-------------------------------------------+
|Ed                                         |Dirty car                                  |29.100000381469727                         |false                                      |22                                         |

# older schema shown as null at number of rides
+-------------------------------------------+-------------------------------------------+-------------------------------------------+-------------------------------------------+-------------------------------------------+
|CUSTOMER_NAME                              |COMPLAINT_TYPE                             |TRIP_COST                                  |NEW_CUSTOMER                               |NUMBER_OF_RIDES                            |
+-------------------------------------------+-------------------------------------------+-------------------------------------------+-------------------------------------------+-------------------------------------------+
|Carol                                      |Late arrival                               |19.600000381469727                         |false                                      |null      
#################### Chrome #############################
# control centre 
http://localhost:9021/clusters

http://localhost:9021/clusters/TwmQnBhASiGkLzJ6LaAfzw/management/topics/COMPLAINTS_AVRO/schema/value
schema updated to v2
v1 is the previous version
http://localhost:9021/clusters/TwmQnBhASiGkLzJ6LaAfzw/management/topics/COMPLAINTS_AVRO/schema/value