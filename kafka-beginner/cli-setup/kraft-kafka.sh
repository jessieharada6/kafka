# Download the kafka binary, after exporting the path
# Place the kafka binary at the $Home directory

# At $HOME directory:
# 1. generate a new ID for your cluster
kafka-storage.sh random-uuid
# 2. use the generated ID as <uuid>
kafka-storage.sh format -t <uuid> -c ~/kafka_2.13-3.2.1/config/kraft/server.properties
# It will generate a tmp log, this is where kafka data is to be stored
# 3. Launch the broker
kafka-server-start.sh ~/kafka_2.13-3.0.0/config/kraft/server.properties