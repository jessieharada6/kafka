####################################Producer to offer data so ksql can query ####################################
# taxi system 
kafka-topics.sh --create --bootstrap-server localhost:9092 --topic USERS --replication-factor 1 --partitions 1
kafka-console-producer.sh --broker-list localhost:9092 --topic USERS
>Alice, US
>Bob, GB
>Carole, AU
>Dan, US
>Ella, JP