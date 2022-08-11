# Download the kafka binary, after exporting the path
# Place the kafka binary at the $Home directory

# Run the following two files at two diff terminal windows

# 1. Run the bash file for zookeeper to start zookeeper server for cluster management
zookeeper-server-start.sh ~/kafka_2.13-3.2.1/config/zookeeper.properties

# 2. Run the bash file for kafka to launch kafka broker
kafka-server-start.sh ~/kafka_2.13-3.2.1/config/server.properties

# 3. need to remain the terminals open to keep the kafka started