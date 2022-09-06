# Locate TaxiWait.java

# package into jar in target folder
mvn clean package 

# the jar will move to ksql server
#################### UNIX system - ksql #############################
ksql> list properties;

 Property                                               | Scope | Default override | Effective Value                                                                                                                            
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 ksql.extension.dir                                     | KSQL  | SERVER           | /etc/ksql/ext                                                                                                                             

 # shutdown ksql server 
 confluent local services status
 confluent local services ksql-server stop

 # based on the dir and the confluent folder relative to opt
 mkdir /opt/confluent/etc/ksql/ext        

# copy jar to the file
jessieharada@Jessies-MacBook-Pro ext % cp /Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/java/pre-compiled/ksql-udf-taxi-1.0.jar .
jessieharada@Jessies-MacBook-Pro ext % ls
ksql-udf-taxi-1.0.jar
jessieharada@Jessies-MacBook-Pro ext % pwd
/opt/confluent/etc/ksql/ext
jessieharada@Jessies-MacBook-Pro ext % 

# start ksql server
confluent local services ksql-server start

ksql

list functions;

 Function Name         | Category           
--------------------------------------------
TAXI_WAIT             | OTHER   

describe function taxi_wait;

Name        : TAXI_WAIT
Overview    : Return expected wait time in minutes
Type        : SCALAR
Jar         : /etc/ksql/ext/ksql-udf-taxi-1.0.jar
Variations  : 