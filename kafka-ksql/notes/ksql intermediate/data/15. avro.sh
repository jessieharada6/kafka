######################## At UNIX prompt - outside ksql in confluent api  ########################

kafka-topics.sh --bootstrap-server localhost:9092 --create --partitions 1 --replication-factor 1 --topic COMPLAINTS_AVRO

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
  ]
}'
# don't enter, just paste the data below straightaway, otherwise system thinks it is null
{"customer_name":"Carol", "complaint_type":"Late arrival", "trip_cost": 19.60, "new_customer": false}

# bad data at new_customer not boolean
{"customer_name":"Bad Data", "complaint_type":"Bad driver", "trip_cost": 22.40, "new_customer": ShouldBeABoolean}
# immediately caught, instead of being delayed and can only find in the server log
# org.apache.kafka.common.errors.SerializationException: Error deserializing json {"customer_name":"Bad Data", "complaint_type":"Bad driver", "trip_cost": 22.40, "new_customer": ShouldBeABoolean} to Avro of schema 

######################## At KSQL prompt ########################
print 'COMPLAINTS_AVRO' from beginning;

Key format: ¯\_(ツ)_/¯ - no data processed
Value format: AVRO
rowtime: 2022/09/06 04:50:41.333 Z, key: <null>, value: {"customer_name": "Carol", "complaint_type": "Late arrival", "trip_cost": 19.6, "new_customer": false}, partition: 0

Press CTRL-C to interrupt

# Note no columns or data type specified
create stream complaints_avro with (kafka_topic='COMPLAINTS_AVRO', value_format='AVRO');

select * from complaints_avro emit changes;

######################## At UNIX prompt - after exporting path ########################
# tail log
confluent local services ksql-server log -f

