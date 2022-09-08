#################### UNIX system #############################
confluent local services stop
confluent local destroy    # reset 

cd /opt/confluent/etc/ksqldb
vi ksql-server.properties

# add this line anywhere in file 
# # server level
ksql.service.id=myservicename

confluent start ksql-server
#################### UNIX system - ksql #############################
ksql

# server level, shown at default override
LIST PROPERTIES; # show the settings for ksql.service.id

 Property                                               | Default override | Effective Value
---------------------------------------------------------------------------------------------------
 ksql.schema.registry.url                               | SERVER           | http://localhost:8081
 ksql.streams.auto.offset.reset                         | SERVER           | latest
 ksql.service.id                                        | SERVER           | myservicename          <-- *** Note: this is the one we changed

# session level
SET 'auto.offset.reset'='earliest';

LIST PROPERTIES; 


 Property                                               | Default override | Effective Value
----------------------------------------------------------------------------------------------------
 ksql.schema.registry.url                               | SERVER           | http://localhost:8081
 ksql.streams.auto.offset.reset                         | SESSION          | earliest                <-- *** Note both the override and Value cahnges
 ksql.service.id                                        | SERVER           | myservicename      