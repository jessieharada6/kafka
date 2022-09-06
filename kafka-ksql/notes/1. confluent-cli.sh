download zip https://www.confluent.io/installation/
in terminal, go to downloads

sudo mv confluent-7.2.1 /opt
cd /opt     
sudo ln -s confluent-7.2.1 confluent  # symbolic link the folder to use confluent as path
ls /opt/confluent/bin                 # try the path

# path
export PATH=${PATH}:/opt/confluent/bin 
export CONFLUENT_HOME=/opt/confluent 

kafka-topics                            # to check if the installation is successful

# --- ALTERNATIVELY
# can also use docker for ksql
docker run -it --rm --net=host confluentinc/cp-ksql-server bash   


# START:
# command to start 
confluent local services ksql-server start


# if next time, confluent command is not found
sudo rm confluent
# then add symbolic link and export path again

confluent local services status 

# connect ksql cli to ksqldb server
ksql
# CLI v7.2.1, Server v7.2.1 located at http://localhost:8088
# Server Status: RUNNING
