#################### UNIX system - confluent cli #############################
ksql-datagen schema=/Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/datagen/riderequest-europe.avro  format=avro topic=riderequest-europe key=rideid msgRate=1 iterations=1000

ksql-datagen schema=/Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/datagen/riderequest-america.avro format=avro topic=riderequest-america key=rideid msgRate=1 iterations=1000

#################### UNIX system - ksql #############################
select * from rr_world emit changes;

# create a new stream, joining rr_world stream and weathernow table
create stream requested_journey as
select rr.latitude as from_latitude
, rr.longitude as from_longitude
, rr.user
, rr.city_name as city_name
, w.city_country
, w.latitude as to_latitude
, w.longitude as to_longitude
, w.description as weather_description
, w.rain 
from rr_world rr 
left join weathernow w on rr.city_name = w.city_name;   

select * from requested_journey emit changes;
+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+
|CITY_NAME              |FROM_LATITUDE          |FROM_LONGITUDE         |USER                   |CITY_COUNTRY           |TO_LATITUDE            |TO_LONGITUDE           |WEATHER_DESCRIPTION    |RAIN                   |
+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+
|London                 |49.87476782922378      |1.1886189524974533     |Bob                    |null                   |null                   |null                   |null                   |null                   |
|San Francisco          |44.16198922353685      |-111.13169065222922    |Trudy                  |US                     |37.7749                |-122.4194              |SUNNY                  |10.0                   |
|Bristol                |50.248844824407655     |0.8455658228893661     |Dan                    |null                   |null                   |null                   |null                   |null                   |
|Fresno                 |44.74896454103886      |-109.844216657084      |Niaj                   |null                   |null                   |null                   |null                   |null                   |
|Bristol                |51.81899281659234      |-0.0072881040445436085 |Dan                    |null                   |null                   |null                   |null                   |null                   |
|San Francisco          |40.34661884322507      |-101.4896911197896     |Peggy                  |US                     |37.7749                |-122.4194              |SUNNY                  |10.0                   |
|London                 |49.67132138304884      |1.5158749797498179     |Bob                    |null                   |null                   |null                   |null                   |null                   |
|San Francisco          |37.88782057539051      |-111.1185282612499     |Judy                   |US                     |37.7749                |-122.4194              |SUNNY                  |10.0                   |
|London                 |51.68814257810523      |0.20950896716909195    |Frank                  |null                   |null                   |null                   |null                   |null                   |
|Fresno                 |39.9538950859085       |-104.6223637854129     |Sybil                  |null                   |null                   |null                   |null                   |null                   |
|London                 |49.73062915795788      |-1.7360481994647792    |Heidi                  |null                   |null                   |null                   |null                   |null                   |
|San Diego              |38.618845251648715     |-121.0209041600004     |Sybil                  |US                     |32.7157                |-117.1611              |SUNNY                  |2.0                    |
|London                 |51.77554476339464      |-1.7662568970674402    |Frank                  |null                   |null                   |null                   |null                   |null                   |

# another stream
# GEO_DISTANCE - projected distance from source to destination
create stream ridetodest as 
select user
, city_name
, city_country
, weather_description
, rain 
, GEO_DISTANCE(from_latitude, from_longitude, to_latitude, to_longitude, 'km') as dist
from requested_journey;  

select * from ridetodest emit changes;

+-----------------------------------+-----------------------------------+-----------------------------------+-----------------------------------+-----------------------------------+-----------------------------------+
|CITY_NAME                          |USER                               |CITY_COUNTRY                       |WEATHER_DESCRIPTION                |RAIN                               |DIST                               |
+-----------------------------------+-----------------------------------+-----------------------------------+-----------------------------------+-----------------------------------+-----------------------------------+
|Liverpool                          |Heidi                              |null                               |null                               |null                               |null                               |
|Seattle                            |Judy                               |null                               |null                               |null                               |null                               |
|London                             |Heidi                              |null                               |null                               |null                               |null                               |
|San Francisco                      |Mike                               |US                                 |SUNNY                              |10.0                               |578.965713386879                   |
|Birmingham                         |Dan                                |null                               |null                               |null                               |null                               |
|San Francisco                      |Mike                               |US                                 |SUNNY                              |10.0                               |1515.3741365501276                 |
|London                             |Grace                              |null                               |null                               |null                               |null                               |
|San Diego                          |Judy                               |US                                 |SUNNY                              |2.0                                |1287.597102093436                  |
|London                             |Grace                              |null                               |null                               |null                               |null                               |
|San Francisco                      |Trudy                              |US                                 |SUNNY                              |10.0                               |249.98381090847278                 |
|Bristol                            |Dan                                |null                               |null                               |null                               |null                               |
|San Francisco                      |Oscar                              |US                                 |SUNNY                              |10.0                               |573.4173299155158                  |
|Liverpool                          |Carol                              |null                               |null                               |null                               |null                               |
|San Francisco                      |Niaj                               |US                                 |SUNNY                              |10.0                               |508.6211800358402                  |
|Birmingham                         |Dan                                |null                               |null                               |null                               |null                               |
|San Diego                          |Oscar                              |US                                 |SUNNY                              |2.0                                |1127.9541131095816                 |
|London                             |Carol                              |null                               |null                               |null                               |null                               |
|San Francisco                      |Mike                               |US                                 |SUNNY                              |10.0                               |549.8728277008264                  |
|Bristol                            |Carol                              |null                               |null                               |null                               |null                               |
|Los Angeles                        |Trudy                              |null                               |null                               |null                               |null                               |
|Bristol                            |Dan                                |null                               |null                               |null                               |null                               |
|San Francisco                      |Sybil                              |US                                 |SUNNY                              |10.0                               |338.1164730602011                  |
|Manchester                         |Heidi                              |GB                                 |SUNNY                              |3.0                                |455.9801563273952                  |
|San Francisco                      |Peggy                              |US                                 |SUNNY                              |10.0                               |1115.1595507364223                 |


# build reports
select user + ' is travelling ' + cast(round(dist) as varchar) +' km to ' + city_name + ' where the weather is reported as ' + weather_description 
from ridetodest emit changes;  

Alice is at (52,0) and is travelling 215 km to Manchester where it is SUNNY
Heidi is at (51,-1) and is travelling 88 km to London where it is heavy rain
Grace is at (50,-1) and is travelling 138 km to London where it is heavy rain