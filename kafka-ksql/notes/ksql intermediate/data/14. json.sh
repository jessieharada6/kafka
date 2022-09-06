######################## At UNIX prompt - ksql  ########################

kafka-topics.sh --bootstrap-server localhost:9092 --create --partitions 1 --replication-factor 1 --topic COMPLAINTS_JSON

kafka-console-producer.sh --broker-list localhost:9092 --topic COMPLAINTS_JSON
{"customer_name":"Alice, Bob and Carole", "complaint_type":"Bad driver", "trip_cost": 22.40, "new_customer": true}
# bad data at new_customer not boolean
{"customer_name":"Bad Data", "complaint_type":"Bad driver", "trip_cost": 22.40, "new_customer": ShouldBeABoolean}


######################## At KSQL prompt ########################

CREATE STREAM complaints_json (customer_name VARCHAR, complaint_type VARCHAR, trip_cost DOUBLE, new_customer BOOLEAN) \
  WITH (VALUE_FORMAT = 'JSON', KAFKA_TOPIC = 'COMPLAINTS_JSON');

select * from complaints_json emit changes;


######################## At UNIX prompt - after exporting path ########################
# tail log
confluent local services ksql-server log -f

# bad data
Caused by: com.fasterxml.jackson.core.JsonParseException: Unrecognized token 'ShouldBeABoolean': was expecting (JSON String, Number, Array, Object or token 'null', 'true' or 'false')
