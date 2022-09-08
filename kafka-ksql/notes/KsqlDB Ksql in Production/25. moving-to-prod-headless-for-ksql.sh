# Headless KSQL server cluster is not aware of anys streams or tables you defined in other (interactive) KSQL clusters.
# where-is-bob.ksql is the app, we need to put all commands in one file for headless mode

confluent local services ksql-server stop

# go to the current folder
# ksql-server.properties comment out the schema registry part 
# https://stackoverflow.com/questions/69145272/ksqldb-issue-setting-schema-registry
/opt/confluent/bin/ksql-server-start /opt/confluent/etc/ksqldb/ksql-server.properties  --queries-file ./where-is-bob.ksql  

# show CLI does not work - seems working for me?
ksql

# check if BOB topic exists
kafka-topics.sh --bootstrap-server localhost:9092 --list --topic BOB 

confluent local services start
# could not get read
kafka-avro-console-consumer --bootstrap-server localhost:9092 --topic BOB 
kafka-avro-console-consumer --topic BOB \
    --bootstrap-server 127.0.0.1:9092 \
    --property schema.registry.url=http://127.0.0.1:8081 \
    --from-beginning

# Each headless server is in theory independent (ie., can't interact with other servers or a CLI, but  using a unique ksql.service.id). 
# In reality, you can't reuse things that might collide (such as topic names or schemas). 
# I think the behaviour of the second headless server will error (ideally) or just behave strangly
# If a headless server has an error (eg., a syntax error in the ksql) it won't start. 