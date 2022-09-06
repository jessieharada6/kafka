######################## At UNIX prompt - ksql  ########################

kafka-topics.sh --bootstrap-server localhost:9092 --create --partitions 1 --replication-factor 1 --topic COMPLAINTS_CSV

kafka-console-producer.sh --broker-list localhost:9092 --topic COMPLAINTS_CSV
Alice, Late arrival, 43.10, true

## CSV - experience with bad data
# At UNIX prompt, enter bad data, ksql will not show
Alice, Bob and Carole, Bad driver, 43.10, true


######################## At KSQL prompt ########################

CREATE STREAM complaints_csv (customer_name VARCHAR, complaint_type VARCHAR, trip_cost DOUBLE, new_customer BOOLEAN) \
  WITH (VALUE_FORMAT = 'DELIMITED', KAFKA_TOPIC = 'COMPLAINTS_CSV');

select * from complaints_csv emit changes;


######################## At UNIX prompt - after exporting path ########################
confluent local services ksql-server log
# tail
confluent local services ksql-server log -f
