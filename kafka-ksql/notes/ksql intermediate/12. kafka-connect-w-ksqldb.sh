# /Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/docker-compose.yml
docker-compose up -d
# kill ports if address in use


################ POSTGRES: interact with postgres db ################
# at the same location as docker-compose up -d
cat postgres-setup.sql
CREATE TABLE carusers (
    username VARCHAR
  , ref SERIAL PRIMARY KEY
  );

INSERT INTO carusers (username) VALUES ('Alice');
INSERT INTO carusers (username) VALUES ('Bob');
INSERT INTO carusers (username) VALUES ('Charlie');

# create postgres table
docker-compose exec postgres psql -U postgres -f /postgres-setup.sql
# output
CREATE TABLE
INSERT 0 1
INSERT 0 1
INSERT 0 1

# see postgres table
docker-compose exec postgres psql -U postgres -c "select * from carusers;"
 username | ref 
----------+-----
 Alice    |   1
 Bob      |   2
 Charlie  |   3
(3 rows)


################ KSQL DB CLI - create source connector ################
# restart the ksql using 1.confluent-cli.sh and run
CREATE SOURCE CONNECTOR `postgres_jdbc_source` WITH(
>  "connector.class"='io.confluent.connect.jdbc.JdbcSourceConnector',
>  "connection.url"='jdbc:postgresql://postgres:5432/postgres',
>  "mode"='incrementing',
>  "incrementing.column.name"='ref',
>  "table.whitelist"='carusers',
>  "connection.password"='password',
>  "connection.user"='postgres',
>  "topic.prefix"='db-',
>  "key"='username');

 Message                                
----------------------------------------
 Created connector postgres_jdbc_source 
----------------------------------------

# see data streamed in from the newly created kafka topic
print 'db-carusers' from beginning;

Key format: KAFKA_STRING
Value format: AVRO or KAFKA_STRING
rowtime: 2022/09/05 10:16:19.069 Z, key: Alice, value: {"username": "Alice", "ref": 1}
rowtime: 2022/09/05 10:16:19.077 Z, key: Bob, value: {"username": "Bob", "ref": 2}
rowtime: 2022/09/05 10:16:19.078 Z, key: Charlie, value: {"username": "Charlie", "ref": 3}


################################################################
# in the other window where docker ran 
docker exec -it postgres psql -U postgres -c "INSERT INTO carusers (username) VALUES ('Derek');"

INSERT 0 1

# see the data streamed 
print 'db-carusers' from beginning;

Key format: KAFKA_STRING
Value format: AVRO or KAFKA_STRING
rowtime: 2022/09/05 10:16:19.069 Z, key: Alice, value: {"username": "Alice", "ref": 1}
rowtime: 2022/09/05 10:16:19.077 Z, key: Bob, value: {"username": "Bob", "ref": 2}
rowtime: 2022/09/05 10:16:19.078 Z, key: Charlie, value: {"username": "Charlie", "ref": 3}
rowtime: 2022/09/05 10:20:52.275 Z, key: Derek, value: {"username": "Derek", "ref": 4}

Press CTRL-C to interrupt