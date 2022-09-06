#################### UNIX system - confluent cli #############################
ksql-datagen schema=/Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/datagen/riderequest-europe.avro  format=avro topic=riderequest-europe key=rideid msgRate=1 iterations=1000

ksql-datagen schema=/Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/datagen/riderequest-america.avro format=avro topic=riderequest-america key=rideid msgRate=1 iterations=1000

#################### UNIX system - ksql #############################

create stream rr_america_raw with (kafka_topic='riderequest-america', value_format='avro');  

create stream rr_europe_raw with (kafka_topic='riderequest-europe', value_format='avro');   

select * from rr_america_raw emit changes; 

select * from rr_europe_raw emit changes;

# CREATE A NEW STREAM
# 'Europe' constant alias with data_source 
# data_source column as psudo column 
# any records from rr_europe_raw stream will show 'Europe' at the data_source column
create stream rr_world as select 'Europe' as data_source, * from rr_europe_raw;  

# any records from rr_america_raw stream will show 'Americas' at the data_source column
# merge with another stream
insert into rr_world      select 'Americas' as data_source, * from rr_america_raw;  

select * from rr_world emit changes; 
+------------------------------+------------------------------+------------------------------+------------------------------+------------------------------+------------------------------+------------------------------+
|DATA_SOURCE                   |REQUESTTIME                   |LATITUDE                      |LONGITUDE                     |RIDEID                        |USER                          |CITY_NAME                     |
+------------------------------+------------------------------+------------------------------+------------------------------+------------------------------+------------------------------+------------------------------+
|Europe                        |1662449131675                 |53.13925879452967             |1.4721421850157625            |ride_954                      |Bob                           |London                        |
|Americas                      |1662449131865                 |38.93131860357609             |-116.88401747903407           |ride_903                      |Niaj                          |San Francisco                 |
|Europe                        |1662449132675                 |50.28466025198737             |1.4813824192600435            |ride_592                      |Alice                         |Newcastle                     |
|Americas                      |1662449132865                 |40.79452525612581             |-114.35260463784209           |ride_330                      |Trudy                         |San Francisco                 |
|Europe                        |1662449133671                 |50.50786973452418             |-0.49605882095814247          |ride_980                      |Heidi                         |Newcastle                     |
|Americas                      |1662449133867                 |39.37506988892278             |-101.12982798064485           |ride_785                      |Judy                          |San Diego                     |

