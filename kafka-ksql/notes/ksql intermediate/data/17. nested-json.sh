#################### UNIX system - confluent cli #############################
# Imagine we have data like this

{
  "city": {
    "name": "Sydney",
    "country": "AU",
    "latitude": -33.8688, 
    "longitude": 151.2093
  },
  "description": "light rain",
  "clouds": 92,
  "deg": 26,
  "humidity": 94,
  "pressure": 1025.12,
  "rain": 1.25  
}

kafka-topics.sh --bootstrap-server localhost:9092 --create --partitions 1 --replication-factor 1 --topic WEATHERNESTED

cat /Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/demo-weather.json | kafka-console-producer --broker-list localhost:9092 --topic WEATHERNESTED

#################### UNIX system - ksql #############################

CREATE STREAM weather 
      (city STRUCT <name VARCHAR, country VARCHAR, latitude DOUBLE, longitude DOUBLE>, 
       description VARCHAR, 
       clouds BIGINT, 
       deg BIGINT, 
       humidity BIGINT, 
       pressure DOUBLE, 
       rain DOUBLE) 
WITH (KAFKA_TOPIC='WEATHERNESTED', VALUE_FORMAT='JSON');  

SELECT city->name AS city_name, city->country AS city_country, city->latitude as latitude, city->longitude as longitude, description, rain from weather emit changes;  
+-----------------------------------+-----------------------------------+-----------------------------------+-----------------------------------+-----------------------------------+-----------------------------------+
|CITY_NAME                          |CITY_COUNTRY                       |LATITUDE                           |LONGITUDE                          |DESCRIPTION                        |RAIN                               |
+-----------------------------------+-----------------------------------+-----------------------------------+-----------------------------------+-----------------------------------+-----------------------------------+
|Sydney                             |AU                                 |-33.8688                           |151.2093                           |light rain                         |1.25                               |