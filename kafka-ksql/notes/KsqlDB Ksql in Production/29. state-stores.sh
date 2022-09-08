# confluent/etc/ksqldb/ksql-production-server.properties
ksql.streams.state.dir=/some/non-temporary-storage-path/

# in the demo, the state store dir is a working path resided in ksql-server.properties
# so list properties under ksql cli shows this path

# before stateful operation e.g. count()
# navigate to the path, should be empty
# note: this will show nothing
ls
find .
find /var/folders/1p/3whlrkzx4bs3fkd55_600x4c0000gp/T/confluent.V2kB1p2N/ksql-server/data/kafka-streams -type f 

# after stateful operation e.g. count()
# go to the same path again
# note: this will now show files
find .
find /var/folders/1p/3whlrkzx4bs3fkd55_600x4c0000gp/T/confluent.V2kB1p2N/ksql-server/data/kafka-streams -type f 

#################### UNIX system #############################

ksql-datagen schema=./datagen/userprofile.avro format=json topic=USERPROFILE key=userid maxInterval=5000 iterations=1000

#################### UNIX system - ksql #############################

CREATE STREAM userprofile (userid INT, firstname VARCHAR, lastname VARCHAR, countrycode VARCHAR, rating DOUBLE) \
  WITH (VALUE_FORMAT = 'JSON', KAFKA_TOPIC = 'USERPROFILE');
At UNIX

# Run a stateful operation, which should require RocksDB to persist to disk
select countrycode, count(*) from userprofile group by countrycode;
At UNIX

