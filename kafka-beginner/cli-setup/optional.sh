### change .properties DIR - optional - https://www.conduktor.io/kafka/how-to-install-apache-kafka-on-mac
# Optional: Changing the Kafka and Zookeeper data storage directory

# For Zookeeper:

# edit the zookeeper.properties file at 
~/kafka_2.13-3.0.0/config/zookeeper.properties 
# and set the following to your heart's desire dataDir=/your/path/to/data/zookeeper
# you can also make a copy of the zookeeper.properties file anywhere in your computer and edit that file instead, and reference it in the Zookeeper start command shown above

# For Kafka:

# edit the server.properties file at 
~/kafka_2.13-3.0.0/config/server.properties
# and set the following to your heart's desire log.dirs=/your/path/to/data/kafka
# you can also make a copy of the server.properties file anywhere in your computer and edit that file instead, and reference it in the Zookeeper start command shown above