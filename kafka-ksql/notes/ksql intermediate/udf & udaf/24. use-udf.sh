#################### UNIX system - confluent cli #############################
ksql-datagen schema=/Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/datagen/riderequest-europe.avro  format=avro topic=riderequest-europe key=rideid msgRate=1 iterations=1000

ksql-datagen schema=/Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/datagen/riderequest-america.avro format=avro topic=riderequest-america key=rideid msgRate=1 iterations=1000


#################### UNIX system - ksql #############################
select * from ridetodest emit changes;

select user 
, round(dist) as dist
, weather_description
, round(TAXI_WAIT(weather_description, dist)) as taxi_wait_min 
from ridetodest emit changes; 

/Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/java/pre-compiled/ksql-udf-taxi-1.0.jar